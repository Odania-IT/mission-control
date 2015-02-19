app.controller('BackgroundScheduleEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'BackgroundScheduleResource', 'ServerResource', 'ImageResource', function ($rootScope, $scope, $routeParams, $location, BackgroundScheduleResource, ServerResource, ImageResource) {
	console.log("controller :: BackgroundScheduleEditController");

	function init() {
		if ($routeParams.id) {
			BackgroundScheduleResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.backgroundSchedule = data;
			});
		}

		// Load servers & Images
		ServerResource.get().$promise.then(function (data) {
			$scope.allServers = data.servers;
		});
		ImageResource.get().$promise.then(function (data) {
			$scope.allImages = data.images;
		});
	}

	function onSuccessCallback(data) {
		$location.path('backup');
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveBackgroundSchedule = function () {
		if ($routeParams.id) {
			BackgroundScheduleResource.update({
				id: $routeParams.id,
				background_schedule: $scope.backgroundSchedule
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			BackgroundScheduleResource.save({background_schedule: $scope.backgroundSchedule}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.backgroundSchedule = {
		'id': '',
		'name': '',
		'cron_type': 'backup',
		'cron_times': '1 0 * * *'
	};

	init();
}]);
