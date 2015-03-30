/* global app: true */
app.controller('TemplateController', ['$rootScope', '$scope', '$routeParams', 'TemplateResource', function ($rootScope, $scope, $routeParams, TemplateResource) {
	console.log("controller :: TemplateController");

	TemplateResource.get({id: $routeParams.id}).$promise.then(function (data) {
		$scope.template = data;
	});
}]);
