app.controller('FlashController', ['$scope', '$timeout', 'eventTypeProvider', function ($scope, $timeout, eventTypeProvider) {
	var flashTypeMapping = {
			'Error': 'danger',
			'Warning': 'warning',
			'Notice': 'info',
			'Message': 'success'
		},
		timeout = {
			'duration': 3000,
			'promise': null
		},
		flashes = [];

	function hide() {
		$scope.flash = null;
		show();
	}

	function show() {
		if (!flashes.length || $scope.flash) {
			return;
		}

		$scope.flash = flashes.pop();

		timeout.promise = $timeout(hide, timeout.duration);
	}

	function onFlash($event, type, message) {
		flashes.push({
			'type': flashTypeMapping[type],
			'message': message
		});

		show();
	}

	// scope vars
	$scope.flash = null;

	// scope methods
	$scope.hide = hide;

	// scope event callbacks
	$scope.$on(eventTypeProvider.INTERNAL_FLASH_NOTICE, onFlash);
}]);
