window.lavahound.app.service("accountService", function($http, $cookies, networkService) {
	var SIGNED_IN_USER_COOKIE_NAME = "lavahound.signedInUser";
	var SIGNED_IN_USER_APITOKEN = "X-API-Token";
	var SIGNED_IN_USER_REMEMBERME_TOKEN = "rememberMeToken";
	var SIGNED_IN_USER_ROLES = "lavahound.signedInUser.roles";
	var SIGNED_IN_CURRENT_COMPANY = "lavahound.signedIn.company";

	var COMPANY_LOCATIONS = "lavahound.company.locations";
	var COMPANY_UNITS = "lavahound.company.units";
	var COMPANY_MANAGERS = "lavahound.company.managers";

	
	var that = this;

	this.authenticate = function(params) {
		params = params || {};

		return networkService.makeCall({
			method : "POST",
			url : "/api/sign-in",
			data : params
		});
	};

    this.hasRole = function(roleQuery) {
        if(!signedInUserRoles && signedInUserRoles.length !== 0)
            throw "SIGNED_IN_USER_ROLES is either empty or undefined.";

        for(var r = 0; r < signedInUserRoles.length; r ++) {
            var role = signedInUserRoles[r];

            if(role === roleQuery)
                return true;
        }

        return false;
    };

	this.deauthenticate = function(params) {
		params = params || {};

		return networkService.makeCall({
			method : "POST",
			url : "/api/accounts/sign-out"
		});
	};
	
	this.listAccounts = function(options) {
		return networkService.makeCall({
			method : "GET",
			url : "/api/accounts"
		});
	};
	
	this.companyManagers = function() {
		return readFromLocalStorage(COMPANY_MANAGERS);		
	};
	
	this.loadManagers = function() {
		networkService.makeCall({
			method : "GET",
			url : "/api/accounts/managers"
		}).promise.then(function(response) {
			writeToLocalStorage(COMPANY_MANAGERS, response.data.accounts);
		}, function(reason) {
			reject('Failed: ' + reason);
		});
	};

	this.setCompanyUnits = function(units) {
		writeToLocalStorage(COMPANY_UNITS, units);
	};
	
	this.companyUnits = function() {
		return readFromLocalStorage(COMPANY_UNITS);
	};
	
	this.loadUnits = function(options) {
		return networkService.makeCall({
			method : "GET",
			url : "/api/unit"
		}, function(reason) {
			reject('Failed: ' + reason);
		});		
	};
	
	this.companyLocations = function() {
		return readFromLocalStorage(COMPANY_LOCATIONS);
	};
	
	this.loadLocations = function(options) {
		return networkService.makeCall({
			method : "GET",
			url : "/api/location"
		}).promise.then(function(response) {
			console.log("completed reading locations");
			writeToLocalStorage(COMPANY_LOCATIONS, response.data.locations);
		}, function(reason) {
			reject('Failed: ' + reason);
		});
	};
	
	this.findAccount = function(params) {
		params = params || {};
		
		return networkService.makeCall({
			method : "GET",
			url : "/api/accounts/" + params.accountId
		});
	};
	
	this.updateAccount = function(params) {
		params = params || {};
		
		return networkService.makeCall({
			method : "POST",
			url : "/api/accounts/" + params.accountId,
			data: params
		});
	};
	
	this.createAccount = function(params) {
		params = params || {};
		
		return networkService.makeCall({
			method : "POST",
			url : "/api/accounts/",
			data: params				
		});
	};
	
	this.resetCredentials = function(account) {
		
		return networkService.makeCall({
			method : "PUT",
			url : "/api/accounts/" + account.accountId + "/reset",
		});
	};

	this.signedIn = function() {
		return lavahound.isDefined(this.signedInUser());
	};

	this.signedInUser = function() {
		return lavahound.isDefined($cookies[SIGNED_IN_USER_COOKIE_NAME]) ? $cookies[SIGNED_IN_USER_COOKIE_NAME] : null;
	};

	this.getSignedInUser = function() {
		return angular.copy(signedInUser);
	};

	this.signedInAccountApiToken = function() {
		if (lavahound.isDefined($cookies[SIGNED_IN_USER_APITOKEN]))
			return $cookies[SIGNED_IN_USER_APITOKEN];
		else
			return readFromLocalStorage(SIGNED_IN_USER_APITOKEN);
	};

	this.signIn = function(options) {
		console.log("Signing in...");

		signedInUser = angular.copy(options);

		$cookies[SIGNED_IN_USER_COOKIE_NAME] = signedInUser.name;
		$cookies[SIGNED_IN_USER_APITOKEN] = signedInUser.api_token;
		writeToLocalStorage(SIGNED_IN_USER_APITOKEN, signedInUser.api_token);
	};

	this.signOut = function() {
		console.log("Signing out...");

		signedInUser = null;
		// $cookieStore.remove(SIGNED_IN_USER_COOKIE_NAME);
		// $cookieStore.remove(SIGNED_IN_USER_APITOKEN);
		localStorage.clear();
	};

	function readFromLocalStorage(key) {
		var value = localStorage[key];
		return value ? JSON.parse(value) : value;
	}

	function writeToLocalStorage(key, value) {
		localStorage[key] = value ? JSON.stringify(value) : value;
	}
});