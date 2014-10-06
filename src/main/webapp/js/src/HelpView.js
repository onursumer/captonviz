var HelpView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var variables = {};

		// compile the template using underscore
		var template = _.template(
			$("#help_template").html(),
			variables);

		// load the compiled HTML into the Backbone "el"
		self.$el.html(template);

		self.format();

	},
	format: function()
	{
		var self = this;

		// add legend component
		var help = new Legend({
			el: self.$el.find(".legend"),
			items: [
				{name: "Edge Sign (1)", color: "#FF0000"},
				{name: "Edge Sign (-1)", color: "#0000FF"},
				{name: "In Pathway Commons (PC)", color: "#11FA34"},
				{name: "Not In PC", color: "#7F7F7F"},
				{name: "Default/Unknown", color: "#444"}
			]});

		help.init();
	}
});
