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
				var studyList = studies.models.sort(function(a, b) {
					if (a.studyName > b.studyName)
					{
						return 1;
					}
					else
					{
						return -1;
					}
				});

				_.each(studyList, function(study) {
					studyOptions.push(_.template($("#select_item_template").html(),
						{selectId: study.studyId, selectName: study.studyName}));
				});

				methods.fetch({
					success: function()
					{
						var methodOptions = [];
						var methodList = methods.models.sort(function(a, b) {
							if (a.methodName > b.methodName)
							{
								return 1;
							}
							else
							{
								return -1;
							}
						});

						_.each(methodList, function(method) {
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

		var minVal = 0;
		var defaultVal = 100;
		// TODO exact maxVal depends on the network size..
		var maxVal = 1000;

		var studyBox = self.$el.find("#cancer-studies-box");
		var methodBox = self.$el.find("#methods-box");
		var edgeBox = self.$el.find("#edge-color-box");
		var labelBox = self.$el.find("#node-label-box");

		var edgeSlider = self.$el.find(".ui-slider");

		$("#number-of-genes-info").html(defaultVal);

		studyBox.dropkick();
		methodBox.dropkick();
		labelBox.dropkick();
		edgeBox.dropkick();

		edgeSlider.slider({
			min: minVal,
			max: maxVal,
			value: defaultVal,
			orientation: "horizontal",
			range: "min",
			slide: function(event, ui) {
				$("#number-of-genes-info").html(ui.value);
			},
			change: function(event, ui) {
				$("#slider-help-row").fadeOut();
			}
		});

		var submit = self.$el.find("#visualize-study");

		submit.click(function() {
			var studyId = studyBox.val();
			var method = methodBox.val();
			var size = edgeSlider.slider("value");
			var color = edgeBox.val();
			var label = labelBox.val();

			var studyData = new StudyData({studyId: studyId,
				method: method,
				size: size});

			studyData.fetch({
				success: function()
				{
					//var data = {nodes: studyData.nodes, edges: studyData.edges};
					var data = {nodes: studyData.attributes.nodes,
						edges: studyData.attributes.edges};

					var model = {data: data, edgeColor: color, nodeLabel: label};

					var networkOpts = {el: "#main-network-view", model: model};
					var networkView = new NetworkView(networkOpts);

					networkView.render();
				}
			});
		});
	}
});
