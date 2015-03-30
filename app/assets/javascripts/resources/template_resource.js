/*
 * global app: true
 * global config: true
 */
app.factory('TemplateResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('templates/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
