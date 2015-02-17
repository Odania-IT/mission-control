app.controller('RepositoryController', ['$rootScope', '$scope', '$routeParams', 'RepositoryResource', function ($rootScope, $scope, $routeParams, RepositoryResource) {
	console.log("controller :: RepositoryController");

	function loadRepositories() {
		RepositoryResource.get({id: $routeParams.id}).$promise.then(function (data) {
			$scope.repository = data;
		});
	}

	loadRepositories();
}]);
