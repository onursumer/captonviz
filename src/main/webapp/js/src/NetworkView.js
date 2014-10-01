var NetworkView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var container = $(self.el);

		var pcVizLayoutOptions = {
			name: 'pcvizarbor',
			liveUpdate: true,
//			nodeMass: function(e) { return e.isseed ? 2.5 : 0.2; },
			nodeMass: 0.2,
//			edgeLength: function(e) {
//				return edgeLengthArray[e.id];
//			},
			repulsion: 1800,
			stiffness: 75,
			gravity: true,
			maxIterations: 75,
			displayStepSize: 5,
			stableEnergy: function(energy) {
				return (energy.max <= 2) || (energy.mean <= 0.5);
			},
			precision: 0
		}; // end of pcVizLayoutOptions

		var captonVizStyle = cytoscape.stylesheet()
	        .selector("node")
	        .css({
	            "content": "data(" + self.model.nodeLabel +")",
	            "width": 20,
	            "height": 20,
	            //"shape": "data(shape)",
	            "border-width": 2,
	            //"background-color": "mapData(altered, 0, 1, #DDDDDD, red)",
				"background-color": "#DDDDDD",
	            "border-color": "#555",
	            "font-size": "15"
	        })
	        .selector("edge")
	        .css({
	            //"width": "mapData(cited, 5, 50, 0.4, 0.5)",
				"width": 1.5,
	            "line-color": "#444"
	        })
	        .selector("[?isdirected]")
	        .css({
	            "target-arrow-shape": "triangle"
	        })
	        .selector(":selected")
	        .css({
	            "background-color": "#000",
	            "line-color": "#000",
	            "source-arrow-color": "#000",
	            "target-arrow-color": "#000"
	        });

		if (self.model.edgeColor == "edgesign")
		{
			captonVizStyle.selector("edge[edgesign=1]")
				.css({
					"line-color": "#FF0000"
				})
				.selector("edge[edgesign=-1]")
				.css({
					"line-color": "#0000FF"
				});
		}
		else
		{
			captonVizStyle.selector("edge[inpc=0]")
				.css({
					"line-color": "#7F7F7F"
				})
				.selector("edge[inpc=1]")
				.css({
					"line-color": "#11FA34"
				});
		}

		container.empty();

		container.cytoscape({
			elements: self.model.data,
			style: captonVizStyle,
			layout: pcVizLayoutOptions,
			ready: function()
			{
				self.cy = this;
			}
		});
	},
	updateEdgeStyle: function(edgeColor)
	{
		var self = this;
		var cy = self.cy;

		if (!cy)
		{
			return;
		}

		if (edgeColor == "edgesign")
		{
			cy.style().selector("edge[edgesign=1]")
				.css({
					"line-color": "#FF0000"
				})
				.selector("edge[edgesign=-1]")
				.css({
					"line-color": "#0000FF"
				})
				.update();
		}
		else
		{
			cy.style().selector("edge[inpc=0]")
				.css({
					"line-color": "#7F7F7F"
				})
				.selector("edge[inpc=1]")
				.css({
					"line-color": "#11FA34"
				})
				.update();
		}
	},
	updateNodeStyle: function(nodeLabel)
	{
		var self = this;
		var cy = self.cy;

		if (!cy)
		{
			return;
		}

		cy.style().selector("node")
			.css({"content": "data(" + nodeLabel +")"})
			.update();
	}

});
