function Legend(options)
{
	var _defaultOpts = {
		el: "#legend", // container id
		elWidth: 200,  // total width
		elHeight: 200, // total height
		orientation: "vertical", // "horizontal" or "vertical"
		itemFont: 'inherit',    // font type of the y-axis label
		itemFontColor: "#2E3436",  // font color of the y-axis label
		itemFontSize: "16px",      // font size of y-axis label
		itemFontWeight: "normal",  // font weight of y-axis label
		itemWidth: 10,   // width of the color box
		itemHeight: 10,  // height of the color box
		itemPadding: 10, // padding between legend elements
		labelPadding: 5, // padding between the box and the label
		items: []        // color and name values like {name: "unknown", color: "#000000"}
	};

	// merge options with default options to use defaults for missing values
	var _options = jQuery.extend(true, {}, _defaultOpts, options);

	var _svg = null;

	/**
	 * Initializes the panel.
	 */
	function init()
	{
		// selecting using jQuery node to support both string and jQuery selector values
		var node = $(_options.el)[0];
		var container = d3.select(node);

		// create svg element & update its reference
		var svg = createSvg(container,
		                    _options.elWidth,
		                    _options.elHeight);

		_svg = svg;

		// (partially) draw the panel
		drawLegend(svg, _options);

		// add default listeners
		// addDefaultListeners();
	}

	/**
	 * Creates the main svg element.
	 *
	 * @param container target container (html element)
	 * @param width     widht of the svg
	 * @param height    height of the svg
	 * @return {object} svg instance (D3)
	 */
	function createSvg(container, width, height)
	{
		var svg = container.append("svg");

		svg.attr('width', width);
		svg.attr('height', height);

		return svg;
	}

	function drawLegend(svg, options)
	{
		// TODO if (options.orientation == "horizontal")...

		var x = 0;
		var y = 0;

		_.each(options.items, function(item, idx) {
			var text = item.name;
			var color = item.color;

			var rect = svg.append('rect')
				.attr('fill', color)
				.attr('opacity', 1.0)
				//.attr('stroke', options.borderColor)
				//.attr('stroke-width', options.borderWidth)
				.attr('x', x)
				.attr('y', y)
				.attr('width', options.itemWidth)
				.attr('height', options.itemHeight);

			var label = svg.append("text")
				.attr("fill", options.itemFontColor)
				.attr("text-anchor", "left")
				.attr("x", x + options.itemWidth + options.labelPadding)
				.attr("y", y + options.itemHeight)
				.text(text)
				//.attr("class", "item-label")
				//.attr("transform", rotation)
				.style("font-family", options.itemFont)
				.style("font-size", options.itemFontSize)
				.style("font-weight", options.itemFontWeight);

			y += options.itemHeight + options.itemPadding;
		});
	}

	this.init = init;
}
