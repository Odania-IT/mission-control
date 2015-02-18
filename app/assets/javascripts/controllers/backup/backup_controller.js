app.controller('BackupController', ['$rootScope', '$scope', 'BackupServerResource', 'BackgroundScheduleResource', function ($rootScope, $scope, BackupServerResource, BackgroundScheduleResource) {
	console.log("controller :: BackupController");

	function init() {
		loadBackupServers();
		loadBackgroundSchedules();
	}

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

	function loadBackgroundSchedules() {
		BackgroundScheduleResource.get().$promise.then(function (data) {
			$scope.backgroundSchedules = data.background_schedules;
		});
	}

	$scope.destroyBackgroundSchedule = function(schedule) {
		BackgroundScheduleResource.delete({id: schedule.id}).$promise.then(function () {
			loadBackupServers();
		});
	};

	init();
}]);
