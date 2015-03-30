app.controller('TemplateEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'TemplateResource', function ($rootScope, $scope, $routeParams, $location, TemplateResource) {
	console.log("controller :: TemplateEditController");

	function init() {
		if ($routeParams.id) {
			TemplateResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.template = data;
			});
		}
	}

	function onSuccessCallback() {
		$location.path('templates');
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveTemplate = function () {
		if ($routeParams.id) {
			TemplateResource.update({
				id: $routeParams.id,
				template: $scope.template
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			TemplateResource.save({template: $scope.template}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.editArray = function (name, idx, val) {
		$scope.template[name][idx] = val;

		if (name === 'environment') {
			if (val.indexOf('=') === -1) {
				$('#environment-' + idx).addClass('has-error');
			} else {
				$('#environment-' + idx).removeClass('has-error');
			}
		} else if (name === 'ports') {
			/*
			 * can be:
			 * - port
			 * - host_port:port
			 * - ip:host_port:port
			 * - ip::port
			 */
			var parts = val.split(':'),
				valid = true, checkParts = [];

			if (parts.length === 1) {
				checkParts.push(parts[0]);
			} else if (parts.length == 2) {
				if (parts[0] !== '') {
					checkParts.push(parts[0]);
				}
				checkParts.push(parts[1]);
			} else if (parts.length === 3) {
				// Part 0 is ip to bind to
				checkParts.push(parts[1]);
				checkParts.push(parts[2]);
			} else {
				valid = false;
			}

			for (var i = 0; i < checkParts.length; i++) {
				if (isNaN(checkParts[i])) {
					valid = false;
					break;
				}
			}

			if (!valid) {
				$('#port-' + idx).addClass('has-error');
			} else {
				$('#port-' + idx).removeClass('has-error');
			}
		}
	};

	$scope.addToArray = function (name) {
		var entry;

		// Check if we already have an empty value
		for (var i = 0; i < $scope.template[name].length; i++) {
			entry = $scope.template[name][i];

			if (entry === "") {
				return;
			}
		}

		$scope.template[name].push("");
	};

	$scope.removeFromArray = function (name, idx) {
		if (idx >= 0) {
			$scope.template[name].splice(idx, 1);
		}
	};

	$scope.template = {
		'id': '',
		'ports': [],
		'volumes': [],
		'environment': [],
		'images': []
	};

	init();
}]);
