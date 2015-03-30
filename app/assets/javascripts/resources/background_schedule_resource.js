/*
 * global app: true
 * global config: true
 */
app.factory('BackgroundScheduleResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('background_schedules/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
