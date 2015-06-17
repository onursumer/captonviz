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
		var maxVal = 500;

		var studyBox = self.$el.find("#cancer-studies-box");
		var methodBox = self.$el.find("#methods-box");
		var edgeBox = self.$el.find("#edge-color-box");
		var labelBox = self.$el.find("#node-label-box");
		var incButton = self.$el.find("#increase-button");
		var decButton = self.$el.find("#decrease-button");
		var edgesInfo = self.$el.find("#number-of-edges-info");

		var edgeSlider = self.$el.find(".ui-slider");

		edgesInfo.html(defaultVal);

		// make ridgenet selected by default
		self.$el.find("option[value='ridgenet']").attr("selected", "");

		studyBox.dropkick();
		methodBox.dropkick();
		labelBox.dropkick({change: function(value, label) {
			if (self.networkView)
			{
				self.networkView.updateNodeStyle(value);
			}
		}});
		edgeBox.dropkick({change: function(value, label) {
			if (self.networkView)
			{
				self.networkView.updateEdgeStyle(value);
			}
		}});

		edgeSlider.slider({
			min: minVal,
			max: maxVal,
			value: defaultVal,
			orientation: "horizontal",
			range: "min",
			slide: function(event, ui) {
				edgesInfo.html(ui.value);
			},
			change: function(event, ui) {
				//$("#slider-help-row").fadeOut();
				edgesInfo.html(ui.value);
			}
		});

		decButton.click(function(e) {
			e.preventDefault();

			var oldVal = edgeSlider.slider("option", "value");
			var newVal = Math.max(oldVal-1, minVal);
			edgeSlider.slider({value: newVal});
		});

		incButton.click(function(e) {
			e.preventDefault();

			var oldVal = edgeSlider.slider("option", "value");
			var newVal = Math.min(oldVal+1, maxVal);
			edgeSlider.slider({value: newVal});
		});

		var submit = self.$el.find("#visualize-study");

		submit.click(function() {

			// display loader message before actually loading the data
			// it will be replaced by the network view once data is fetched
			ViewUtil.initNetworkView();

			var studyId = studyBox.val();
			var method = methodBox.val();
			var size = edgeSlider.slider("value");
			var color = edgeBox.val();
			var label = labelBox.val();

			var studyData = new StudyData({studyId: studyId,
				method: method,
				size: size});

			studyData.fetch({
				success: function(collection, response, options)
				{
					//var data = {nodes: studyData.nodes, edges: studyData.edges};
					var data = {nodes: response.nodes,
						edges: response.edges};

					var model = {data: data, edgeColor: color, nodeLabel: label};

					var networkOpts = {el: "#main-network-view", model: model};
					var networkView = new NetworkView(networkOpts);
					self.networkView = networkView;

					networkView.render();
				},
				error: function(collection, response, options)
				{
					ViewUtil.displayErrorMessage(
						"Error retrieving data.");
				}
			});
		});

		// initially load default view with default selection
		submit.click();
	}
});
