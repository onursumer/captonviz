var ControlsView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var studies = new CancerStudies();
		var methods = new Methods();

		studies.fetch({
			success: function()
			{
				var studyOptions = [];

				_.each(studies.models, function(study) {
					studyOptions.push(_.template($("#select_item_template").html(),
						{selectId: study.studyId, selectName: study.studyName}));
				});

				methods.fetch({
					success: function()
					{
						var methodOptions = [];

						_.each(methods.models, function(method) {
							methodOptions.push(_.template($("#select_item_template").html(),
								{selectId: method.methodId, selectName: method.methodName}));
						});

						var variables = {studyOptions: studyOptions.join(""),
							methodOptions: methodOptions.join("")};

						// compile the template using underscore
						var template = _.template(
							$("#network_controls_template").html(),
							variables);

						// load the compiled HTML into the Backbone "el"
						self.$el.html(template);

						self.format();
					}
				});
			}
		});
	},
	format: function()
	{
		var self = this;

		var submit = self.$el.find(".visualize-study");

		submit.click(function() {
			var studyId = self.$el.find(".cancer-studies-box").val();
			var method = self.$el.find(".methods-box").val();

			var studyData = new StudyData({studyId: studyId,
				method: method});

			studyData.fetch({
				success: function()
				{
					//var data = {nodes: studyData.nodes, edges: studyData.edges};
					var data = {nodes: studyData.attributes.nodes,
						edges: studyData.attributes.edges};

					var networkOpts = {el: "#network_container", model: {data: data}};
					var networkView = new NetworkView(networkOpts);

					networkView.render();
				}
			});
		});
	}
});
