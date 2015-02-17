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
			orientation: "vertical",
			items: [
				{name: "Edge Sign (Positive)", color: "#FF0000"},
				{name: "Edge Sign (Negative)", color: "#0000FF"},
				{name: "In Pathway Commons", color: "#11FA34"},
				{name: "Not In Pathway Commons", color: "#7F7F7F"}
				//{name: "Default/Unknown", color: "#444"}
			]});

		help.init();
	}
});
