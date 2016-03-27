(function() {
	"use strict";

	lavahound.app.config([ '$routeProvider', function($routeProvider) {
		$routeProvider.when('/home', {
			templateUrl : '/js/partials/index.html',
			controller : 'DashboardController'
		}).when('/places', {
			templateUrl : '/js/partials/places.html',
			controller : 'DashboardPlacesController'
		}).when('/places/:placeId', {
			templateUrl : '/js/partials/places/place.html',
			controller : 'DashboardPlaceController'				
		}).when('/account', {
			templateUrl : '/js/partials/dashboard/program/dhi-list.html',
			controller : 'DashboardPlaceController'
		}).when('/account/:programId', {
			templateUrl : '/js/partials/dashboard/program/dhi.html',
			controller : 'DashboardController'
		}).otherwise({
			redirectTo : '/home'
		});
	} ]);

	lavahound.app.controller("BaseDashboardController", function($scope, $element, $http, $q, $log, dashboardService, accountService) {			
		$scope.$on("$routeChangeSuccess", function($currentRoute, $previousRoute) {
			$scope.breadcrumbs = [];
			$scope.breadcrumbs.push({link:"/dashboard", name:"Dashboard"});
		});				

	});

	lavahound.app.controller("DashboardController", function($scope, $timeout, $http, $q, $log, $routeParams, $location, dashboardService, accountService) {
		
		$scope.users = 0;
		$scope.hunts = 0;	
		

		function loadDashboardSummary() {
			var options = {
				params : {
					companyId : 1
				}
			};

			dashboardService.findSummary(options).promise.then(function(response) {
				console.log(response);
				$scope.users = response.data.accounts;
				$scope.hunts = response.data.hunts;
			});
		}
		loadDashboardSummary();

	});

	lavahound.app.controller("DashboardPlacesController", function($scope, $timeout, $http, $q, $log, $routeParams, $location, dashboardService, accountService) {
		
		$scope.places = [];	
		

		function loadPlaces() {
			var options = {
				params : {
					companyId : 1
				}
			};

			dashboardService.findPlaces(options).promise.then(function(response) {
				$scope.places = response.data.places;
			});
		}
		loadPlaces();

	});
	
	// ***** -------------------- CRAP BELOW HERE ------------------
	
	lavahound.app.controller("DashboardMaStatsController", [ "$scope", "$http", "$q", "$log", "$filter", "dashboardService", "accountService", "ngTableParams",
			function($scope, $http, $q, $log, $filter, dashboardService, accountService, NgTableParams, $sce) {

				$scope.breadcrumbs.push({link:"#ma-stats", name:"MA Stats"});

				$scope.selectedTotalViews = 0;
				
				$scope.filename = "export";
				$scope.getExportHeaders = function () {
					return ['Name','Location','Views'];					
				};
				
				$scope.getExportData = function () {
					var data = [];
					angular.forEach($scope.exportData, function(entry) {
						data.push({
							'Name':entry.account_name,
							'Location':entry.unit_name,
							'Views':entry.views
						});
					});
					return data;
				};
				
				$scope.$watch("filtered", function(newValue, oldValue) {
					if (typeof newValue != 'undefined') {
						$scope.maStatsTableParams.reload();
					}
				});

				$scope.selectedUnitIds = [];

				$scope.$watchCollection("selectedUnitIds", function(newValue, oldValue) {
					if (typeof newValue != 'undefined') {
						$scope.maStatsTableParams.reload();
					}
				});

				$scope.companyUnits = accountService.companyUnits();

				$scope.setSelectedClient = function() {
					var unitId = this.unit.unitId;
					if (_.contains($scope.selectedUnitIds, unitId)) {
						$scope.selectedUnitIds = _.without($scope.selectedUnitIds, unitId);
					} else {
						$scope.selectedUnitIds.push(unitId);
					}
					return false;
				};

				$scope.isChecked = function(unitId) {
					if (_.contains($scope.selectedUnitIds, unitId)) {
						return 'glyphicon glyphicon-ok-sign pull-right';
					}
					return false;
				};

				$scope.checkAll = function() {
					$scope.selectedUnitIds = _.pluck($scope.companyUnits, 'unitId');
				};

				function loadMAViews($defer, params) {
					var endDate = moment($scope.dt.end.date).format("MM-DD-YYYY");
					var startDate = moment($scope.dt.start.date).format("MM-DD-YYYY");
					var options = {
						params : {
							startDate : startDate,
							endDate : endDate
						}
					};

					var locationFilter = [];

					dashboardService.findAccountViews(options).promise.then(function(response) {
						var data = response.data.accountViews;
						if ($scope.selectedUnitIds.length > 0) {
							data = _.filter(data, function(i) {
								return this.keys.indexOf(i.unit_id) > -1;
							}, {
								"keys" : $scope.selectedUnitIds
							// values to look for
							});
						}
						params.total(data.length);
						$scope.selectedTotalViews = _.reduce(data, function(count, account) {
							return count + account.views;
						}, 0);
						// account.views
						data = params.sorting() ? $filter("orderBy")(data, params.orderBy()) : data;
						
						$scope.exportData = data;
						console.log($scope.exportData);
						$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
					});

					return $defer;
				}

				var options = {
					start : 'xxx',
					end : 'yyy'
				};

				$scope.accounts = [];
				
				$scope.maStatsTableParams = new NgTableParams({
					page : 1,
					count : 10,
					sorting : {
						'views' : 'desc',
						'account_name' : 'asc'
					},
					fitler : null
				}, {
					total : function() {
						return $scope.accounts.length;
					},
					getData : function($defer, params) {
						loadMAViews($defer, params);
					}
				});

			} ]);

	lavahound.app.controller("DashboardSessionController", [ "$scope", "$http", "$q", "$log", "$filter", "$routeParams", "uiGmapGoogleMapApi", "dashboardService",
			"accountService", "ngTableParams", "uiGmapIsReady",
			function($scope, $http, $q, $log, $filter, $routeParams, uiGmapGoogleMapApi, dashboardService, accountService, NgTableParams, uiGmapIsReady) {

				$scope.setDisplayFilters(true);

				var tableLoaded = false;
				uiGmapGoogleMapApi.then(function(maps) {
					$scope.googleVersion = maps.version;
					maps.visualRefresh = true;
				});

				uiGmapIsReady.promise().then(function(instances) {
					instances.forEach(function(inst) {
						$scope.mapInstance = inst;
						if (!tableLoaded)
							loadPatientSessions();
					});
				});

				$scope.$watch("filtered", function(newValue, oldValue) {
					if (typeof newValue != 'undefined') {
						loadPatientSessions();
					}
				});

				$scope.unitNames = function(column) {
					var def = $q.defer(), names = [], units = accountService.companyUnits();					
					if (units=== null || angular.isUndefined(units) || units.length === 0){
						accountService.loadUnits({}).promise.then(function(response) {
							var units = response.data.units;
							accountService.setCompanyUnits(units);
							angular.forEach(units, function(item) {
								names.push({
									'id' : item.unitId,
									'title' : item.name
								});
							});
							// $scope.unitNames = names;
						});
					} else {
						angular.forEach(accountService.companyUnits(), function(item) {
							names.push({
								'id' : item.unitId,
								'title' : item.name
							});
						});
						// $scope.unitNames = names;
					}
					def.resolve(names);
					return def;
				};

				$scope.map = {
					show : true,
					control : {},
					center : {
						latitude : 25.947006,
						longitude : -80.246094
					},
					zoom : 9,
					dragging : false,
					disableDoubleClickZoom: true,
					bounds : {},
					events : {
					// tilesloaded : function(map) {
					// $scope.$apply(function() {
					// $scope.mapInstance = map;
					// });
					// },
					// bounds_changed: function () {
					// //console.log($scope.map.getBounds());
					// handleBoundsChange();
					// }
					},
					options : {
						streetViewControl : false,
						overviewMapControl : false,
						panControl : false,
						zoomControl : true,
						scaleControl : false,
						maxZoom : 20,
						minZoom : 3
					},
					sessionMarkers : [],
					doClusterSessionMarkers : true,
					clusterOptions : {
						"title" : "Group of views!",
						"gridSize" : 60,
						"ignoreHidden" : true,
						"minimumClusterSize" : 10
					},

				};
				//				
				// var handleBoundsChange = function(){
				// if (angular.isDefined($scope.mapInstance))
				// console.log($scope.mapInstance.getBounds());
				// };

				$scope.options = {
					scrollwheel : false
				};

				// $scope.map.locations = [{"id": 100, "title":"E Hallandale
				// Beach Blvd", "latitude":25.985551,"longitude": -80.143844}];

				if ($routeParams.accountId){
					$scope.breadcrumbs.push({link:"#ma-stats", name:"MA Stats"});
					$scope.breadcrumbs.push({link:"#sessions", name:"Patient Sessions"});
				}else{
					$scope.breadcrumbs.push({link:"#sessions", name:"Patient Sessions"});
				}
				
				function loadPatientSessions($defer, params) {
					var endDate = moment($scope.dt.end.date).format("MM-DD-YYYY");
					var startDate = moment($scope.dt.start.date).format("MM-DD-YYYY");
					var accountId = $routeParams.accountId;
					var options = {
						params : {
							startDate : startDate,
							endDate : endDate,
							accountId : accountId
						}
					};

					dashboardService.findPatientSessions(options).promise.then(function(response) {
						$scope.patientSessions = response.data.sessions;
						// params.total(data.length);
						// data = params.sorting() ? $filter("orderBy")(data,
						// params.orderBy()) : data;


						$scope.sessionsTableParams.reload();
						// $defer.resolve(data.slice((params.page() - 1) *
						// params.count(), params.page() * params.count()));
					});

					return $defer;
				}

				$scope.sessionsTableParams = new NgTableParams({
					page : 1,
					count : 10,
					sorting : {},
					fitler : null
				}, {
					total : function() {
						return $scope.sessions.length;
					},
					getData : function($defer, params) {
						if (angular.isUndefined($scope.mapInstance))
							return;
						if (angular.isUndefined($scope.patientSessions) || $scope.patientSessions === null) {
							loadPatientSessions($defer, params);
						} else {
							tableLoaded= true;
							var data = $scope.patientSessions;
							$scope.unknownViews = 0;
							data = params.filter() ? $filter("filter")(data, params.filter()) : data;
							data = params.sorting() ? $filter("orderBy")(data, params.orderBy()) : data;
							if (angular.isDefined(window.google) && angular.isDefined(window.google.maps)) {
								var bounds = new google.maps.LatLngBounds();
								angular.forEach(data, function(latLng) {
									if (latLng.latitude === 0 && latLng.longitude === 0){
										$scope.unknownViews++;
									}else{
										var myLatLng = new google.maps.LatLng(latLng.latitude, latLng.longitude);
										bounds.extend(myLatLng);
									}
								});
//								console.log($scope.unknownViews);
								$scope.mapInstance.map.fitBounds(bounds);
							}
							$scope.map.sessionMarkers = data;
							params.total(data.length);
							$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
						}
					}
				});

			} ]);

	lavahound.app.controller("DashboardSessionsAtRiskController", [ "$scope", "$http", "$q", "$log", "$filter", "$routeParams", "uiGmapGoogleMapApi", "dashboardService",
	                                         			"accountService", "ngTableParams", "uiGmapIsReady",
	                                         			function($scope, $http, $q, $log, $filter, $routeParams, uiGmapGoogleMapApi, dashboardService, accountService, NgTableParams, uiGmapIsReady) {

	                                         				$scope.setDisplayFilters(true);

	                                         				var tableLoaded = false;
	                                         				uiGmapGoogleMapApi.then(function(maps) {
	                                         					$scope.googleVersion = maps.version;
	                                         					maps.visualRefresh = true;
	                                         				});

	                                         				uiGmapIsReady.promise().then(function(instances) {
	                                         					instances.forEach(function(inst) {
	                                         						$scope.mapInstance = inst;
	                                         						if (!tableLoaded)
	                                         							loadSessionsAtRisk();
	                                         					});
	                                         				});

	                                         				$scope.$watch("filtered", function(newValue, oldValue) {
	                                         					if (typeof newValue != 'undefined') {
	                                         						loadSessionsAtRisk();
	                                         					}
	                                         				});

	                                         				$scope.unitNames = function(column) {
	                                         					var def = $q.defer(), names = [], units = accountService.companyUnits();					
	                                         					if (units=== null || angular.isUndefined(units) || units.length === 0){
	                                         						accountService.loadUnits({}).promise.then(function(response) {
	                                         							var units = response.data.units;
	                                         							accountService.setCompanyUnits(units);
	                                         							angular.forEach(units, function(item) {
	                                         								names.push({
	                                         									'id' : item.unitId,
	                                         									'title' : item.name
	                                         								});
	                                         							});
	                                         							// $scope.unitNames = names;
	                                         						});
	                                         					} else {
	                                         						angular.forEach(accountService.companyUnits(), function(item) {
	                                         							names.push({
	                                         								'id' : item.unitId,
	                                         								'title' : item.name
	                                         							});
	                                         						});
	                                         						// $scope.unitNames = names;
	                                         					}
	                                         					def.resolve(names);
	                                         					return def;
	                                         				};

	                                         				$scope.map = {
	                                         					show : true,
	                                         					control : {},
	                                         					center : {
	                                         						latitude : 25.947006,
	                                         						longitude : -80.246094
	                                         					},
	                                         					zoom : 9,
	                                         					dragging : false,
	                                         					disableDoubleClickZoom: true,
	                                         					bounds : {},
	                                         					options : {
	                                         						streetViewControl : false,
	                                         						overviewMapControl : false,
	                                         						panControl : false,
	                                         						zoomControl : true,
	                                         						scaleControl : false,
	                                         						maxZoom : 20,
	                                         						minZoom : 3
	                                         					},
	                                         					sessionMarkers : [],
	                                         					doClusterSessionMarkers : true,
//	                                         					clusterOptions : {
//	                                         						"title" : "Group of views!",
//	                                         						"gridSize" : 60,
//	                                         						"ignoreHidden" : true,
//	                                         						"minimumClusterSize" : 10
//	                                         					},
	                                         				};

	                                         				$scope.options = {
	                                         					scrollwheel : false
	                                         				};

	                                         				$scope.breadcrumbs.push({link:"#sessionsAtRisk", name:"Sessions"});
	                                         				
	                                         				function loadSessionsAtRisk($defer, params) {
	                                         					var endDate = moment($scope.dt.end.date).format("MM-DD-YYYY");
	                                         					var startDate = moment($scope.dt.start.date).format("MM-DD-YYYY");
	                                         					var programId = $routeParams.programId;
	                                         					var options = {
	                                         						params : {
	                                         							startDate : startDate,
	                                         							endDate : endDate,
	                                         							programId : programId
	                                         						}
	                                         					};

	                                         					dashboardService.findSessionsAtRisk(options).promise.then(function(response) {
	                                         						$scope.patientSessions = response.data.sessions;

	                                         						$scope.sessionsTableParams.reload();
	                                         					});

	                                         					return $defer;
	                                         				}

	                                         				$scope.sessionsTableParams = new NgTableParams({
	                                         					page : 1,
	                                         					count : 10,
	                                         					sorting : {},
	                                         					fitler : null
	                                         				}, {
	                                         					total : function() {
	                                         						return $scope.sessions.length;
	                                         					},
	                                         					getData : function($defer, params) {
	                                         						if (angular.isUndefined($scope.mapInstance))
	                                         							return;
	                                         						if (angular.isUndefined($scope.patientSessions) || $scope.patientSessions === null) {
	                                         							loadSessionsAtRisk($defer, params);
	                                         						} else {
	                                         							tableLoaded= true;
	                                         							var data = $scope.patientSessions;
	                                         							$scope.unknownViews = 0;
	                                         							data = params.filter() ? $filter("filter")(data, params.filter()) : data;
	                                         							data = params.sorting() ? $filter("orderBy")(data, params.orderBy()) : data;
	                                         							if (angular.isDefined(window.google) && angular.isDefined(window.google.maps)) {
	                                         								var bounds = new google.maps.LatLngBounds();
	                                         								angular.forEach(data, function(latLng) {
	                                         									if (latLng.latitude === 0 && latLng.longitude === 0){
	                                         										$scope.unknownViews++;
	                                         									}else{
	                                         										var myLatLng = new google.maps.LatLng(latLng.latitude, latLng.longitude);
	                                         										bounds.extend(myLatLng);
	                                         									}
	                                         								});
	                                         								$scope.mapInstance.map.fitBounds(bounds);
	                                         							}
	                                         							$scope.map.sessionMarkers = data;
	                                         							params.total(data.length);
	                                         							$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
	                                         						}
	                                         					}
	                                         				});

	                                         			} ]);
	
	lavahound.app.controller("DashboardSessionDetailController", [ "$scope", "$http", "$q", "$log", "$filter", "$routeParams", "dashboardService",
			"accountService", "ngTableParams", function($scope, $http, $q, $log, $filter, $routeParams, dashboardService, accountService, NgTableParams) {
		$scope.breadcrumbs.push({link:"#sessions", name:"Patient Sessions"});
	
		$scope.breadcrumbs.push({link:"#sessions", name:"Session Details"});
		
		$scope.setDisplayFilters(false);

		var sessionId = $routeParams.sessionId;
		var options = {
			params : {
				sessionId : sessionId
			}
		};

		$scope.expanded = {};
		$scope.showAncillaryData = false;
		
		$scope.formatDate = function (unixDate) {
			return moment(unixDate).format("MMM Do YYYY");
		};
		
		
		$scope.expand = function (video_play_id) {
			if ($scope.expanded[video_play_id] == null)
				$scope.expanded[video_play_id] = "expanded";
			else 
				$scope.expanded[video_play_id] = null;
		};
		
		dashboardService.findPatientSession(options).promise.then(function(response) {
			var data = response.data;
			$scope.session = data.session;
			$scope.profile = data.profile;
			$scope.videoPlays = data.videoPlays;
			$scope.vitalsList = data.vitalData;
		});
	} ]);

})(lavahound);