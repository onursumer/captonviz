package org.cbio.graphviz.util;

import java.util.HashMap;

public abstract class FileParseUtil
{
	// mapping for all column names
	protected HashMap<String, Integer> columnIndexMap;

	/**
	 * Constructor.
	 *
	 * @param headerLine    Header Line.
	 */
	public FileParseUtil(String headerLine)
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

	public int getColumnIndex(String colName)
	{
		Integer index = this.columnIndexMap.get(colName.toLowerCase());

		if (index == null)
		{
			index = -1;
		}

		return index;
	}
}
