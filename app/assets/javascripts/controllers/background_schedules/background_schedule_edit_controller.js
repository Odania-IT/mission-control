app.controller('BackgroundScheduleEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'BackgroundScheduleResource', 'ServerResource', 'ImageResource', 'BackupServerResource', 'TemplateResource', function ($rootScope, $scope, $routeParams, $location, BackgroundScheduleResource, ServerResource, ImageResource, BackupServerResource, TemplateResource) {
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
		BackupServerResource.get().$promise.then(function (data) {
			$scope.backupServers = data.backup_servers;
		});
		TemplateResource.get().$promise.then(function (data) {
			$scope.allTemplates = data.templates;
		});
	}

	function onSuccessCallback(data) {
		$location.path('backup');
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	function getImage() {
		var image;
		for (var i=0 ; i<$scope.allImages.length ; i++) {
			image = $scope.allImages[i];

			if (image.id == $scope.backgroundSchedule.image_id) {
				return image;
			}
		}
	}

	function getTemplate(image) {
		var template;
		for (var i=0 ; i<$scope.allTemplates.length ; i++) {
			template = $scope.allTemplates[i];

			if (template.id == image.template_id) {
				return template;
			}
		}
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

	$scope.changedImage = function() {
		var image = getImage();
		console.warn('ASD', image);

		if (image.template_id != null) {
			var template = getTemplate(image);
			console.warn('A', image.template_id, template);

			if (template.backup_strategy) {
				$scope.backgroundSchedule.cron_type = 'backup';
				$scope.backgroundSchedule.strategy = template.backup_strategy;
			}
		}
	};

	$scope.backgroundSchedule = {
		'id': '',
		'name': '',
		'image_id': '',
		'cron_type': 'backup',
		'cron_times': '1 0 * * *'
	};

	init();
}]);
