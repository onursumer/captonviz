/**
 * Singleton class for generic view utility tasks.
 */
var ViewUtil = (function()
{
	// displays an error message to the user as a NotyView
	function displayErrorMessage(message)
	{
		$("#main-network-view").empty();
		self.networkView = null;

		var notyView = new NotyView({
			template: "#noty-error-msg-template",
			error: true,
			model: {
				errorMsg: message
			}
		});

		notyView.render();
	}

	// displays a warning message to the user as a NotyView
	function displayWarningMessage(message)
	{
		var notyView = new NotyView({
			template: "#noty-error-msg-template",
			warning: true,
			model: {
				errorMsg: message
			}
		});

		notyView.render();
	}

	/**
	 * Initializes the network view with loader image and a delayed
	 * info message (in case of long waiting).
	 *
	 * @param delay delay in miliseconds to show additional info while loading
	 */
	function initNetworkView(delay)
	{
		var timeout = delay || 2000;
		var mainNetworkView = $("#main-network-view");

		// display loader message before actually loading the data
		// it will be replaced by the network view once data is fetched
		mainNetworkView.html(_.template(
			$("#loader_template").html(), {}));

		// additional info will appear after certain amount of time
		setTimeout(function() {
			mainNetworkView.find(".too-slow-message").slideDown();
		}, timeout);
	}

	return {
		displayErrorMessage: displayErrorMessage,
		displayWarningMessage: displayWarningMessage,
		initNetworkView: initNetworkView
	};
})();
