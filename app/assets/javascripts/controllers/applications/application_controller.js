app.controller('ApplicationController', ['$rootScope', '$scope', '$routeParams', 'ApplicationResource', 'ImageResource', function ($rootScope, $scope, $routeParams, ApplicationResource, ImageResource) {
	console.log("controller :: ApplicationController");

	function loadApplication() {
		ApplicationResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.application = data;
		});
	}

	$scope.destroyImage = function(image) {
		ImageResource.delete({applicationId: $routeParams.id, id: image.id}).$promise.then(function () {
			loadApplication();
		});
	};

	loadApplication();
}]);
