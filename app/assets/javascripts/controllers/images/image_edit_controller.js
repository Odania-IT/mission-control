app.controller('ImageEditController', ['$rootScope', '$scope', '$routeParams', '$location', 'ImageResource', function ($rootScope, $scope, $routeParams, $location, ImageResource) {
	console.log("controller :: ImageEditController");

	function init() {
		if ($routeParams.id) {
			ImageResource.get({id: $routeParams.id}).$promise.then(function (data) {
				$scope.image = data;
			});
		}
	}

	function onSuccessCallback() {
		$location.path('images');
	}

	function onErrorCallback(err) {
		$scope.errors = err.data.errors;
	}

	$scope.saveImage = function () {
		if ($routeParams.id) {
			ImageResource.update({
				id: $routeParams.id,
				image: $scope.image
			}).$promise.then(onSuccessCallback, onErrorCallback);
		} else {
			ImageResource.save({image: $scope.image}).$promise.then(onSuccessCallback, onErrorCallback);
		}
	};

	$scope.editArray = function (name, idx, val) {
		$scope.image[name][idx] = val;

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

			if (parts.length == 1) {
				checkParts.push(parts[0]);
			} else if (parts.length == 2) {
				if (parts[0] !== '') {
					checkParts.push(parts[0]);
				}
				checkParts.push(parts[1]);
			} else if (parts.length == 3) {
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
		for (var i = 0; i < $scope.image[name].length; i++) {
			entry = $scope.image[name][i];

			if (entry == "") {
				return;
			}
		}

		$scope.image[name].push("");
	};

	$scope.removeFromArray = function (name, idx) {
		if (idx >= 0) {
			$scope.image[name].splice(idx, 1);
		}
	};

	$scope.image = {
		'id': '',
		'ports': [],
		'links': [],
		'volumes': [],
		'environment': []
	};

	init();
}
])
;