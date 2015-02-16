app.controller('ApplicationsController', ['$rootScope', '$scope', 'ApplicationResource', function ($rootScope, $scope, ApplicationResource) {
	console.log("controller :: ApplicationsController");

	function loadApplications() {
		ApplicationResource.get().$promise.then(function (data) {
			$scope.applications = data.applications;
		});
	}

	$scope.destroyApplication = function(server) {
		ApplicationResource.delete({id: server.id}).$promise.then(function () {
			loadApplications();
		});
	};

	loadApplications();
}]);
