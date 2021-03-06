/* global app: true */
app.controller('ServerEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'ServerResource', function ($rootScope, $scope, $routeParams, $location, ServerResource) {
	console.log("controller :: ServerEditController");

	function init() {
		if ($routeParams.id) {
			ServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.server = data;
			});
		}
	}

	function onSuccessCallback(data) {
		$location.path('servers/'+data.id);
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveServer = function() {
		if ($routeParams.id) {
			ServerResource.update({id: $routeParams.id, server: $scope.server}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			ServerResource.save({server: $scope.server}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.server = {
		'id': '',
		'active': false
	};

	init();
}]);
