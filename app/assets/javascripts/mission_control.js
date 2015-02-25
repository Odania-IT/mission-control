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
