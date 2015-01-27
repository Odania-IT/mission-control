app.controller('ApplicationEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'ApplicationResource', function ($rootScope, $scope, $routeParams, $location, ApplicationResource) {
	console.log("controller :: ApplicationEditController");

	function init() {
		if ($routeParams.id) {
			ApplicationResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.application = data;
			});
		}
	}

	function onSuccessCallback() {
		$location.path('applications');
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

	$scope.editDomain = function (idx, val) {
		$scope.application.domains[idx] = val;
	};

	$scope.addDomain = function() {
		var domain;

		// Check if we already have an empty value
		for (var i=0 ; i<$scope.application.domains.length ; i++) {
			domain = $scope.application.domains[i];

			if (domain == "") {
				return;
			}
		}

		$scope.application.domains.push("");
	};

	$scope.removeDomain = function(idx) {
		if (idx >= 0) {
			$scope.application.domains.splice(idx, 1);
		}
	};

	$scope.application = {
		'id': '',
		'domains': []
	};

	init();
}]);
