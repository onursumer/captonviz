package org.cbio.graphviz.service;

import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;
import org.springframework.core.io.Resource;

import java.io.*;

/**
 * Service to retrieve user uploaded data as a graph.
 *
 * @author Selcuk Onur Sumer
 */
public class UploadContextService extends CustomizedContextService
{
	public static String OUTPUT_FILENAME = "captonviz_upload.txt";

	// source directory for temporary file output
	private Resource outputDirResource;

	public Resource getOutputDirResource()
	{
		return outputDirResource;
	}

	public void setOutputDirResource(Resource outputDirResource)
	{
		this.outputDirResource = outputDirResource;
	}

	public String getStudyData(String method,
			Integer size,
			InputStream is) throws REXPMismatchException, RserveException, IOException
	{
		String outputDir = this.getOutputDirResource().getFile().getAbsolutePath();

		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
		BufferedWriter writer = new BufferedWriter(new FileWriter(outputDir + "/" + OUTPUT_FILENAME));
		String line = null;

		while ((line = reader.readLine()) != null)
		{
			writer.write(line);
			writer.newLine();
		}

		reader.close();
		writer.close();

		// TODO get actual list from input file!
		String samples = "TCGA-B6-A0I6|TCGA-BH-A0C1|TCGA-AR-A0U2|TCGA-A2-A0YF|TCGA-BH-A18J";

		this.reloadData = true;
		return super.getStudyData(method, size, samples);
	}

	protected void readDataMatrix(RConnection c) throws IOException, RserveException
	{
		String dataFile = this.getOutputDirResource().getFile().getAbsolutePath() +
		                  "/" + OUTPUT_FILENAME;

		c.voidEval("uploadedData <- read.csv('" + dataFile + "', header=TRUE, sep='\t');");
		c.voidEval("dataMatrix <- uploadedData[,-1];");
		c.voidEval("rownames(dataMatrix) <- uploadedData[,1];");
	}
}
