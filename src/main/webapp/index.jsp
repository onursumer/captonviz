<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>

<%--
  ~ Copyright 2014 Memorial-Sloan Kettering Cancer Center.
  ~
  ~ This file is part of ProtNet.
  ~
  ~ ProtNet is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU Lesser General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ ProtNet is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU Lesser General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Lesser General Public License
  ~ along with ProtNet. If not, see <http://www.gnu.org/licenses/>.
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
    <title>ProtNet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- jQuery UI -->
    <link href="css/jquery-ui-1.10.3.custom.css" rel="stylesheet">

      <!-- Loading Bootstrap -->
    <link href="css/bootstrap.css" rel="stylesheet">

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet">
    <!--link rel="shortcut icon" href="images/favicon.ico"-->

    <link href="css/jquery.fancybox-1.3.4.css" rel="stylesheet">

    <!-- Loading cytoscape.js plugins -->
    <link href="css/jquery.cytoscape-panzoom.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">

    <!-- Loading project specific css; this should always be the last to call! -->
    <link href="css/pcviz.css" rel="stylesheet">
	<link href="css/graphviz.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements. All other JS at the end of file. -->
    <!--[if lt IE 9]>
      <script src="js/lib/html5shiv.js"></script>
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
	<script src="js/lib/noty/jquery.noty.js"></script>
	<script src="js/lib/noty/layouts/bottomRight.js"></script>
	<script src="js/lib/noty/themes/noty.pcviz.theme.js"></script>
	<script src="js/lib/store.js"></script>
	<script src="js/lib/jquery.scrollTo-1.4.3.1-min.js"></script>
	<script src="js/lib/js_cols.min.js"></script>
	<script src="js/lib/d3.min.js"></script>

	<!--[if lt IE 8]>
	<script src="js/lib/icon-font-ie7.js"></script>
	<![endif]-->

	<script src="js/src/graphviz.js"></script>
	<script src="js/src/NetworkView.js"></script>
	<script src="js/src/ControlsView.js"></script>
	<script src="js/src/CustomControlsView.js"></script>
	<script src="js/src/UploadControlsView.js"></script>
	<script src="js/src/HelpView.js"></script>
	<script src="js/src/MainView.js"></script>
	<script src="js/src/StudyModel.js"></script>
	<script src="js/src/Legend.js"></script>
	<script src="js/src/NotyView.js"></script>
	<script src="js/src/ViewUtil.js"></script>
	<script src="js/src/DataUtil.js"></script>

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
			<option value="edgesign">Edge sign</option>
			<option value="inpc">In Pathway Commons?</option>
		</select>

		<h4 class="demo-panel-title">Label Nodes By</h4>
		<select id="node-label-box" class="span3" tabindex="1">
			<option value="prot">Protein symbol</option>
			<option value="gene">Gene symbol</option>
		</select>

		<a id="visualize-study" class="btn btn-primary btn-large btn-block" href="#">
			Visualize
		</a>
	</script>

	<script type="text/template" id="custom_controls_template">
		<h4 class="demo-panel-title">TCGA sample IDs</h4>
		<textarea id="sample-list-input" rows="3" class="span3" tabindex="1"></textarea>
		<h4 class="demo-panel-title">Method</h4>
		<select id="custom-methods-box" class="span3" tabindex="1">
			{{methodOptions}}
		</select>

		<h4 class="demo-panel-title">Number of edges
			<small>(<span id="custom-number-of-edges-info"></span>)</small></h4>
		<table>
			<tr>
				<td class="minus-sign-container">
					<a href="#" id="custom-decrease-button" class="slider-control"><i class="icon-minus"></i></a>
				</td>
				<td colspan='2' class="nodes-slider-container">
					<div id="slider-nodes" class="ui-slider"></div>
				</td>
				<td>
					<a href="#" id="custom-increase-button" class="slider-control"><i class="icon-plus"></i></a>
				</td>
			</tr>
		</table>

		<h4 class="demo-panel-title">Color Edges By</h4>
		<select id="custom-edge-color-box" class="span3" tabindex="1">
			<option value="edgesign">Edge sign</option>
			<option value="inpc">In Pathway Commons?</option>
		</select>

		<h4 class="demo-panel-title">Label Nodes By</h4>
		<select id="custom-node-label-box" class="span3" tabindex="1">
			<option value="prot">Protein symbol</option>
			<option value="gene">Gene symbol</option>
		</select>

		<a id="visualize-study" class="btn btn-primary btn-large btn-block" href="#">
			Visualize
		</a>
	</script>

	<script type="text/template" id="upload_controls_template">
		<h4 class="demo-panel-title">Upload Your Own Data</h4>
		<div style="display:none">
			<div id="fancybox-inline-data">
				You can upload your own data matrix files as tab delimited plain text files
				in <b>txt</b>, <b>tsv</b> or <b>csv</b> format.<br>
				<br>
				Example data matrix file format:<br><br>
				<table>
					<tr class="header-row"><td>SampleID</td><td>Akt</td><td>Akt_pS473</td><td>Akt_pT308</td><td>AMPK_alpha</td><td>AMPK_pT172</td></tr>
					<tr><td>TCGA-B6-A0I6</td><td>0.154298</td><td>-0.35781</td><td>-0.447332</td><td>-0.574477</td><td>-0.394586</td></tr>
					<tr><td>TCGA-BH-A0C1</td><td>-0.827756</td><td>-1.038089</td><td>0.967767</td><td>-0.01783</td><td>-0.16318</td></tr>
					<tr><td>TCGA-AR-A0U2</td><td>-0.799884</td><td>-0.617498</td><td>-0.068958</td><td>-0.66862</td><td>-1.990531</td></tr>
					<tr><td>TCGA-A2-A0YF</td><td>-0.974146</td><td>-0.356275</td><td>0.233013</td><td>-0.462506</td><td>-0.966453</td></tr>
					<tr><td>TCGA-BH-A18J</td><td>0.186297</td><td>-0.482782</td><td>0.354039</td><td>0.116103</td><td>-0.391372</td></tr>
				</table>
			</div>
		</div>
		<form class="form-horizontal data-file-form"
		      enctype="multipart/form-data"
		      method="post">
			<span class="file-input btn btn-primary btn-file">
				Select Data Matrix File <input class="custom-data" name="data_file" type="file">
			</span>
			<a class="upload-file-help btn btn-primary btn-mini" href="#fancybox-inline-data">
				<i class="icon-question-sign"></i>
			</a>
			<div class="selected-file-info"></div>
		</form>
		<h4 class="demo-panel-title">Method</h4>
		<select id="upload-methods-box" class="span3" tabindex="1">
			{{methodOptions}}
		</select>

		<h4 class="demo-panel-title">Number of edges
			<small>(<span id="upload-number-of-edges-info"></span>)</small></h4>
		<table>
			<tr>
				<td class="minus-sign-container">
					<a href="#" id="upload-decrease-button" class="slider-control"><i class="icon-minus"></i></a>
				</td>
				<td colspan='2' class="nodes-slider-container">
					<div id="slider-nodes" class="ui-slider"></div>
				</td>
				<td>
					<a href="#" id="upload-increase-button" class="slider-control"><i class="icon-plus"></i></a>
				</td>
			</tr>
		</table>

		<!--h4 class="demo-panel-title">Color Edges By</h4>
		<select id="upload-edge-color-box" class="span3" tabindex="1">
			<option value="edgesign">Edge sign</option>
			<option value="inpc">In Pathway Commons?</option>
		</select-->

		<!--h4 class="demo-panel-title">Label Nodes By</h4>
		<select id="upload-node-label-box" class="span3" tabindex="1">
			<option value="prot">Protein symbol</option>
			<option value="gene">Gene symbol</option>
		</select-->

		<a id="visualize-study" class="btn btn-primary btn-large btn-block" href="#">
			Visualize
		</a>
	</script>

	<script type="text/template" id="main-view-template">
		<div class="row mainview">
			<div class="span8">  <!-- cytoscape view -->
				<div id="network-container">
					<div id="main-network-view"></div>
					<div class="span8 edge-legend" id="edge-legend">
						<table>
							<tr>
								<td><div class="legend-rect legend-edge-sign-pos"></div>Edge sign (positive)</td>
								<td><div class="legend-rect legend-edge-sign-neg"></div>Edge sign (negative)</td>
							</tr>
							<tr>
								<td><div class="legend-rect legend-in-pc-true"></div>In Pathway Commons</td>
								<td><div class="legend-rect legend-in-pc-false"></div>Not In Pathway Commons</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div class="span4">
				<ul class="nav nav-tabs" id="rightMenuControls">
					<li class="active"><a href="#graph-settings" id="menu-cancer-study" data-toggle="tab">
						<span class="fui-menu-16"></span> Default</a>
					</li>
					<li><a href="#custom-settings" id="menu-customized-network" data-toggle="tab">
						<span class="fui-menu-16"></span> Custom</a>
					</li>
					<li><a href="#upload-settings" id="menu-upload-data" data-toggle="tab">
						<span class="fui-menu-16"></span> Upload</a>
					</li>
					<!--li><a href="#vis-help" id="menu-help" data-toggle="tab">
						<span class="fui-menu-16"></span> Help</a>
					</li-->
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
					<div class="tab-pane fade" id="upload-settings">
						<!-- upload controls view -->
					</div>
					<!--div class="tab-pane fade" id="vis-help"-->
						<!-- help text, legend, etc -->
					<!--/div-->
				</div>
			</div>
			<div class="row" id="control-panels">
				<div>
					<div class="btn-toolbar">
						<div class="btn-group network-controls">
							<a class="btn" id="download-network" href="#"><i class="icon-download-alt"></i> Download</a>
							<!--a class="btn" id="refresh-view" href="#"><i class="icon-refresh"></i> Refresh</a-->
							<!--a class="btn" id="embed-network" href="#"><i class="icon-code"></i> Embed</a-->
							<a class="btn" id="full-screen-link" href="#"><i class="icon-resize-full"></i>
								<span class="full-screen-button-text">Full Size</span>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</script>

	<script type="text/template" id="noty-network-loaded-template">
		Found <b>{{numberOfSamples}} samples</b> in RPPA data.
	</script>

	<script type="text/template" id="noty-invalid-sample-template">
		<b>{{numberOfSamples}} sample(s)</b> cannot be found in RPPA data:<br>
		{{sampleList}}
	</script>

	<script type="text/template" id="noty-error-msg-template">
		{{errorMsg}}
	</script>

	<script type="text/template" id="error_template">
		<div class="error-message">{{errorMessage}}</div>
	</script>

	<script type="text/template" id="loader_template">
		<div class="network-loading">
			<h4>Loading network...</h4>
			<img src="images/loading.gif" alt="loading network...">
			<div class="help-text palette palette-silver too-slow-message hide">
				<h5>Taking too long?</h5><br>
				Some methods like Ridgenet and Lassonet require more time to calculate the correlations.
				Therefore, it sometimes takes too long to load the network.
				<br><br>
			</div>
		</div>
	</script>

	<script type="text/template" id="help_template">
		<h4>Edge Legend</h4>
		<div class="legend"></div>
	</script>

	<div class="palette-silver">
		<div class="container">
			<div id="pcviz-headline" class="pcviz-headline">
				<h1>
					ProtNet
					<small>Cancer Proteomic Network Visualization</small>
				</h1>
			</div>
		</div>
	</div>
	<div id="main_container" class="container"></div>
	<div id="main_footer">
		<footer>
			<div class="container">
				<div class="row">
					<div class="span8">
						<h3 class="footer-title">About</h3>

						<p>
							ProtNet is an open-source web-based network visualization tool for
							Cancer Proteomic Networks.
						</p>

						<p>
							It allows interactive exploration of the cancer proteomic networks where users can:
						<ul>
							<li>explore the predefined cancer proteomic networks</li>
							<li>visualize custom networks by entering specific TCGA sample IDs or
								by uploading data matrix files</li>
							<li>reduce the size of the network by setting the number of desired edges</li>
							<li>download networks in SIF format for further analysis</li>
						</ul>

						<p>ProtNet is built and maintained by
							<a href="http://cbio.mskcc.org">Memorial Sloan-Kettering Cancer Center</a>.
						</p>
					</div>

					<div class="span4">
						<div class="footer-banner">
							<h3 class="footer-title">More</h3>
							<ul>
								<li>
									<a href="https://code.google.com/p/captonviz/wiki/Tutorial">Tutorials / Help</a>
								</li>
								<li>
									<a href="http://www.pathwaycommons.org/pcviz/">PCViz</a>
								</li>
								<li>
									<a href="http://www.cbioportal.org">cBioPortal</a>
								</li>
								<li>
									<a href="http://cytoscape.github.io/cytoscape.js/">cytoscape.js</a>
								</li>
								<li>
									<a href="http://code.google.com/p/captonviz/">Code</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</footer>
	</div>

  </body>
</html>
