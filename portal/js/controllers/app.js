(function(lavahound){
    "use strict";
    
    lavahound.app.controller("ApplicationController", function($scope, $location, accountService) {
        $scope.isSignedIn = true;
        
		$scope.$on("$routeChangeSuccess", function($currentRoute, $previousRoute) {
			$scope.username = accountService.signedInUser();
		});		        
        
    	$scope.hasRole = function(role) {
    		return accountService.hasRole(role);    		
    	};
        
    	$scope.$on(lavahound.events.SIGNED_IN, function() { 
    		$scope.isSignedIn = true;
    		console.log("Logged in", accountService.getSignedInUser().name);
    		window.location = "/home";    	
    	});

    	$scope.$on(lavahound.events.SIGNED_OUT, function() { 
    		console.log("Logged out");
    		$scope.isSignedIn = false;
    	});
    	
        $scope.signOut = function() {
    		console.log("Sign out");
    		accountService.signOut();
    		window.location = "/sign-in";    			
    	};
    });

})(lavahound);