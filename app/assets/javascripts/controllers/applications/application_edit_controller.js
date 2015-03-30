app.controller('ApplicationEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'ApplicationResource', function ($rootScope, $scope, $routeParams, $location, ApplicationResource) {
	console.log("controller :: ApplicationEditController");

	function init() {
		if ($routeParams.id) {
			ApplicationResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.application = data;
			});
		}
	}

	function onSuccessCallback(data) {
		$location.path('applications/'+data.id);
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveApplication = function () {
		if ($routeParams.id) {
			ApplicationResource.update({
				id: $routeParams.id,
				application: $scope.application
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			ApplicationResource.save({application: $scope.application}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.editArray = function (name, idx, val) {
		$scope.application[name][idx] = val;
	};

	$scope.addToArray = function (name) {
		var entry;

		// Check if we already have an empty value
		for (var i = 0; i < $scope.application[name].length; i++) {
			entry = $scope.application[name][i];

			if (entry === "") {
				return;
			}
		}

		$scope.application[name].push("");
	};

	$scope.removeFromArray = function (name, idx) {
		if (idx >= 0) {
			$scope.application[name].splice(idx, 1);
		}
	};

	$scope.application = {
		'id': '',
		'domains': [],
		'ports': []
	};

	init();
}]);
