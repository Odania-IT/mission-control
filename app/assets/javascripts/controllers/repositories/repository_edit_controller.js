app.controller('RepositoryEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'RepositoryResource', function ($rootScope, $scope, $routeParams, $location, RepositoryResource) {
	console.log("controller :: RepositoryEditController");

	function init() {
		if ($routeParams.id) {
			RepositoryResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.repository = data;
			});
		}
	}

	function onSuccessCallback(data) {
		$location.path('repositories/'+data.id);
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveRepository = function () {
		if ($routeParams.id) {
			RepositoryResource.update({
				id: $routeParams.id,
				repository: $scope.repository
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			RepositoryResource.save({repository: $scope.repository}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.repository = {
		'id': '',
		'url': '',
		'user': ''
	};

	init();
}]);
