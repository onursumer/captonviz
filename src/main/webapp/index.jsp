<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>

<%--
  ~ Copyright 2014 Memorial-Sloan Kettering Cancer Center.
  ~
  ~ This file is part of GraphViz.
  ~
  ~ GraphViz is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU Lesser General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ GraphViz is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU Lesser General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Lesser General Public License
  ~ along with GraphViz. If not, see <http://www.gnu.org/licenses/>.
  --%>

<%
    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    //String pcURL = (String) context.getBean("pathwayCommonsURLStr");
    //String pcVizURL = (String) context.getBean("pcVizURLStr");
%>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
  <head>
    <meta charset="utf-8">
    <title>CaptonViz</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- jQuery UI -->
    <link href="css/jquery-ui-1.10.3.custom.css" rel="stylesheet">

      <!-- Loading Bootstrap -->
    <link href="css/bootstrap.css" rel="stylesheet">

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet">
    <link rel="shortcut icon" href="images/favicon.ico">

    <link href="css/jquery.fancybox-1.3.4.css" rel="stylesheet">


    <!-- Loading cytoscape.js plugins -->
    <link href="css/jquery.cytoscape-panzoom.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">

    <!-- Loading CaptonViz; this should always be the last to call! -->
    <link href="css/pcviz.css" rel="stylesheet">
	<link href="css/graphviz.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements. All other JS at the end of file. -->
    <!--[if lt IE 9]>
      <script src="js/html5shiv.js"></script>
    <![endif]-->

  </head>
  <body>
	<!-- JS libraries -->
	<script src="js/lib/jquery-1.8.2.min.js"></script>
	<script src="js/lib/jquery-ui-1.10.3.custom.min.js"></script>
	<script src="js/lib/jquery.dropkick-1.0.0.js"></script>
	<script src="js/lib/custom_checkbox_and_radio.js"></script>
	<script src="js/lib/custom_radio.js"></script>
	<script src="js/lib/jquery.tagsinput.js"></script>
	<script src="js/lib/jquery.ui.touch-punch.min.js"></script>
	<script src="js/lib/bootstrap.min.js"></script>
	<script src="js/lib/jquery.placeholder.js"></script>
	<script src="js/lib/arbor.js"></script>
	<script src="js/lib/cytoscape.min.js"></script>
	<script src="js/lib/jquery.cytoscape-panzoom.min.js"></script>
	<script src="js/lib/application.js"></script>
	<script src="js/lib/underscore.js"></script>
	<script src="js/lib/backbone-min.js"></script>
	<script src="js/lib/jquery.fancybox-1.3.4.pack.js"></script>
	<script src="js/lib/jquery.easing-1.3.pack.js"></script>
	<script src="js/lib/jquery.expander.min.js"></script>
	<!--script src="js/lib/noty/jquery.noty.js"></script>
	<script src="js/lib/noty/layouts/bottomRight.js"></script>
	<script src="js/lib/noty/themes/noty.pcviz.theme.js"></script-->
	<script src="js/lib/store.js"></script>
	<script src="js/lib/jquery.scrollTo-1.4.3.1-min.js"></script>
	<script src="js/lib/js_cols.min.js"></script>

	<!--[if lt IE 8]>
	<script src="js/lib/icon-font-ie7.js"></script>
	<![endif]-->

	<script src="js/src/graphviz.js"></script>
	<script src="js/src/NetworkView.js"></script>
	<script src="js/src/ControlsView.js"></script>
	<script src="js/src/CustomControlsView.js"></script>
	<script src="js/src/MainView.js"></script>
	<script src="js/src/StudyModel.js"></script>

	<!-- PCViz and its components -->
	<script src="js/extensions/cytoscape.layout.pcviz.arbor.js"></script>
	<!--script src="js/pcviz.main.js"></script>
	<script src="js/components/pcviz.notification.js"></script>
	<script src="js/components/pcviz.home.js"></script>
	<script src="js/components/pcviz.validation.js"></script>
	<script src="js/components/pcviz.settings.js"></script>
	<script src="js/components/pcviz.sbgn.js"></script>
	<script src="js/components/pcviz.network.js"></script>
	<script src="js/components/pcviz.biogene.js"></script>
	<script src="js/components/pcviz.edgeinfo.js"></script>
	<script src="js/components/pcviz.cancer.js"></script>
	<script src="js/extensions/cytoscape.layout.pcviz.js"></script>
	<script src="js/extensions/cytoscape.layout.pcviz.arbor.js"></script>
	<script src="js/extensions/cytoscape.core.rank.js"></script>
	<script src="js/extensions/cytoscape.core.group.js"></script>
	<script src="js/extensions/cytoscape.renderer.canvas.sbgn-renderer.js"></script-->


	<script type="text/template" id="select_item_template">
		<option value="{{selectId}}">{{selectName}}</option>
	</script>

	<script type="text/template" id="network_controls_template">
		<h4 class="demo-panel-title">Cancer Study</h4>
		<select id="cancer-studies-box" class="span3" tabindex="1">
			{{studyOptions}}
		</select>

		<h4 class="demo-panel-title">Method</h4>
		<select id="methods-box" class="span3" tabindex="1">
			{{methodOptions}}
		</select>

		<h4 class="demo-panel-title">Number of edges <small>(<span id="number-of-edges-info"></span>)</small></h4>
		<table>
			<tr>
				<td class="minus-sign-container">
					<a href="#" id="decrease-button" class="slider-control"><i class="icon-minus"></i></a>
				</td>
				<td colspan='2' class="nodes-slider-container">
					<div id="slider-nodes" class="ui-slider"></div>
				</td>
				<td>
					<a href="#" id="increase-button" class="slider-control"><i class="icon-plus"></i></a>
				</td>
			</tr>
			<!--tr id="slider-help-row">
				<td></td>
				<td>
					<p class="help-slider-text palette palette-silver">
						Slide to change the number of edges
					</p>
				</td>
				<td>
					<img src="images/help-up-arrow.png" width="90">
				</td>
				<td></td>
			</tr-->
		</table>

		<h4 class="demo-panel-title">Color Edges By</h4>
		<select id="edge-color-box" class="span3" tabindex="1">
			<option value="edgesign">Edge Sign</option>
			<option value="inpc">In PC</option>
		</select>

		<h4 class="demo-panel-title">Label Nodes By</h4>
		<select id="node-label-box" class="span3" tabindex="1">
			<option value="prot">Prot Name</option>
			<option value="gene">Gene Name</option>
		</select>

		<a id="visualize-study" class="btn btn-primary btn-large btn-block" href="#">
			Visualize
		</a>
	</script>

	<script type="text/template" id="custom_controls_template">
		<h4 class="demo-panel-title">Samples</h4>
		<textarea id="sample-list-input" rows="3" class="span3" tabindex="1"></textarea>

		<h4 class="demo-panel-title">Method</h4>
		<select id="methods-box" class="span3" tabindex="1">
			{{methodOptions}}
		</select>

		<h4 class="demo-panel-title">Number of edges <small>(<span id="number-of-edges-info"></span>)</small></h4>
		<table>
			<tr>
				<td class="minus-sign-container">
					<a href="#" id="decrease-button" class="slider-control"><i class="icon-minus"></i></a>
				</td>
				<td colspan='2' class="nodes-slider-container">
					<div id="slider-nodes" class="ui-slider"></div>
				</td>
				<td>
					<a href="#" id="increase-button" class="slider-control"><i class="icon-plus"></i></a>
				</td>
			</tr>
		</table>

		<h4 class="demo-panel-title">Color Edges By</h4>
		<select id="edge-color-box" class="span3" tabindex="1">
			<option value="edgesign">Edge Sign</option>
			<option value="inpc">In PC</option>
		</select>

		<h4 class="demo-panel-title">Label Nodes By</h4>
		<select id="node-label-box" class="span3" tabindex="1">
			<option value="prot">Prot Name</option>
			<option value="gene">Gene Name</option>
		</select>

		<a id="visualize-study" class="btn btn-primary btn-large btn-block" href="#">
			Visualize
		</a>
	</script>

	<script type="text/template" id="main-view-template">
		<div class="row mainview">
			<div class="span8">  <!-- cytoscape view -->
				<!--div class="network-loading">
					<h4>Loading network...</h4>
					<img src="images/loading.gif" alt="loading network...">
				</div-->
				<div id="network-container">
					<div id="main-network-view"></div>
					<div class="row" id="control-panels">
						<div class="span6 offset1">
							<div class="btn-toolbar">
								<!--div class="btn-group network-controls">
									<a class="btn" id="download-network" href="#"><i class="icon-download-alt"></i> Download</a>
									<a class="btn" id="embed-network" href="#"><i class="icon-code"></i> Embed</a>
									<a class="btn" id="refresh-view" href="#"><i class="icon-refresh"></i> Reset</a>
									<a class="btn" id="full-screen-link" href="#"><i class="icon-resize-full"></i> Full screen</a>
								</div-->
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="span4">
				<ul class="nav nav-tabs" id="rightMenuControls">
					<li class="active"><a href="#graph-settings" id="menu-cancer-study" data-toggle="tab">
						<span class="fui-menu-16"></span> Default</a>
					</li>
					<li><a href="#custom-settings" id="menu-customized-network" data-toggle="tab">
						<span class="fui-settings-16"></span> Custom</a>
					</li>
				</ul>
			</div>
			<div class="span4">
				<div id="rightMenuTabs" class="tab-content">
					<div class="tab-pane fade active in" id="graph-settings">
						<!-- network controls view -->
					</div>
					<div class="tab-pane fade" id="custom-settings">
						<!-- customized controls view -->
					</div>
				</div>
			</div>
		</div>
	</script>

	<script type="text/template" id="error_template">
		<div class="error-message">{{errorMessage}}</div>
	</script>

	<div class="palette-silver">
		<div class="container">
			<div id="pcviz-headline" class="pcviz-headline">
				<h1>
					CaptonViz
					<small>Cancer Proteomic Network Visualization</small>
				</h1>
			</div>
		</div>
	</div>
	<div id="main_container" class="container"></div>

  </body>
</html>
