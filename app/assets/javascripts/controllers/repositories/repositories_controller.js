/* global app: true */
app.controller('RepositoriesController', ['$rootScope', '$scope', 'RepositoryResource', function ($rootScope, $scope, RepositoryResource) {
	console.log("controller :: RepositoriesController");

	function loadRepositories() {
		RepositoryResource.get().$promise.then(function (data) {
			$scope.repositories = data.repositories;
		});
	}

	$scope.destroyRepository = function(server) {
		RepositoryResource.delete({id: server.id}).$promise.then(function () {
			loadRepositories();
		});
	};

	loadRepositories();
}]);
