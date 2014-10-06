var CustomControlsView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		//var studies = new CancerStudies();
		//var methods = new Methods();

		// TODO actual method option names...
		var methodOptions = [];
		var selectTemplateFn = _.template($("#select_item_template").html());

		methodOptions.push(selectTemplateFn({selectId: "spearmanCor", selectName: "Spearman"}));
		methodOptions.push(selectTemplateFn({selectId: "genenet", selectName: "Genenet"}));
		methodOptions.push(selectTemplateFn({selectId: "ridgenet", selectName: "Ridgenet"}));
		methodOptions.push(selectTemplateFn({selectId: "lassonet", selectName: "Lassonet"}));
		methodOptions.push(selectTemplateFn({selectId: "aracne_m", selectName: "Aracne_m"}));

		var variables = {methodOptions: methodOptions.join("")};

		// compile the template using underscore
		var template = _.template(
			$("#custom_controls_template").html(),
			variables);

		// load the compiled HTML into the Backbone "el"
		self.$el.html(template);

		self.format();
	},
	// TODO code duplication!! -- see ControlsView
	format: function()
	{
		var self = this;

		var minVal = 0;
		var defaultVal = 100;
		// TODO exact maxVal depends on the network size..
		var maxVal = 500;

		var methodBox = self.$el.find("#methods-box");
		var edgeBox = self.$el.find("#edge-color-box");
		var labelBox = self.$el.find("#node-label-box");
		var incButton = self.$el.find("#increase-button");
		var decButton = self.$el.find("#decrease-button");
		var edgesInfo = self.$el.find("#number-of-edges-info");
		var sampleInput = self.$el.find("#sample-list-input");

		var edgeSlider = self.$el.find(".ui-slider");

		edgesInfo.html(defaultVal);

		// make ridgenet selected by default
		//self.$el.find("option[value='ridgenet']").attr("selected", "");

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

		// displays an error message to the user (on the network view)
		var displayErrorMessage = function(message)
		{
			var variables = {errorMessage: message};

			// compile the template using underscore
			var template = _.template(
				$("#error_template").html(),
				variables);

			$("#main-network-view").html(template);

			self.networkView = null;
		};

		// fetches study data from server
		var fetchStudyData = function(studyData, color, label)
		{
			studyData.fetch({
				success: function(collection, response, options)
				{
					// TODO display a success (noty) message...

					var data = {nodes: studyData.attributes.nodes,
						edges: studyData.attributes.edges};

					var model = {data: data, edgeColor: color, nodeLabel: label};

					var networkOpts = {el: "#main-network-view", model: model};
					var networkView = new NetworkView(networkOpts);
					self.networkView = networkView;

					networkView.render();
				},
				error: function(collection, response, options)
				{
					displayErrorMessage("Error retrieving customized data.<br>");
				}
			});
		};

		var submit = self.$el.find("#visualize-study");

		submit.click(function() {
			var method = methodBox.val();
			var size = edgeSlider.slider("value");
			var color = edgeBox.val();
			var label = labelBox.val();
			var samples = sampleInput.val().trim().split(/\s+/).join("|");

			if (samples == null ||
			    samples.length == 0)
			{
				// empty sample list...
				// TODO display a warning (noty) message?
				return;
			}

			// validate input sample list
			var validationData = new ValidationData({samples: samples});

			validationData.fetch({
				success: function(collection, response, options)
				{
					var studyData = new CustomStudyData({method: method,
						size: size,
						samples: samples});

					fetchStudyData(studyData, color, label);
				},
				error: function(collection, response, options)
				{
					displayErrorMessage("Error validating sample list.<br>");
				}
			});

			// display loader message before actually loading the data
			// it will be replaced by the network view once data is fetched
			$("#main-network-view").html(_.template(
				$("#loader_template").html(), {}));
		});
	}
});

