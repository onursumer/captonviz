// TODO code duplication! -- see CustomControlsView
var UploadControlsView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var methodOptions = [];
		var selectTemplateFn = _.template($("#select_item_template").html());

		methodOptions.push(selectTemplateFn({selectId: "spearmanCor", selectName: "SpearmanCor"}));
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

		var methodBox = self.$el.find("#upload-methods-box");
		var edgeBox = self.$el.find("#upload-edge-color-box");
		var labelBox = self.$el.find("#upload-node-label-box");
		var incButton = self.$el.find("#upload-increase-button");
		var decButton = self.$el.find("#upload-decrease-button");
		var edgesInfo = self.$el.find("#upload-number-of-edges-info");

		var uploadHelp = self.$el.find(".upload-file-help");
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

		uploadHelp.fancybox();

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
			var color = edgeBox.val() || "edgesign";
			var label = labelBox.val() || "prot";

			var dataUploadForm = self.$el.find(".data-file-form");

			var fileInput = self.$el.find(".custom-data");

			if (!fileInput.val() ||
			    fileInput.val().length === 0)
			{
				// no file selected yet
				ViewUtil.displayErrorMessage(
					"Please select a data matrix file to upload first.");
				return;
			}

			DataUtil.postFile('upload/file/' + method + "/" + size,
				new FormData(dataUploadForm[0]),
				// success callback
				function(response) {
					var data = {nodes: response.nodes,
						edges: response.edges};

					var model = {data: data, edgeColor: color, nodeLabel: label};

					var networkOpts = {el: "#main-network-view", model: model};
					var networkView = new NetworkView(networkOpts);
					self.networkView = networkView;

					networkView.render();
				},
				// error callback
		        function(err) {
			        ViewUtil.displayErrorMessage(
				        "Error processing the data matrix file. " +
				        "Please make sure that your file is valid.");
		        }
			);

			// display loader message before actually loading the data
			// it will be replaced by the network view once data is fetched
			ViewUtil.initNetworkView();
		});
	}
});
