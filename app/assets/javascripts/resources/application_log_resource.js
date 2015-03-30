/*
 * global app: true
 * global config: true
 */
app.factory('ApplicationLogResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('application_logs/:id');

	return $resource(basePath, {
		'id': '@id'
	});
}]);
