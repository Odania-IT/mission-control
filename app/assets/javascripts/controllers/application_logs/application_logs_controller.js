/* global app: true */
app.controller('ApplicationLogsController', ['$rootScope', '$scope', 'ApplicationLogResource', function ($rootScope, $scope, ApplicationLogResource) {
	console.log("controller :: ApplicationLogsController");

	function loadApplicationLogsController() {
		ApplicationLogResource.get({page: $scope.data.page}).$promise.then(function (data) {
			$scope.application_logs = data.application_logs;
			$scope.data.page = data.page;
			$scope.data.totalPages = data.total_page_count;
			$scope.data.totalRowCount = data.total_row_count;
			$scope.data.perPage = data.per_page;
		});
	}

	$scope.data = {
		page: 1,
		totalPages: 1,
		totalRowCount: 1,
		perPage: 20
	};

	loadApplicationLogsController();
}]);
