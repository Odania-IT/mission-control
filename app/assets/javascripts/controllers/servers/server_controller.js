app.controller('ServerController', ['$rootScope', '$scope', '$routeParams', 'ServerResource', function ($rootScope, $scope, $routeParams, ServerResource) {
	console.log("controller :: ServerController");

	ServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
		$scope.server = data;
	});
}]);
