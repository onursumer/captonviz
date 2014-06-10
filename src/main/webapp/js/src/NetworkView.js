var NetworkView = Backbone.View.extend({
	render: function()
	{
		var self = this;

		var container = $(self.el);

		var pcVizLayoutOptions = {
			name: 'pcvizarbor',
			liveUpdate: true,
			nodeMass: function(e) { return e.isseed ? 2.5 : 0.2; },
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
	            "content": "data(prot)",
	            //"shape": "data(shape)",
	            "border-width": 3,
	            //"background-color": "mapData(altered, 0, 1, #DDDDDD, red)",
				"background-color": "#DDDDDD",
	            "border-color": "#555",
	            "font-size": "15"
	        })
	        .selector("edge")
	        .css({
	            //"width": "mapData(cited, 5, 50, 0.4, 0.5)",
	            "line-color": "#444"
	        })
	        .selector("[?isdirected]")
	        .css({
	            "target-arrow-shape": "triangle"
	        })
	        .selector("edge[edgesign=1]")
	        .css({
	            "line-color": "#FF0000"
	        })
			.selector("edge[edgesign=-1]")
	        .css({
	            "line-color": "#0000FF"
	        })
	        .selector(":selected")
	        .css({
	            "background-color": "#000",
	            "line-color": "#000",
	            "source-arrow-color": "#000",
	            "target-arrow-color": "#000"
	        });

		container.empty();

		container.cytoscape({
			elements: self.model.data,
			style: captonVizStyle,
			layout: pcVizLayoutOptions
		});
	}
});
