/*
 * global app: true
 * global config: true
 */
app.factory('BootstrapResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('bootstrap');

	return $resource(basePath);
}]);
