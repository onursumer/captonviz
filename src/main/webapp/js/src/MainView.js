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
		var self = this;

		var defaultView = new ControlsView({el: "#graph-settings"});
		var customView = new CustomControlsView({el: "#custom-settings"});
		var helpView = new HelpView({el: "#vis-help"});

		var legend = new Legend({
			el: self.$el.find("#horizontal-edge-legend"),
			elWidth: 620,
			elHeight: 30,
			orientation: "horizontal",
			items: [ // TODO items: code duplication
				{name: "Edge Sign (1)", color: "#FF0000"},
				{name: "Edge Sign (-1)", color: "#0000FF"},
				{name: "In PC", color: "#11FA34"},
				{name: "Not In PC", color: "#7F7F7F"}
				//{name: "Default/Unknown", color: "#444"}
			]});

		legend.init();

		defaultView.render();
		customView.render();
		helpView.render();
	}
});
