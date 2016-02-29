window.lavahound.app.controller("SignInController", function($scope, $element, $http, $q, $location, accountService) {
	var DEFAULT_SIGN_IN_BUTTON_TITLE = "Sign In";
	var authenticateApiCall;

	$scope.email ='dan@kelleyland.com';
	$scope.password = 'test123';

	function signIn() {
		$scope.busySigningIn = true;
		$scope.signInButtonTitle = "Signing In...";
		
		var emailAddress = $scope.email;
		var password = $scope.password;
		var rememberMe = $scope.rememberMe.value;

		if (authenticateApiCall)
			authenticateApiCall.cancel();

		console.log('email', $scope.email);
		authenticateApiCall = accountService.authenticate({
			emailAddress : emailAddress,
			password : password,
			rememberMe : rememberMe
		});

		authenticateApiCall.promise.then(function(response) {
			console.log(response)
			accountService.signIn(response.data);
			$scope.$emit(lavahound.events.SIGNED_IN);
		}, function(response) {
			// TODO: error handling
			alert(response.data.description);
			$scope.busySigningIn = false;
			$scope.signInButtonTitle = DEFAULT_SIGN_IN_BUTTON_TITLE;
		})["finally"](function() {
			$scope.busySigningIn = false;
			$scope.signInButtonTitle = DEFAULT_SIGN_IN_BUTTON_TITLE;
		});
	}

	$scope.onSignIn = function() {
		signIn();
	};
	
	$scope.rememberMe = {
			value: false
	};

	$scope.signInButtonTitle = DEFAULT_SIGN_IN_BUTTON_TITLE;
	$scope.busySigningIn = false;
	accountService.signOut();

	
	$($element).find("[username]").focus();
});