// Adding auth token to every request is implemented as an interceptor so it works for ng-views as well as API calls
lavahound.app.config(function ($httpProvider) {
    $httpProvider.interceptors.push(function ($q, $injector) {
        return {
            request: function (config) {
                // Load on-demand from injector to avoid circular dependency
                var accountService = $injector.get("accountService");
                if (accountService.signedIn()) {
                    var apiToken = accountService.signedInAccountApiToken();
                    config.headers["X-API-Token"] = apiToken;
//                    config.headers["X-API-Stateful"] = true;
                }

                return config || $q.when(config);
            }
        };
    });
});

lavahound.app.service("networkService", function ($http, $q, $log, $injector, $location, $rootScope) {
    var requestId = 0;
    var requestsByRequestId = {};
    var that = this;

    this.cancelAllRequests = function () {
        var inFlightRequestsCount = Object.keys(requestsByRequestId).length;

        if (lavahound.logging.network)
            $log.log("Canceling " + inFlightRequestsCount + " in-flight API requests...");

        angular.forEach(requestsByRequestId, function (request, requestId) {
            request.cancel();
        });

        requestsByRequestId = {};
    };

    this.makeCall = function (params) {
        params = params || {};

        var currentRequestId = ++requestId;
        var deferredResponse = $q.defer();
        var deferredCanceler = $q.defer();
        var canceled = false;

        if (!lavahound.isDefined(params.timeout))
            params.timeout = deferredCanceler.promise;

        logRequest();

        var apiCallStartTime = new Date().getTime();

        $http(params).success(function (data, status, headers, config) {
            delete requestsByRequestId[currentRequestId];

            logResponse(status, data);

            deferredResponse.resolve({
                data: data,
                status: status,
                headers: headers,
                config: config
            });
        }).error(function (data, status, headers, config) {
            delete requestsByRequestId[currentRequestId];

            if (canceled) {
                if (lavahound.logging.network)
                    $log.log("[API-" + currentRequestId + "] Canceled request for " + params.method + " " + params.url);

                return;
            }

            logResponse(status, data);

            if (status === 401 || status === 403) {
                if (lavahound.logging.network)
                    $log.log("[API-" + currentRequestId + "] Got " + status + " response for " + params.method + " " + params.url + ", automatically signing out...");

                var accountService = $injector.get("accountService");
                accountService.signOut();
                window.location = "/sign-in";
                return;
            }

            // Fake a response body for server down messages
            if (status === 0)
                data = {
                    description: lavahound.translate("Sorry, the server is unavailable right now. Please try again in a minute.")
                };

            deferredResponse.reject({
                data: data,
                status: status,
                headers: headers,
                config: config
            });
        });

        var request = {
            promise: deferredResponse.promise,
            cancel: function () {
                canceled = true;
                deferredCanceler.resolve();
            }
        };

        requestsByRequestId[currentRequestId] = request;

        return request;

        function logRequest() {
            var log = [ "[API-" + currentRequestId + "] Performing " + params.method + " " + params.url ];

            if (params.params && Object.keys(params.params).length > 0)
                log = [ log[0] + "\nQuery parameters:", params.params ];

            if (params.data) {
                log.push("\nRequest body:");
                log.push(params.data);
            }

            if (lavahound.logging.network)
                $log.log.apply($log, log);
        }

        function logResponse(status, data) {
            if (lavahound.logging.network) {
                var elapsedApiCallTime = new Date().getTime() - apiCallStartTime;
                var message = "[API-" + currentRequestId + "] Got HTTP " + status + " response in " + elapsedApiCallTime + "ms for " + params.method + " " + params.url;

                if (data)
                    $log.log(message + "\nResponse body:", data);
                else
                    $log.log(message);
            }
        }
    };

    $rootScope.$on(lavahound.events.SIGNED_OUT, function () {
        that.cancelAllRequests();
    });
});