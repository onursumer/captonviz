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

		container.cytoscape({
			elements: self.model.data,
			style: cytoscape.stylesheet(),
			layout: pcVizLayoutOptions
		});
	}
});
