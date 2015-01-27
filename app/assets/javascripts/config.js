function Config() {
	this.getApiPath = function getApiPath(path) {
		return '/api/' + path;
	};

	this.getTemplatePath = function getTemplatePath(name) {
		return ['/angular/view', '.html'].join('/' + name);
	};
}

var config = new Config();