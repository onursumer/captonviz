package org.cbio.graphviz.service;

import flexjson.JSON;
import flexjson.JSONSerializer;
import org.cbio.graphviz.model.*;
import org.cbio.graphviz.util.StudyFileUtil;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.core.io.Resource;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class CancerContextService
{
	// source directory for the edge list files
	private Resource edgeListResource;

	public Resource getEdgeListResource() {
		return edgeListResource;
	}

	public void setEdgeListResource(Resource edgeListResource) {
		this.edgeListResource = edgeListResource;
	}

	@Cacheable("cancerContextStudiesCache")
	public String listAvailableCancers() throws IOException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		File edgeListDir = this.getEdgeListResource().getFile();
		List<CancerStudy> cancerStudies = new ArrayList<>();
		Set<String> names = new HashSet<>();

		if (edgeListDir.isDirectory())
		{
			for (File edgeList: edgeListDir.listFiles())
			{
				String[] parts = edgeList.getName().split("_");

				if (parts.length > 1)
				{
					names.add(parts[1]);
				}
			}

			for (String name: names)
			{
				CancerStudy study = new CancerStudy();

				study.setStudyId(name);
				study.setStudyName(name);

				cancerStudies.add(study);
			}
		}

		return jsonSerializer.deepSerialize(cancerStudies);
	}

	@Cacheable("cancerContextMethodsCache")
	public String listAvailableMethods() throws IOException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		File edgeListDir = this.getEdgeListResource().getFile();
		List<Method> methods = new ArrayList<>();
		Set<String> methodNames = new HashSet<>();

		if (edgeListDir.isDirectory())
		{
			for (File edgeList: edgeListDir.listFiles())
			{
				String[] parts = edgeList.getName().split("_");
				String method = "";

				for (int i = 2; i < parts.length; i++)
				{
					if (i == parts.length - 1)
					{
						method += parts[i].substring(0, parts[i].indexOf("."));
					}
					else
					{
						method += parts[i];
						method += "_";
					}
				}

				methodNames.add(method);
			}

			for (String name: methodNames)
			{
				Method m = new Method();

				m.setMethodId(name);
				m.setMethodName(name);

				methods.add(m);
			}
		}

		return jsonSerializer.deepSerialize(methods);
	}

	@Cacheable("cancerContextDataCache")
	public String getStudyData(String study,
			String method,
			Integer size) throws IOException
	{
		JSONSerializer jsonSerializer = new JSONSerializer().exclude("*.class");

		String filename = this.getEdgeListResource().getFile().getAbsolutePath() +
		                  "/edgelist_" + study + "_" + method + ".txt";

		BufferedReader in = new BufferedReader(new FileReader(filename));

		// assuming the file is not empty & first line is the header
		String headerLine = in.readLine();

		List<CytoscapeJsEdge> edges = new ArrayList<>();
		List<CytoscapeJsNode> nodes = new ArrayList<>();
		CytoscapeJsGraph graph = new CytoscapeJsGraph();

		StudyFileUtil util = new StudyFileUtil(headerLine);
		String line;

		for (int i = 0;
		     i < size && (line = in.readLine()) != null;
		     i++)
		{
			edges.add(util.parseLine(line));
		}

		Map<Object, CytoscapeJsNode> map = new HashMap<>();

		for (CytoscapeJsEdge edge: edges)
		{
			Object prot1 = edge.getProperty(PropertyKey.PROT1);
			Object prot2 = edge.getProperty(PropertyKey.PROT2);

			Object gene1 = edge.getProperty(PropertyKey.PROT1);
			Object gene2 = edge.getProperty(PropertyKey.PROT2);

			if (map.get(prot1) == null)
			{
				CytoscapeJsNode node = new CytoscapeJsNode();

				node.setProperty(PropertyKey.ID, prot1);
				node.setProperty(PropertyKey.PROT, prot1);
				node.setProperty(PropertyKey.GENE, gene1);

				map.put(prot1, node);
				nodes.add(node);
			}

			if (map.get(prot2) == null)
			{
				CytoscapeJsNode node = new CytoscapeJsNode();

				node.setProperty(PropertyKey.ID, prot2);
				node.setProperty(PropertyKey.PROT, prot2);
				node.setProperty(PropertyKey.GENE, gene2);

				map.put(prot2, node);
				nodes.add(node);
			}
		}

		in.close();

		graph.setEdges(edges);
		graph.setNodes(nodes);

		return jsonSerializer.deepSerialize(graph);
	}
}
