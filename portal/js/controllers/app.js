(function(lavahound){
    "use strict";
    
    lavahound.app.controller("ApplicationController", function($scope, $location, accountService) {
        $scope.isSignedIn = true;
        
    	$scope.hasRole = function(role) {
    		return accountService.hasRole(role);    		
    	};
        
    	$scope.$on(lavahound.events.SIGNED_IN, function() { 
    		console.log("Logged in");
    		$scope.isSignedIn = true;
    		window.location = "/home";    	
    	});

    	$scope.$on(lavahound.events.SIGNED_OUT, function() { 
    		console.log("Logged out");
    		$scope.isSignedIn = false;
    	});
    	
        $scope.signOut = function() {
    		accountService.signOut();
    		window.location = "/sign-in";    			
    	};
    });

})(lavahound);