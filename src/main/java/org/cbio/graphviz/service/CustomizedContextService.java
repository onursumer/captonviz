package org.cbio.graphviz.service;

import flexjson.JSONSerializer;
import org.cbio.graphviz.model.CytoscapeJsEdge;
import org.cbio.graphviz.model.CytoscapeJsGraph;
import org.cbio.graphviz.model.CytoscapeJsNode;
import org.cbio.graphviz.model.PropertyKey;
import org.cbio.graphviz.util.StudyFileUtil;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Service to retrieve custom study data as a graph.
 *
 * @author Selcuk Onur Sumer
 */
public class CustomizedContextService extends CancerContextService
{
	// source file for the pancan data
	private Resource dataResource;

	public Resource getDataResource() {
		return dataResource;
	}

	public void setDataResource(Resource dataResource) {
		this.dataResource = dataResource;
	}

	// source file for the rppa data
	private Resource rppaDataResource;

	public Resource getRppaDataResource()
	{
		return rppaDataResource;
	}

	public void setRppaDataResource(Resource rppaDataResource)
	{
		this.rppaDataResource = rppaDataResource;
	}

	private RConnection conn = null;

	public String getStudyData(String method,
			Integer size,
			String samples)
		throws REXPMismatchException, RserveException, IOException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		CytoscapeJsGraph graph = new CytoscapeJsGraph();
		List<CytoscapeJsEdge> edges = this.getEdgeList(method, size, samples);
		List<CytoscapeJsNode> nodes = this.getNodeList(edges);

		graph.setEdges(edges);
		graph.setNodes(nodes);

		return jsonSerializer.deepSerialize(graph);
	}

	protected List<CytoscapeJsEdge> getEdgeList(String method,
			Integer size,
			String samples)
		throws REXPMismatchException, RserveException, IOException
	{
		RConnection c = this.getRConn();

		// generate a list of samples from the user input
		c.voidEval("samples <- c(" + this.generateSampleList(samples) + ");");
		// filter the data matrix for the provided sample list
		c.voidEval("mx <- match(samples, rownames(dataMatrix));");
		c.voidEval("mx <- mx[!is.na(mx)];");
		c.voidEval("filtered <- dataMatrix[mx,];");
		// calculate correlation
		c.voidEval("mat <- cor(filtered, method='pearson');");
		c.voidEval("res <- ggm.test.edges(mat, verbose=FALSE, plot=FALSE);");
		c.voidEval("prots <- colnames(dataMatrix);");

		// TODO create an edge list to visualize...
		//String[] res = c.eval("cbind(prot1=prots[res[,2]], prot2=prots[res[,3]]);").asStrings();
		String[] sources = c.eval("cbind(prot1=prots[res[,2]]);").asStrings();
		String[] targets = c.eval("cbind(prot1=prots[res[,3]]);").asStrings();

		List<CytoscapeJsEdge> edges = new ArrayList<>();

		for (int i = 0;
		     i < size && i < sources.length && i < targets.length;
		     i++)
		{
			// TODO we only have prot values here...
			CytoscapeJsEdge edge = StudyFileUtil.defaultEdge();

			edge.setProperty(PropertyKey.SOURCE, sources[i]);
			edge.setProperty(PropertyKey.TARGET, targets[i]);

			edge.setProperty(PropertyKey.PROT1, sources[i]);
			edge.setProperty(PropertyKey.PROT2, targets[i]);

			edges.add(edge);
		}

		return edges;
	}

	/**
	 * Returns the existing r connection. If connection is not init yet,
	 * initializes a new R connection with default libraries and data.
	 *
	 * @return  RConnection object
	 * @throws IOException
	 * @throws RserveException
	 */
	protected RConnection getRConn() throws IOException, RserveException
	{
		// init R connection if not init yet
		if (this.conn == null)
		{
			// init connection
			RConnection c = new RConnection();
			this.conn = c;

			// load required lib
			c.voidEval("library(parcor);");

			// load data file
			String input = this.getRppaDataResource().getFile().getAbsolutePath();
			c.voidEval("dataMatrix <- as.matrix(readRDS('" + input + "'));");
		}

		return this.conn;
	}

	protected String generateSampleList(String samples)
	{
		StringBuilder sb = new StringBuilder();
		String[] sampleList = samples.trim().split("\\|");

		for (int i = 0; i < sampleList.length; i++)
		{
			sb.append("'");
			sb.append(sampleList[i]);
			sb.append("'");

			if (i < sampleList.length - 1)
			{
				sb.append(",");
			}
		}

		return sb.toString();
	}
}
