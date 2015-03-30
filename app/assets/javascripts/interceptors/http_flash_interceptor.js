/* global app: true */
app.factory('httpFlashInterceptorService', ['$rootScope', 'eventTypeProvider', '$q', function ($rootScope, eventTypeProvider, $q) {
	var flashTypes = [
		'Error', 'Warning', 'Notice', 'Message'
	];

	function checkFlashes(httpResponse) {
		flashTypes.forEach(function (flashType) {
			var flash = httpResponse.headers('X-Flash-' + flashType),
				eventName;

			if (!flash) {
				return;
			}

			eventName = eventTypeProvider.INTERNAL_FLASH_NOTICE;
			$rootScope.$broadcast(eventName, flashType, flash);
		});
	}

	function response(httpResponse) {
		checkFlashes(httpResponse);
		return httpResponse;
	}

	function responseError(rejection) {
		checkFlashes(rejection);
		return $q.reject(rejection);
	}

	return {
		'response': response,
		'responseError': responseError
	};
}]);
