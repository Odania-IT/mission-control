app.controller('BackgroundScheduleController', ['$rootScope', '$scope', '$routeParams', 'BackgroundScheduleResource', function ($rootScope, $scope, $routeParams, BackgroundScheduleResource) {
	console.log("controller :: BackgroundScheduleController");

	function loadBackgroundSchedule() {
		BackgroundScheduleResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.backgroundSchedule = data;
		});
	}

	loadBackgroundSchedule();
}]);
