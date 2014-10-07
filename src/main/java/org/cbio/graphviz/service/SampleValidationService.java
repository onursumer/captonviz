package org.cbio.graphviz.service;

import flexjson.JSONSerializer;
import org.springframework.core.io.Resource;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

/**
 * Service to validate input sample set.
 *
 * @author Selcuk Onur Sumer
 */
public class SampleValidationService
{
	// source file for the pancan data
	private Resource dataResource;

	public Resource getPancanDataResource() {
		return dataResource;
	}

	public void setPancanDataResource(Resource pancanDataResource) {
		this.dataResource = pancanDataResource;
	}

	protected Set<String> pancanSamples = null;


	protected List<String> getValidSamples(String[] samples) throws IOException
	{
		List<String> list = new ArrayList<String>();

		Set<String> validSamples = new HashSet<String>();
		Set<String> pancanSamples = this.getPancanSamples();

		for (String sample: samples)
		{
			if (pancanSamples.contains(sample))
			{
				validSamples.add(sample);
			}
		}

		list.addAll(validSamples);
		return list;
	}

	protected List<String> getInvalidSamples(String[] samples) throws IOException
	{
		List<String> list = new ArrayList<String>();

		Set<String> invalidSamples = new HashSet<String>();
		Set<String> pancanSamples = this.getPancanSamples();

		for (String sample: samples)
		{
			if (!pancanSamples.contains(sample))
			{
				invalidSamples.add(sample);
			}
		}

		list.addAll(invalidSamples);
		return list;
	}

	public String validateSamples(String samples) throws IOException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		String[] sampleList = samples.trim().split("\\|");
		List<String> invalidSamples = this.getInvalidSamples(sampleList);
		List<String> validSamples = this.getValidSamples(sampleList);

		HashMap<String, List<String>> map = new HashMap<>();

		map.put("invalidSamples", invalidSamples);
		map.put("validSamples", validSamples);

		return jsonSerializer.deepSerialize(map);
	}

	protected  Set<String> getPancanSamples() throws IOException
	{
		if (this.pancanSamples == null)
		{
			Set<String> samples = new HashSet<>();

			File input = this.getPancanDataResource().getFile();
			BufferedReader reader = new BufferedReader(new FileReader(input));

			String line;

			// read the pancan data resource and create a set of samples
			while ((line = reader.readLine()) != null)
			{
				// skip empty lines
				if (line.length() == 0)
				{
					continue;
				}

				String parts[] = line.split("\t");
				// assuming parts[0] is the case id...
				samples.add(parts[0].trim());
			}

			this.pancanSamples = samples;
		}

		return this.pancanSamples;
	}
}
