app.factory('BackupServerResource', ['$resource', function ($resource) {
	var basePath = config.getApiPath('backup_servers/:id');

	return $resource(basePath, {
		'id': '@id'
	}, {
		'update': {
			'method': 'PUT'
		}
	});
}]);
