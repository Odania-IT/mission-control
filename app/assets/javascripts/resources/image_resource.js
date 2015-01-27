app.factory('ImageResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('images/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
