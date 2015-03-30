/*
 * global app: true
 * global config: true
 */
app.factory('RepositoryResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('repositories/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
