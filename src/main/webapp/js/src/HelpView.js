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
		// TODO replace items with actual values...
		var help = new Legend({
			el: self.$el.find(".legend"),
			items: [
				{name: "Unknown", color: "#666666"},
				{name: "Missing", color: "#A056F0"}
			]});

		help.init();
	}
});
