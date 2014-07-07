var MainView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var variables = {};

		// compile the template using underscore
		var template = _.template(
			$("#main-view-template").html(),
			variables);

		// load the compiled HTML into the Backbone "el"
		self.$el.html(template);

		self.format();

	},
	format: function()
	{
		var defaultView = new ControlsView({el: "#graph-settings"});
		var customView = new CustomControlsView({el: "#custom-settings"});

		defaultView.render();
		customView.render();
	}
});
