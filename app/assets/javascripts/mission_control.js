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

		.when('/images', {
			controller: 'ImagesController',
			'templateUrl': config.getTemplatePath('images/index'),
			'resolve': resolve
		})
		.when('/images/new', {
			controller: 'ImageEditController',
			'templateUrl': config.getTemplatePath('images/edit'),
			'resolve': resolve
		})
		.when('/images/:id/edit', {
			controller: 'ImageEditController',
			'templateUrl': config.getTemplatePath('images/edit'),
			'resolve': resolve
		})
		.when('/images/:id', {
			controller: 'ImageController',
			'templateUrl': config.getTemplatePath('images/show'),
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
}]);