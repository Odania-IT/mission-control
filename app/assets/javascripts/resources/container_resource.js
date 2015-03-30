/*
 * global app: true
 * global config: true
 */
app.factory('ContainerResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('servers/:serverId/containers/:id');

	return $resource(basePath, {
		'serverId': '@serverId',
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
