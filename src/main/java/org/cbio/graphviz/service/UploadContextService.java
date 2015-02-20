package org.cbio.graphviz.service;

import org.cbio.graphviz.util.CustomFileParseUtil;
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

		this.reloadData = true;
		return super.getStudyData(method, size, this.extractSamples(outputDir));
	}

	/**
	 * Extracts list of samples from the file uploaded by user.
	 *
	 * @param outputDir temporary output dir to store user files
	 * @return          sample list as pipe ('|') delimited string
	 * @throws IOException
	 */
	protected String extractSamples(String outputDir) throws IOException
	{
		BufferedReader reader = new BufferedReader(
				new FileReader(outputDir + "/" + OUTPUT_FILENAME));

		String line = reader.readLine();
		StringBuilder sb = new StringBuilder();

		// assuming that the first line is a header line
		CustomFileParseUtil parser = new CustomFileParseUtil(line);

		while ((line = reader.readLine()) != null)
		{
			sb.append(parser.getValue(line, CustomFileParseUtil.SAMPLE_ID));
			sb.append("|");
		}

		// delete the last "|"
		sb.deleteCharAt(sb.length() - 1);

		reader.close();

		return sb.toString();
	}

	/**
	 * Reads data matrix user input.
	 *
	 * @param c RConnection
	 * @throws IOException
	 * @throws RserveException
	 */
	@Override
	protected void readDataMatrix(RConnection c) throws IOException, RserveException
	{
		String dataFile = this.getOutputDirResource().getFile().getAbsolutePath() +
		                  "/" + OUTPUT_FILENAME;

		c.voidEval("uploadedData <- read.csv('" + dataFile + "', header=TRUE, sep='\t');");
		c.voidEval("dataMatrix <- uploadedData[,-1];");
		c.voidEval("rownames(dataMatrix) <- uploadedData[,1];");
	}
}
