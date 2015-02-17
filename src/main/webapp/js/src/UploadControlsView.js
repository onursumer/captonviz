// TODO code duplication! -- see CustomControlsView
var UploadControlsView = Backbone.View.extend({
	render: function()
	{
		var self = this;

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
			$("#upload_controls_template").html(),
			variables);

		// load the compiled HTML into the Backbone "el"
		self.$el.html(template);

		self.format();
	},
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
		//var sampleInput = self.$el.find("#sample-list-input");

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

		// TODO a workaround for dropkick,
		// somehow all dropboxes under this tab are invisible by default!
		self.$el.find(".dk_container").addClass("dk_shown dk_theme_default");

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

		// fetches study data from server
		var fetchStudyData = function(studyData, validation, color, label)
		{
			studyData.fetch({
				type: "POST",
				data: {samples: studyData.get("samples")},
				success: function(collection, response, options)
				{
					// display notification for validated samples
					(new NotyView({template: "#noty-network-loaded-template",
						model: {
							numberOfSamples: validation.validSamples.length,
							type: "success"
						}
					})).render();

					if (validation.invalidSamples.length > 0)
					{
						(new NotyView({template: "#noty-invalid-sample-template",
							warning: true,
							timeout: 20000,
							model: {
								numberOfSamples: validation.invalidSamples.length,
								sampleList: validation.invalidSamples.sort().join(", ")
							}
						})).render();
					}

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
						"Error retrieving customized data.");
				}
			});
		};

		// trigger a custom 'fileselect' event when a file selected
		$(document).on('change', '.btn-file :file', function() {
			var input = $(this);

			var	numFiles = input.get(0).files ? input.get(0).files.length : 1;
			var	label = input.val().replace(/\\/g, '/').replace(/.*\//, '');

			input.trigger('fileselect', [numFiles, label]);
		});

		var uploadButton = self.$el.find(".btn-file :file");

		uploadButton.on('fileselect', function(event, numFiles, label) {
			self.$el.find(".selected-file-info").text("(" + label + ")");
		});

		var submit = self.$el.find("#visualize-study");

		submit.click(function() {
			var method = methodBox.val();
			var size = edgeSlider.slider("value");
			var color = edgeBox.val();
			var label = labelBox.val();
			//var samples = sampleInput.val().trim().split(/\s+/).join("|");

			var dataUploadForm = self.$el.find(".data-file-form");

			// TODO upload input data and init view
			DataUtil.postFile('upload/file',
				new FormData(dataUploadForm[0]),
				function(data) {
					// if no file selected, use the text area input (samples)
					var input = _.isEmpty(data) ? samples : data;

					// TODO everything should be implemented here...
					console.log(data);
			});

			// display loader message before actually loading the data
			// it will be replaced by the network view once data is fetched
			$("#main-network-view").html(_.template(
				$("#loader_template").html(), {}));
		});
	}
});
