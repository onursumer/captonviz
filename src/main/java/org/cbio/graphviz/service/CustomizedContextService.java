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
		RConnection c = new RConnection();

		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		// TODO send the sample list to R...
		String[] sampleList = samples.split("|");

		String input = this.getRppaDataResource().getFile().getAbsolutePath();

		// TODO call readRDS only once?
		c.voidEval("dataMatrix <- as.matrix(readRDS('" + input + "'));");
		c.voidEval("res <- cor(dataMatrix, method=\"pearson\");");
		c.voidEval("prots <- colnames(dataMatrix);");
		c.voidEval("res <- ggm.test.edges(res, verbose=FALSE, plot=FALSE);");

		String[] res = c.eval("cbind(prot1=prots[res[,2]], prot2=prots[res[,3]]);").asStrings();

		//c.close();

		return jsonSerializer.deepSerialize(res);
	}

	public boolean initData() throws IOException, RserveException
	{
		//File dataFile = this.getDataResource().getFile();
		String input = this.getRppaDataResource().getFile().getAbsolutePath();

		RConnection c = new RConnection();

		c.voidEval("dataMatrix <- as.matrix(readRDS(\"" + input + "\"));");

		return true;
	}
}
