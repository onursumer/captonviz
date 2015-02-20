/**
 * Singleton class for data download and conversion tasks.
 */
var DataUtil = (function()
{
	/**
	 * Submits the download form.
	 * This will send a request to the server.
	 *
	 * @param servletName       name of the action servlet
	 * @param servletParams     params to send with the form submit
	 * @param form              jQuery selector for the download form
	 */
	function submitDownload(servletName, servletParams, form)
	{
		// remove all previous input fields (if any)
		$(form).find("input").remove();

		// add new input fields
		for (var name in servletParams)
		{
			var value = servletParams[name];
			$(form).append('<input type="hidden" name="' + name + '">');
			$(form).find('input[name="' + name + '"]').val(value);
		}

		// update target servlet for the action
		$(form).attr("action", servletName);
		// submit the form
		$(form).submit();
	}

	/**
	 * Sends a download request to the hidden frame dedicated to file download.
	 *
	 * This function is implemented as a workaround to prevent JSmol crash
	 * due to window.location change after a download request.
	 *
	 * @param servletName
	 * @param servletParams
	 */
	function requestDownload(servletName, servletParams)
	{
		initDownloadForm();
		submitDownload(servletName, servletParams, "#global_file_download_form");
	}

	/**
	 * This form is initialized only for IE
	 */
	function initDownloadForm()
	{
		var form = '<form id="global_file_download_form"' +
		           'style="display:inline-block"' +
		           'action="" method="post" target="_blank">' +
		           '</form>';

		// only initialize if the form doesn't exist
		if ($("#global_file_download_form").length === 0)
		{
			$(document.body).append(form);
		}
	}

	function convertToSif(cy)
	{
		var content = [];

		if (cy != null)
		{
			var line = [];

			// construct header line
			line.push("weight");
			line.push("inPC");
			line.push("edgesign");
			line.push("prot1");
			line.push("prot2");
			line.push("gene1");
			line.push("gene2");

			content.push(line.join("\t"));

			var edges = cy.elements("edge:visible");

			_.each(edges, function(edge, i) {
				var data = edge.data();
				line = [];

				// construct data line
				line.push(data["weight"]);
				line.push(data["inpc"]);
				line.push(data["edgesign"]);
				line.push(data["prot1"]);
				line.push(data["prot2"]);
				line.push(data["gene1"]);
				line.push(data["gene2"]);

				content.push(line.join("\t"));
			});
		}

		return content.join("\n");
	}

	/**
	 * Posts (uploads) file data thru ajax query.
	 *
	 * @param url       target (servlet) URL
	 * @param data      file (form) data
	 * @param success   callback to be invoked on success
	 * @param error     callback to be invoked on error
	 */
	function postFile(url, data, success, error)
	{
		$.ajax({
			url: url,
			type: 'POST',
			success: success,
			error: error,
			data: data,
			dataType: "json",
			//Options to tell jQuery not to process data or worry about content-type.
			cache: false,
			contentType: false,
			processData: false
		});
	}

	return {
		requestDownload: requestDownload,
		convertToSif: convertToSif,
		postFile: postFile
	};
})();