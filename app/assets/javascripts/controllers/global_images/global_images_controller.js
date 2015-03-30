/* global app: true */
app.controller('GlobalImagesController', ['$location', 'ApplicationResource', function ($location, ApplicationResource) {
	console.log("controller :: GlobalImagesController");

	ApplicationResource.getGlobalApplication().$promise.then(function (data) {
		$location.path('/applications/'+data.id);
	});
}]);
