app.controller('ApplicationController', ['$rootScope', '$scope', '$routeParams', 'ApplicationResource', 'ApplicationImageResource', function ($rootScope, $scope, $routeParams, ApplicationResource, ApplicationImageResource) {
	console.log("controller :: ApplicationController");

	function loadApplication() {
		ApplicationResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.application = data;
		});
	}

	$scope.destroyImage = function(image) {
		ApplicationImageResource.delete({applicationId: $routeParams.id, id: image.id}).$promise.then(function () {
			loadApplication();
		});
	};

	loadApplication();
}]);
