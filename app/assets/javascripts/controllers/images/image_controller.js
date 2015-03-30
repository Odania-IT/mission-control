/* global app: true */
app.controller('ImageController', ['$rootScope', '$scope', '$routeParams', 'ApplicationImageResource', function ($rootScope, $scope, $routeParams, ApplicationImageResource) {
	console.log("controller :: ImageController");

	ApplicationImageResource.get({applicationId: $routeParams.applicationId, id: $routeParams.id}).$promise.then(function (data) {
		$scope.image = data;
	});

	$scope.applicationId = $routeParams.applicationId;
}]);
