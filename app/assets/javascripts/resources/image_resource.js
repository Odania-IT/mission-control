app.factory('ImageResource', ['$resource', function ($resource) {
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
