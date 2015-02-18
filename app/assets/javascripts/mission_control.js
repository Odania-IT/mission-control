var app = angular.module('mission_control', ['ngRoute', 'ngResource', 'ui.bootstrap']);

app.config(['$routeProvider', '$httpProvider', function ($routeProvider, $httpProvider) {
	console.log('config :: init');
	$httpProvider.interceptors.push('httpFlashInterceptorService');

	var resolve = {
		'bootstrap': ['$rootScope', 'resolveService', 'eventTypeProvider', function ($rootScope, resolveService, eventTypeProvider) {
			$rootScope.$broadcast(eventTypeProvider.INTERNAL_DATA_LOADING);

			return resolveService.resolveBootstrap().then(function (data) {
				$rootScope.bootstrapData = data;

				console.log("bootstrap :: done");
				$rootScope.$broadcast(eventTypeProvider.INTERNAL_BOOTSTRAP_RESOLVED);
				$rootScope.$broadcast(eventTypeProvider.INTERNAL_DATA_LOADED);
			});
		}]
	};

	$routeProvider
		.when('/dashboard', {
			controller: 'DashboardController',
			'templateUrl': config.getTemplatePath('dashboard/index'),
			'resolve': resolve
		})

		.when('/servers', {
			controller: 'ServersController',
			'templateUrl': config.getTemplatePath('servers/index'),
			'resolve': resolve
		})
		.when('/servers/new', {
			controller: 'ServerEditController',
			'templateUrl': config.getTemplatePath('servers/edit'),
			'resolve': resolve
		})
		.when('/servers/:id/edit', {
			controller: 'ServerEditController',
			'templateUrl': config.getTemplatePath('servers/edit'),
			'resolve': resolve
		})
		.when('/servers/:id', {
			controller: 'ServerController',
			'templateUrl': config.getTemplatePath('servers/show'),
			'resolve': resolve
		})

		.when('/applications', {
			controller: 'ApplicationsController',
			'templateUrl': config.getTemplatePath('applications/index'),
			'resolve': resolve
		})
		.when('/applications/new', {
			controller: 'ApplicationEditController',
			'templateUrl': config.getTemplatePath('applications/edit'),
			'resolve': resolve
		})
		.when('/applications/:id/edit', {
			controller: 'ApplicationEditController',
			'templateUrl': config.getTemplatePath('applications/edit'),
			'resolve': resolve
		})
		.when('/applications/:id', {
			controller: 'ApplicationController',
			'templateUrl': config.getTemplatePath('applications/show'),
			'resolve': resolve
		})

		.when('/applications/:applicationId/images/new', {
			controller: 'ImageEditController',
			'templateUrl': config.getTemplatePath('images/edit'),
			'resolve': resolve
		})
		.when('/applications/:applicationId/images/:id/edit', {
			controller: 'ImageEditController',
			'templateUrl': config.getTemplatePath('images/edit'),
			'resolve': resolve
		})
		.when('/applications/:applicationId/images/:id', {
			controller: 'ImageController',
			'templateUrl': config.getTemplatePath('images/show'),
			'resolve': resolve
		})

		.when('/repositories', {
			controller: 'RepositoriesController',
			'templateUrl': config.getTemplatePath('repositories/index'),
			'resolve': resolve
		})
		.when('/repositories/new', {
			controller: 'RepositoryEditController',
			'templateUrl': config.getTemplatePath('repositories/edit'),
			'resolve': resolve
		})
		.when('/repositories/:id/edit', {
			controller: 'RepositoryEditController',
			'templateUrl': config.getTemplatePath('repositories/edit'),
			'resolve': resolve
		})
		.when('/repositories/:id', {
			controller: 'RepositoryController',
			'templateUrl': config.getTemplatePath('repositories/show'),
			'resolve': resolve
		})

		.when('/backup', {
			controller: 'BackupController',
			'templateUrl': config.getTemplatePath('backup/index'),
			'resolve': resolve
		})

		.when('/backup_servers/new', {
			controller: 'BackupServerEditController',
			'templateUrl': config.getTemplatePath('backup_servers/edit'),
			'resolve': resolve
		})
		.when('/backup_servers/:id/edit', {
			controller: 'BackupServerEditController',
			'templateUrl': config.getTemplatePath('backup_servers/edit'),
			'resolve': resolve
		})
		.when('/backup_servers/:id', {
			controller: 'BackupServerController',
			'templateUrl': config.getTemplatePath('backup_servers/show'),
			'resolve': resolve
		})

		.when('/background_schedules/new', {
			controller: 'BackgroundScheduleEditController',
			'templateUrl': config.getTemplatePath('background_schedules/edit'),
			'resolve': resolve
		})
		.when('/background_schedules/:id/edit', {
			controller: 'BackgroundScheduleEditController',
			'templateUrl': config.getTemplatePath('background_schedules/edit'),
			'resolve': resolve
		})
		.when('/background_schedules/:id', {
			controller: 'BackgroundScheduleController',
			'templateUrl': config.getTemplatePath('background_schedules/show'),
			'resolve': resolve
		})

		.when('/global_images', {
			controller: 'GlobalImagesController',
			'templateUrl': config.getTemplatePath('global_images/index'),
			'resolve': resolve
		})

		.otherwise({ 'redirectTo': '/dashboard' });
}]);

app.run(['$rootScope', 'BootstrapResource', 'eventTypeProvider', '$sce', function ($rootScope, BootstrapResource, eventTypeProvider, $sce) {
	console.log("bootstrap :: init");

	function on_bootstrap_success(data) {
		$rootScope.bootstrapData = data;

		console.log("bootstrap :: done");
		$rootScope.$broadcast(eventTypeProvider.INTERNAL_BOOTSTRAP_RESOLVED);
	}

	// Request bootstrap data
	BootstrapResource.get({}, on_bootstrap_success);

	$rootScope.getTrustedHtml = function (value) {
		return $sce.trustAsHtml(value);
	};

	$rootScope.getImages = function(application) {
		var imageNames = [];

		for (var i=0 ; i<application.images.length ; i++) {
			imageNames.push(application.images[i].name);
		}

		return imageNames.join(', ');
	};
}]);
