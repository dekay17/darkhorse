/* global window */
window.lavahound.app.service("dashboardService", function($http, $q, $timeout, networkService) {
	var that = this;

	this.findSummary = function(options) {
		options = options || {};
		var params = options.params || {};

		var postData = {
			companyId : params.companyId,
		};

		return networkService.makeCall({
			method : "GET",
			url : "/api/dashboard/summary",
			data : postData
		});
	};

	this.findPlaces = function(options) {
		options = options || {};
		var params = options.params || {};

		return networkService.makeCall({
			method : "GET",
			url : "/api/places",
			params : params
		});
	};
	
	this.findPlaceDetails = function(options) {
		options = options || {};
		var params = options.params || {};

		return networkService.makeCall({
			method : "GET",
			url : "/api/place/" + params.place_id,
			params : params
		});
	};	

	this.savePlace = function(options) {
		options = options || {};
		var params = options.params || {};
		var url = "/api/place/";
		if (options.place_id){
			url += options.place_id
		}

		return networkService.makeCall({
			method : "POST",
			url : url,
			data : params
		});
	};		

	this.findEventTimeline = function(options) {
		options = options || {};
		var params = options.params || {};

		return networkService.makeCall({
			method : "GET",
			url : "/api/timeline",
			params : params
		});
	};	
	
	this.findHuntDetails = function(options) {
		options = options || {};
		var params = options.params || {};

		return networkService.makeCall({
			method : "GET",
			url : "/api/hunt/" + params.hunt_id,
			params : params
		});
	};	

	this.loadSegmentData = function(params) {

		var postData = {
			segments : params.segments,
			units : params.units
		};
		
		var params = {
			startDate : params.startDate,
			endDate : params.endDate
		};

		return networkService.makeCall({
			method : "POST",
			url : "/api/report/segments",
			data : postData,
			params : params
		});
	};
});
