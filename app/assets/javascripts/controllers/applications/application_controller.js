app.controller('ApplicationController', ['$rootScope', '$scope', '$routeParams', 'ApplicationResource', function ($rootScope, $scope, $routeParams, ApplicationResource) {
	console.log("controller :: ApplicationController");

	ApplicationResource.get({id: $routeParams.id}).$promise.then(function (data) {
		$scope.application = data;
	});
}]);
