app.controller('ImagesController', ['$rootScope', '$scope', 'ImageResource', function ($rootScope, $scope, ImageResource) {
	console.log("controller :: ImagesController");

	function loadImages() {
		ImageResource.get().$promise.then(function (data) {
			$scope.images = data.images;
		});
	}

	$scope.destroyImage = function(image) {
		ImageResource.delete({id: image.id}).$promise.then(function () {
			loadImages();
		});
	};

	loadImages();
}]);
