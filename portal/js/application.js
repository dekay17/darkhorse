(function(window, angular){
    "use strict";

    window.lavahound = {
        getCachedUrl: function (url) {
            var cachedUrl = cmt.cachedUrls[url];
            return cachedUrl ? cachedUrl : url;
        },
        creatLastUpdatedStatusMessage: function (lastUpdated) {
            return "Last updated at " + lastUpdated.format("h:mm:ss a").toUpperCase();
        },
        getUrlParameters: function (url) {
            url = url || window.location.href;
            var map = {};
            var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
                map[key] = value;
            });

            return map;
        },
        logging: {
            network: false,
            map: false
        },
        events: {
            SIGNED_IN: "SIGNED_IN",
            SIGNED_OUT: "SIGNED_OUT",
            SIGNED_IN_ACCOUNT_DATA_CHANGED: "SIGNED_IN_ACCOUNT_DATA_CHANGED"
        },
    	showErrors: function(errors, scope) {
    		console.log("errors", errors);
    	}
    };

    window.lavahound.app = angular.module("lavahoundApp", [
        "ui.bootstrap",
        "ngCookies",
        "ngRoute",
        "nvd3",
        "ngTable",
        "uiGmapgoogle-maps",
        'ngSanitize', 'ngCsv', 'ngAnimate'
    ]).config(function(uiGmapGoogleMapApiProvider) {
        uiGmapGoogleMapApiProvider.configure({
        	key: 'AIzaSyBMdkHOPs_501svWyksID8fs6gNykPb3Qs',
            v: '3.20',
            libraries: 'weather,geometry,visualization'
        });
    });
    

    window.lavahound.isDefined = function (value) {
        return value !== null && angular.isDefined(value);
    };
})(window, angular);