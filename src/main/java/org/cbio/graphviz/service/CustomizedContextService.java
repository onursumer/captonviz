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

	public Resource getPancanDataResource() {
		return dataResource;
	}

	public void setPancanDataResource(Resource pancanDataResource) {
		this.dataResource = pancanDataResource;
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

	// source file for the PC data
	private Resource pcDataResource;

	public Resource getPcDataResource()
	{
		return pcDataResource;
	}

	public void setPcDataResource(Resource pcDataResource)
	{
		this.pcDataResource = pcDataResource;
	}

	// source file for the custom R functions
	private Resource rFunctionResource;

	public Resource getrFunctionResource()
	{
		return rFunctionResource;
	}

	public void setrFunctionResource(Resource rFunctionResource)
	{
		this.rFunctionResource = rFunctionResource;
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

		if (method.equalsIgnoreCase("spearmanCor"))
		{
			c.voidEval("res <- cor(filtered, method='spearman');");
			c.voidEval("edges <- ggm.test.edges(res, verbose=FALSE, plot=FALSE)[,1:3];");
		}
		else if (method.equalsIgnoreCase("genenet"))
		{
			c.voidEval("res <- ggm.estimate.pcor(filtered);");
			c.voidEval("edges <- ggm.test.edges(res, verbose=FALSE, plot=FALSE)[,1:3];");
		}
		else if (method.equalsIgnoreCase("ridgenet"))
		{
			c.voidEval("res <- ridge.net.vLambda(filtered, countLambda=250, k=5);");
			c.voidEval("edges <- ggm.test.edges(res$pcor, verbose=FALSE, plot=FALSE)[,1:3];");
		}
		else if (method.equalsIgnoreCase("lassonet"))
		{
			c.voidEval("res <- lasso.net.vLambda(filtered, lambda=0.1);");
			c.voidEval("edges <- ggm.test.edges(res$pcor, verbose=FALSE, plot=FALSE)[,1:3];");
		}
		else if (method.equalsIgnoreCase("aracne_m"))
		{
			c.voidEval("mi <- knnmi.all(t(filtered), k=5);");
			c.voidEval("res <- aracne.m(mi, tau=0.3);");
			c.voidEval("edges <- getEdges(res)[,c(3,1,2)];");
		}
		else
		{
			// TODO invalid/unknown method
		}

		c.voidEval("prots <- colnames(dataMatrix);");

		//String[] res = c.eval("cbind(prot1=prots[res[,2]], prot2=prots[res[,3]]);").asStrings();
		String[] sources = c.eval("prots[edges[,2]];").asStrings();
		String[] targets = c.eval("prots[edges[,3]];").asStrings();

		// Ensure alphabetical order in computational predictions
		c.voidEval("ce <- cbind(prots[edges[,2]],prots[edges[,3]]);");
		c.voidEval("ind <- which(!(ce[,1] < ce[,2]));");
		c.voidEval("ce[ind,] <- ce[ind,c(2,1)];");
		// Combine the edges with a dot
		c.voidEval("pcdot <- paste(pcData[,1],pcData[,2],sep='.');");
		c.voidEval("cedot <- paste(ce[,1],ce[,2],sep='.');");
		c.voidEval("is.match <- match(cedot,pcdot);");
		c.voidEval("is.match[!is.na(is.match)] = 1;");
		c.voidEval("is.match[is.na(is.match)] = 0;");

		int[] inPc = c.eval("is.match;").asIntegers();

		// create an edge list to visualize
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

			edge.setProperty(PropertyKey.INPC, inPc[i]);

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

			// load required libraries
			c.voidEval("library(parcor);");
			c.voidEval("library(parmigene);");

			// load required source files
			String functions = this.getrFunctionResource().getFile().getAbsolutePath();

			c.voidEval("source('" + functions + "');");

			// load data files
			String rppaData = this.getRppaDataResource().getFile().getAbsolutePath();
			String pcData = this.getPcDataResource().getFile().getAbsolutePath();

			c.voidEval("dataMatrix <- as.matrix(readRDS('" + rppaData + "'));");
			c.voidEval("pcData <- readRDS('" + pcData + "');");
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
