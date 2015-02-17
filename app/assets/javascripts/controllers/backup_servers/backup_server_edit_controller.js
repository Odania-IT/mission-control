app.controller('BackupServerEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'BackupServerResource', function ($rootScope, $scope, $routeParams, $location, BackupServerResource) {
	console.log("controller :: BackupServerEditController");

	function init() {
		if ($routeParams.id) {
			BackupServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.backupServer = data;
			});
		}
	}

	function onSuccessCallback(data) {
		$location.path('backup_servers/'+data.id);
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveBackupServer = function () {
		if ($routeParams.id) {
			BackupServerResource.update({
				id: $routeParams.id,
				backup_server: $scope.backupServer
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			BackupServerResource.save({backup_server: $scope.backupServer}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.backupServer = {
		'id': '',
		'url': '',
		'user': ''
	};

	init();
}]);
