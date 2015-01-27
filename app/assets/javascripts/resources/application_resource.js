app.factory('ApplicationResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('applications/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
