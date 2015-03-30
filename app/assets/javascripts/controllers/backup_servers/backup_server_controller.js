/* global app: true */
app.controller('BackupServerController', ['$rootScope', '$scope', '$routeParams', 'BackupServerResource', function ($rootScope, $scope, $routeParams, BackupServerResource) {
	console.log("controller :: BackupServerController");

	function loadBackupServer() {
		BackupServerResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.backupServer = data;
		});
	}

	loadBackupServer();
}]);
