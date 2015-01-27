app.controller('ServerController', ['$rootScope', '$scope', '$routeParams', 'ServerResource', 'ApplicationResource', function ($rootScope, $scope, $routeParams, ServerResource, ApplicationResource) {
	console.log("controller :: ServerController");

	function loadServer() {
		ServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.server = data;
		});
	}

	$scope.loadApplicationSelection = function () {
		ApplicationResource.get().$promise.then(function (data) {
			$scope.allApplications = data.applications;
		});
	};

	$scope.addApplication = function () {
		ServerResource.addApplication({id: $routeParams.id, application_id: $scope.data.applicationId}).$promise.then(loadServer);
	};

	$scope.removeApplicationFromServer = function (applicationId) {
		ServerResource.removeApplication({id: $routeParams.id, application_id: applicationId}).$promise.then(loadServer);
	};

	$scope.data = {
		'applicationId': ''
	};

	loadServer();
}]);
