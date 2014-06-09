// This is for the moustache-like templates
// prevents collisions with JSP tags
_.templateSettings = {
	interpolate : /\{\{(.+?)\}\}/g
};

$(document).ready(function() {
	var controlsView = new ControlsView({el: "#network_controls"});
	controlsView.render();
});
