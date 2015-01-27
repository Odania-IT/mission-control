app.factory('eventTypeProvider', function () {

	return {
		// internal events
		'INTERNAL_BOOTSTRAP_RESOLVED': 'internal/bootstrap/resolved',
		'INTERNAL_DATA_LOADING': 'internal/loading/data',
		'INTERNAL_DATA_LOADED': 'internal/loaded/data',

		// flashes
		'INTERNAL_FLASH_NOTICE': 'internal/flash/notice'
	};

});
