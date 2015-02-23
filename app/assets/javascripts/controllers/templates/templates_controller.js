app.controller('TemplatesController', ['$rootScope', '$scope', 'TemplateResource', function ($rootScope, $scope, TemplateResource) {
	console.log("controller :: TemplatesController");

	function loadTemplates() {
		TemplateResource.get().$promise.then(function (data) {
			$scope.templates = data.templates;
		});
	}

	$scope.destroyTemplate = function(template) {
		TemplateResource.delete({id: template.id}).$promise.then(function () {
			loadTemplates();
		});
	};

	loadTemplates();
}]);
