app.controller('BackupServersController', ['$rootScope', '$scope', 'BackupServerResource', function ($rootScope, $scope, BackupServerResource) {
	console.log("controller :: BackupServersController");

	function loadBackupServers() {
		BackupServerResource.get().$promise.then(function (data) {
			$scope.backupServers = data.backup_servers;
		});
	}

	$scope.destroyBackupServer = function(server) {
		BackupServerResource.delete({id: server.id}).$promise.then(function () {
			loadBackupServers();
		});
	};

	loadBackupServers();
}]);
