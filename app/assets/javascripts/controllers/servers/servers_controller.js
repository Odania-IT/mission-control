app.controller('ServersController', ['$rootScope', '$scope', 'ServerResource', function ($rootScope, $scope, ServerResource) {
	console.log("controller :: ServersController");

	function loadServers() {
		ServerResource.get().$promise.then(function (data) {
			$scope.servers = data.servers;
		});
	}

	$scope.destroyServer = function(server) {
		ServerResource.delete({id: server.id}).$promise.then(function () {
			loadServers();
		});
	};

	loadServers();
}]);
