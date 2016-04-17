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
		}).when('/hunt/:huntId', {
			templateUrl : '/js/partials/places/hunt.html',
			controller : 'DashboardHuntController'	
		}).when('/photo/new', {
			templateUrl : '/js/partials/places/entry.html',
			controller : 'EditEntryController'				
		}).when('/timeline', {
			templateUrl : '/js/partials/timeline.html',
			controller : 'DashboardTimelineController'
		}).when('/accounts', {
			templateUrl : '/js/partials/accounts.html',
			controller : 'DashboardAccountController'
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

	lavahound.app.controller("DashboardTimelineController", function($scope, $http, $q, $log, $routeParams, $location, dashboardService, accountService) {
		
		$scope.events = [];


		$scope.formatDateFromNow = function(event_time){
			return moment(event_time).fromNow()
		}

		function loadEvents() {
			var options = {
				params : {
					companyId : 1
				}
			};

			dashboardService.findEventTimeline(options).promise.then(function(response) {
				console.log(response);
				$scope.events = response.data.events;
			});
		}
		loadEvents();

	});



	lavahound.app.controller("DashboardPlacesController", function($scope, $timeout, $http, $q, $log, $routeParams, $location, $modal, dashboardService, accountService) {
		
		$scope.places = [];	
		
		$scope.addPlace = function(){
			console.log('add place');
			//"place_id":"1002",
			$scope.editPlace(
				{
				"name":"New Place",
				"description":"Tell us about your new place",
				"image_file_name":"image-not-available.gif",
				"hunt_count":0,
				"image_url":"https://s3.amazonaws.com/lv-place-logos/image-not-available.gif"
			});

		}

		$scope.editPlace = function(place){
			console.log('add place');
			var modalInstance = $modal.open({
					templateUrl : '/js/partials/places/editPlace.html',
					controller : 'EditPlaceController',
					size : 'lg',
					resolve : {
						place : function() {
							return place;
						},
						enabled : function() {
							return true;
						}
					}
				});

				modalInstance.result.then(function(success) {

				}, function() {
					$log.info('Modal dismissed at: ' + new Date());
				});

				return modalInstance;			
		}

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
	
	lavahound.app.controller("DashboardPlaceController", function($scope, $timeout, $http, $q, $log, $routeParams, $location, dashboardService, accountService) {
		
		$scope.places = [];	
	
		$scope.viewHunt = function(hunt){
			console.log("/hunt/" + hunt.hunt_id);
			$location.path( "/hunt/" + hunt.hunt_id );
		}		

		function findPlaceDetails() {
			var options = {
				params : {
					companyId : 1,
					place_id : $routeParams.placeId
				}
			};

			dashboardService.findPlaceDetails(options).promise.then(function(response) {
				$scope.place = response.data.place;
				$scope.hunts = response.data.hunts;
				console.log(response);
			});
		}
		findPlaceDetails();
	});	

	// lavahound.app.controller("DashboardHuntController", function($scope, $timeout, $http, $q, $log, $routeParams, $location, dashboardService, accountService, uiGmapGoogleMapApi) {
	
	// });
//"$modal",$modal,

	lavahound.app.controller("DashboardHuntController", [ "$scope", "$http", "$q", "$log", "$filter", "$routeParams", "$location", "uiGmapGoogleMapApi", "dashboardService",
			"accountService", "ngTableParams", "uiGmapIsReady",
			function($scope, $http, $q, $log, $filter, $routeParams, $location, uiGmapGoogleMapApi, dashboardService, accountService, NgTableParams, uiGmapIsReady) {
			
			$scope.map = {center: {latitude: 51.219053, longitude: 4.404418 }, zoom: 14 };
        	$scope.options = {scrollwheel: false};
			// $scope.map.options = {draggable:true};

			function updateMap(){
				if (angular.isDefined(window.google) && angular.isDefined(window.google.maps)) {
					var bounds = new google.maps.LatLngBounds();
					angular.forEach($scope.photos, function(latLng) {
						if (latLng.latitude === 0 && latLng.longitude === 0){
							$scope.unknownViews++;
						}else{
							var myLatLng = new google.maps.LatLng(latLng.latitude, latLng.longitude);
							var marker = new google.maps.Marker({
							    position: myLatLng,
							    map: $scope.mapInstance.map,
							    title: latLng.description,
							    draggable:true,
							    photo_id: latLng.photo_id
							});		
							google.maps.event.addListener(marker, 'dragend', function() 
							{
							    console.log("dragged to", marker.position);
							});
							marker.addListener('click', function() {
								console.log("clicked", marker);
							});

							bounds.extend(myLatLng);
						}
					});
					$scope.mapInstance.map.fitBounds(bounds);


					// $scope.map.sessionMarkers = $scope.photos;
				}
			}

			uiGmapIsReady.promise().then(function(instances) {
		        instances.forEach(function(inst) {
					$scope.mapInstance = inst;
					findHuntDetails();
				});
		        console.log("is ready");
		    });

			$scope.addNewEntry = function() {
				$location.path( "/photo/new" );

				// var modalInstance = $modal.open({
				// 	templateUrl : '/js/partials/places/entry.html',
				// 	controller : 'EditEntryController',
				// 	size : 'lg',
				// 	resolve : {
				// 		entry : function() {
				// 			return {};
				// 		},
				// 		enabled : function() {
				// 			return true;
				// 		}
				// 	}
				// });

				// modalInstance.result.then(function(success) {

				// }, function() {
				// 	$log.info('Modal dismissed at: ' + new Date());
				// });

				// return modalInstance;
			};

			function findHuntDetails() {
				var options = {
					params : {
						companyId : 1,
						hunt_id : $routeParams.huntId
					}
				};

				dashboardService.findHuntDetails(options).promise.then(function(response) {
					$scope.hunt = response.data.hunt;			
					$scope.photos = response.data.photos;	
					updateMap();
					console.log(response);
				});
			}

	}]);	

	lavahound.app.controller("EditPlaceController", [ "$scope", "$modalInstance", "$http", "$q", "$log","$routeParams", "$location", "$timeout", "Upload", "dashboardService",
		"accountService", "place",
		function($scope,  $modalInstance, $http, $q, $log, $routeParams, $location, $timeout, Upload, dashboardService, accountService, place) {
		$scope.place = place;
		console.log("place", place);

		$scope.editSaveLabel = "Save & Continue";

	    $scope.myImage='';
	    $scope.myCroppedImage='';
		$scope.cancel = function() {
			$modalInstance.dismiss('cancel');
		};

	$scope.steps = [
      { number: 1, name: 'Add Place Details' },
      { number: 2, name: 'Upload Image' },
      ];
    

    $scope.currentStep = angular.copy($scope.steps[0]);

    $scope.stepName = $scope.currentStep.name;

    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    };
    
    $scope.nextStep = function() {
      // Perform current step actions and show next step:
      // E.g. save form data
      
      var nextNumber = $scope.currentStep.number;
      if (nextNumber === 1){
      	saveStep1();
      }else if (nextNumber === 2){
      	saveStep2();
      }

    };

		function saveStep1() {
			var options = {
				params : {
					place : $scope.place
				}
			};
			// dashboardService.savePlace(options).promise.then(function(response) {
			// 	$scope.place.place_id = response.place_id;
				$scope.currentStep = angular.copy($scope.steps[1]);
	      		$scope.stepName = $scope.currentStep.name;
		      	$scope.place.place_id = 1009;
				$scope.place.image_file_name  = guid()
				$timeout(function() {
			    	 angular.element(document.querySelector('#fileInput')).on('change',handleFileSelect);	        
		    	}, 500);				
			// }, function(reason) {
			// 	$scope.errorMsg('whoops something went wrong');
			// 	console.log(reason);
			// });
		};

		function saveStep2() {
	        $modalInstance.dismiss('cancel');
		};

	    var handleFileSelect=function(evt) {
	      var file=evt.currentTarget.files[0];
	      var reader = new FileReader();
     		console.log("handleFileSelect");
	      reader.onload = function (evt) {
	        $scope.$apply(function($scope){
	          $scope.myImage=evt.target.result;
	          console.log($scope.myImage);
	        });
	      };
	      reader.readAsDataURL(file);
	    };

	    function guid(){
	    	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    			var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
    			return v.toString(16);
			});
	    } 

	    console.log(guid());

		$scope.upload = function (dataUrl) {
			console.log(dataUrl);
	        Upload.upload({
	            url: 'api/upload',
	            data: {
	                file: Upload.dataUrltoBlob(dataUrl, $scope.place.image_file_name + ".jpg")
	            },
	        }).then(function (response) {
	            $timeout(function () {
	                $scope.result = response.data;
	            });
	        }, function (response) {
	            if (response.status > 0) $scope.errorMsg = response.status 
	                + ': ' + response.data;
	        }, function (evt) {
	            $scope.progress = parseInt(100.0 * evt.loaded / evt.total);
	        });
	    }
		
	}]);

	lavahound.app.controller("EditEntryController", [ "$scope", "$http", "$q", "$log","$routeParams", "$location", "Upload", "dashboardService",
		"accountService",
		function($scope, $http, $q, $log, $routeParams, $location, Upload, dashboardService, accountService) {
	
		$scope.editSaveLabel = "Edit";

	    $scope.myImage='';
	    $scope.myCroppedImage='';


		console.log("EditEntryController");
	    var handleFileSelect=function(evt) {
	      var file=evt.currentTarget.files[0];
	      var reader = new FileReader();
	      reader.onload = function (evt) {
	        $scope.$apply(function($scope){
	          $scope.myImage=evt.target.result;
	        });
	      };
	      reader.readAsDataURL(file);
	    };
	    angular.element(document.querySelector('#fileInput')).on('change',handleFileSelect);


		$scope.upload = function (dataUrl, name) {
	        Upload.upload({
	            url: 'api/upload',
	            data: {
	                file: Upload.dataUrltoBlob(dataUrl, name)
	            },
	        }).then(function (response) {
	            $timeout(function () {
	                $scope.result = response.data;
	            });
	        }, function (response) {
	            if (response.status > 0) $scope.errorMsg = response.status 
	                + ': ' + response.data;
	        }, function (evt) {
	            $scope.progress = parseInt(100.0 * evt.loaded / evt.total);
	        });
	    }
		
	}]);
	
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