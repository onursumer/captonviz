package org.cbio.graphviz.service;

import flexjson.JSONSerializer;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;
import org.springframework.core.io.Resource;

import java.io.File;
import java.io.IOException;


public class CustomizedContextService
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

	public String sendRequest(String request) throws RserveException, REXPMismatchException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		RConnection c = new RConnection();

		// TODO need to return an array of strings
		double d[] = c.eval(request).asDoubles();

		return jsonSerializer.deepSerialize(d);
	}

	public String getStudyData(String study,
			String method,
			Integer size,
			String samples)
		throws REXPMismatchException, RserveException, IOException
	{
		RConnection c = this.getRConn();

		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

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
		String[] res = c.eval("cbind(prot1=prots[res[,2]], prot2=prots[res[,3]]);").asStrings();

		return jsonSerializer.deepSerialize(res);
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
		String[] sampleList = samples.split("\\|");

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
