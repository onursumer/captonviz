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
		var uploadView = new UploadControlsView({el: "#upload-settings"});
		//var helpView = new HelpView({el: "#vis-help"});

		defaultView.render();
		customView.render();
		uploadView.render();
		//helpView.render();

		// search action handler function
		var handleSearch = function(e) {
			var searchText = $("#search-network-input").val().toLowerCase();

			if (window.cy)
			{
				// unselect all nodes (to clear the previous selection)
				window.cy.nodes().unselect();

				if (searchText.trim().length > 0)
				{
					var nodes = window.cy.filter(function (i, ele) {
						//var gene = ele.data()["gene"];
						//var prot = ele.data()["prot"];
						//
						//return (gene != null && gene.toLowerCase().indexOf(searchText) != -1) ||
						//       (prot != null && prot.toLowerCase().indexOf(searchText) != -1);

						// search within the label content (display value, not the data)
						var content = ele.style().content;
						return (content != null && content.trim().toLowerCase().indexOf(searchText) != -1);
					});

					if (nodes.size() > 0)
					{
						// select nodes
						nodes.select();
					}
					else
					{
						// display a warning message
						ViewUtil.displayWarningMessage(
							"No matching element found for the provided search text.");
					}
				}
			}
		};

		$("#search-network-input").keypress(function(e)
        {
            var enterCode = 13;
            if (e.keyCode == enterCode)
            {
	            handleSearch(e);
            }
        });

		// add listener for the search button
		$("#search-network").click(handleSearch);

		// add listener for download-network button
		$("#download-network").click(function(e) {
			e.preventDefault();
			//$("#download-network").trigger('click');

			if (window.cy)
			{
				DataUtil.requestDownload("download/network/sif",
					{filename: "network.txt", content: DataUtil.convertToSif(window.cy)});

				// TODO display a message
				// display notification for validated samples
//				(new NotyView({template: "#noty-network-downloaded-template",
//					model: {
//						numberOfEdges: window.cy.elements(["edge:visible"]).length(),
//						type: "success"
//					}
//				})).render();
			}
			else
			{
				ViewUtil.displayErrorMessage("Network is not initialized yet.");
			}
		});

		$("#full-screen-link").click(function(e) {
			e.preventDefault();

			if (window.cy)
			{
				var rightMenuTabs = self.$el.find("#rightMenuTabs");
				var rightMenuControls = self.$el.find("#rightMenuControls");
				var mainNetwork = self.$el.find("#main-network-view");
				var fullHeight = $(window).height() * 4/5 || 800;

				if (rightMenuTabs.is(":visible"))
				{
					rightMenuTabs.hide();
					rightMenuControls.hide();

					self.$el.css({width: "99%", height: "99%"});
					self.$el.find("div.span8").css({width: "99%", height: "99%"});
					self.$el.find("div.span8").css({width: "99%", height: "99%"});
					mainNetwork.css({width: "99%", height: fullHeight});
					window.cy.resize();
					window.cy.fit();

					self.$el.find(".full-screen-button-text").text("Standard Size");
				}
				else
				{
					self.$el.css({width: "", height: ""});
					self.$el.find("div.span8").css({width: "", height: ""});
					mainNetwork.css({width: "", height: ""});
					window.cy.resize();
					window.cy.fit();

					rightMenuControls.show();
					rightMenuTabs.show();

					self.$el.find(".full-screen-button-text").text("Full Size");
				}
			}
			else
			{
				// no network yet...
				ViewUtil.displayErrorMessage("Network is not initialized yet.");
			}
		});
	}
});
