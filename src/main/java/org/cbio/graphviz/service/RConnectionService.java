package org.cbio.graphviz.service;

import flexjson.JSONSerializer;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;


public class RConnectionService
{
	public String sendRequest(String[] request) throws RserveException, REXPMismatchException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		RConnection c = new RConnection();

		// TODO this is a test method call, replace with actual method
		double d[] = c.eval("rnorm(10)").asDoubles();

		return jsonSerializer.deepSerialize(d);
	}
}
