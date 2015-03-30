/* global app: true */
app.controller('ServerController', ['$rootScope', '$scope', '$routeParams', 'ServerResource', 'ApplicationResource', 'ContainerResource', function ($rootScope, $scope, $routeParams, ServerResource, ApplicationResource, ContainerResource) {
	console.log("controller :: ServerController");

	function loadServer() {
		ServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.server = data;
		});
	}

	function scaleContainer(container, wantedInstances) {
		console.warn("C", container, wantedInstances);
		ContainerResource.update({
			serverId: container.server_id,
			id: container.id,
			container: {wanted_instances: wantedInstances}
		}).$promise.then(function (data) {
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

	$scope.scaleUp = function (container) {
		scaleContainer(container, ++container.wanted_instances);
	};

	$scope.scaleDown = function (container) {
		scaleContainer(container, --container.wanted_instances);
	};

	$scope.scaleTo = function (container) {
		scaleContainer(container, container.wanted_instances);
	};

	loadServer();
}]);
