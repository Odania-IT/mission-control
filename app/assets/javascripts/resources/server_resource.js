app.factory('ServerResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('servers/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
