package org.cbio.graphviz.service;

import flexjson.JSONSerializer;
import org.springframework.core.io.Resource;

import java.util.*;

/**
 * Service to retrieve custom study data as a graph.
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


	protected List<String> getValidSamples(String[] samples)
	{
		List<String> list = new ArrayList<String>();

		Set<String> pancanSamples = this.getPancanSamples();

		for (String sample: samples)
		{
			if (pancanSamples.contains(sample))
			{
				list.add(sample);
			}
		}

		return list;
	}

	protected List<String> getInvalidSamples(String[] samples)
	{
		List<String> list = new ArrayList<String>();

		Set<String> pancanSamples = this.getPancanSamples();

		for (String sample: samples)
		{
			if (!pancanSamples.contains(sample))
			{
				list.add(sample);
			}
		}

		return list;
	}

	public String validateSamples(String samples)
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

	protected  Set<String> getPancanSamples()
	{
		if (this.pancanSamples == null)
		{
			Set<String> samples = new HashSet<>();

			// TODO read the pancan data resource and create a set of samples...

			this.pancanSamples = samples;
		}

		return this.pancanSamples;
	}
}
