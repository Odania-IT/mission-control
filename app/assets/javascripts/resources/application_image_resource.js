/*
 * global app: true
 * global config: true
 */
app.factory('ApplicationImageResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('applications/:applicationId/images/:id');

	return $resource(basePath, {
		'applicationId': '@applicationId',
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
