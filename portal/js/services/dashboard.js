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

	this.findRating = function(options) {
		options = options || {};
		var params = options.params || {};

		var postData = {
			companyId : params.companyId,
			startDate : params.startDate,
			endDate : params.endDate
		};

		return networkService.makeCall({
			method : "GET",
			url : "/api/dashboard/rating",
			params : postData
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
