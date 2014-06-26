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
public class StudyFileUtil extends FileParseUtil
{
	public static final String WEIGHT = "weight";
	public static final String IN_PC = "inPC";
	public static final String EDGE_SIGN = "edgesign";
	public static final String PROT1 = "prot1";
	public static final String PROT2 = "prot2";
	public static final String GENE1 = "gene1";
	public static final String GENE2 = "gene2";

	/**
	 * Constructor.
	 *
	 * @param headerLine    Header Line.
	 */
	public StudyFileUtil(String headerLine)
	{
		super(headerLine);
	}

	public CytoscapeJsEdge parseLine(String line)
	{
		String parts[] = line.split("\t", -1);

		CytoscapeJsEdge edge = new CytoscapeJsEdge();

		edge.setProperty(PropertyKey.WEIGHT, TabDelimitedFileUtil.getPartFloat(this.getColumnIndex(WEIGHT), parts));
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
}