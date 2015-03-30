/* global app: true */
app.factory('resolveService', ['BootstrapResource', '$q', function (BootstrapResource, $q) {
	var resolved = {
		'bootstrap': {
			'data': null,
			'resolved': false
		}
	};

	function resolveBootstrap() {
		var deferred = $q.defer();

		if (resolved.bootstrap.resolved) {
			deferred.resolve(resolved.bootstrap.data);
			return deferred.promise;
		}

		BootstrapResource.get().$promise.then(function (data) {
			console.log('bootstrap :: resolved', data);
			resolved.bootstrap.data = data;
			resolved.bootstrap.resolved = true;
			deferred.resolve(resolved.bootstrap.data);
		});

		return deferred.promise;
	}

	return {
		'resolveBootstrap': resolveBootstrap
	};
}]);
