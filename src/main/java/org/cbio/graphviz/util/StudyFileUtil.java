package org.cbio.graphviz.util;

import org.cbio.graphviz.model.CytoscapeJsEdge;
import org.cbio.graphviz.model.PropertyKey;

import java.util.HashMap;

/**
 * Utility Class for Parsing Edge List Files.
 *
 * This utility class handles variable columns and column orderings.
 *
 * @author Selcuk Onur Sumer
 */
public class StudyFileUtil
{
	public static final String WEIGHT = "weight";
	public static final String IN_PC = "inPC";
	public static final String EDGE_SIGN = "edgesign";
	public static final String PROT1 = "prot1";
	public static final String PROT2 = "prot2";
	public static final String GENE1 = "gene1";
	public static final String GENE2 = "gene2";

	// mapping for all column names (both standard and custom columns)
	private HashMap<String, Integer> columnIndexMap;

	/**
	 * Constructor.
	 *
	 * @param headerLine    Header Line.
	 */
	public StudyFileUtil(String headerLine)
	{
		// init column index map
		this.columnIndexMap = new HashMap<String, Integer>();

		// split header names
		String parts[] = headerLine.split("\t");

		// update header count
		//this.headerCount = parts.length;

		// find required header indices
		for (int i=0; i<parts.length; i++)
		{
			String header = parts[i];

			// put the index to the map
			this.columnIndexMap.put(header.toLowerCase(), i);
		}
	}

	public CytoscapeJsEdge parseLine(String line)
	{
		String parts[] = line.split("\t", -1);

		CytoscapeJsEdge edge = new CytoscapeJsEdge();

		//record.setHugoGeneSymbol(
		// TabDelimitedFileUtil.getPartString(
		// this.getColumnIndex(MafUtil.HUGO_SYMBOL),
		// parts));

		edge.setProperty(PropertyKey.WEIGHT,TabDelimitedFileUtil.getPartFloat(this.getColumnIndex(WEIGHT), parts));
		edge.setProperty(PropertyKey.INPC, TabDelimitedFileUtil.getPartInt(this.getColumnIndex(IN_PC), parts));
		edge.setProperty(PropertyKey.EDGESIGN, TabDelimitedFileUtil.getPartInt(this.getColumnIndex(EDGE_SIGN), parts));
		edge.setProperty(PropertyKey.PROT1, TabDelimitedFileUtil.getPartString(this.getColumnIndex(PROT1), parts));
		edge.setProperty(PropertyKey.PROT2, TabDelimitedFileUtil.getPartString(this.getColumnIndex(PROT2), parts));
		edge.setProperty(PropertyKey.GENE1, TabDelimitedFileUtil.getPartString(this.getColumnIndex(GENE1), parts));
		edge.setProperty(PropertyKey.GENE2, TabDelimitedFileUtil.getPartString(this.getColumnIndex(GENE2), parts));

		edge.setProperty(PropertyKey.SOURCE, TabDelimitedFileUtil.getPartString(this.getColumnIndex(PROT1), parts));
		edge.setProperty(PropertyKey.TARGET, TabDelimitedFileUtil.getPartString(this.getColumnIndex(PROT2), parts));

		return edge;
	}

	public int getColumnIndex(String colName)
	{
		Integer index = this.columnIndexMap.get(colName.toLowerCase());

		if (index == null)
		{
			index = -1;
		}

		return index;
	}

	public String getPartString(int index, String[] parts)
	{
		try
		{
			if (parts[index].length() == 0)
			{
				return "";
			}
			else
			{
				return parts[index];
			}
		}
		catch (ArrayIndexOutOfBoundsException e)
		{
			return "";
		}
	}
}