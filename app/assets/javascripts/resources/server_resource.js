app.factory('ServerResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('servers/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		},
		'addApplication': {
			'method': 'POST',
			'url': basePath + '/add_application'
		},
		'removeApplication': {
			'method': 'POST',
			'url': basePath + '/remove_application'
		}
	});
}]);
