app.controller('ImageController', ['$rootScope', '$scope', '$routeParams', 'ImageResource', function ($rootScope, $scope, $routeParams, ImageResource) {
	console.log("controller :: ImageController");

	ImageResource.get({applicationId: $routeParams.applicationId, id: $routeParams.id}).$promise.then(function (data) {
		$scope.image = data;
	});

	$scope.applicationId = $routeParams.applicationId;
}]);
