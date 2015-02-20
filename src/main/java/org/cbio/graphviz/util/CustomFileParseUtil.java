package org.cbio.graphviz.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by sos on 2/19/15.
 */
public class CustomFileParseUtil extends FileParseUtil
{
	public static final String SAMPLE_ID = "SampleID";

	//protected HashMap<String, List<Map>> dataMatrix;

	public CustomFileParseUtil(String headerLine)
	{
		super(headerLine);
	}

	public Map<String, String> parseLine(String line)
	{
		String parts[] = line.split("\t", -1);

		Map<String, String> values = new HashMap<>();

		for (String key: this.columnIndexMap.keySet())
		{
			values.put(key,
				TabDelimitedFileUtil.getPartString(this.getColumnIndex(key), parts));
		}

		return values;
	}

	public String getValue(String line, String key)
	{
		Map<String, String> values = parseLine(line);

//		String sampleId = TabDelimitedFileUtil.getPartString(
//				this.getColumnIndex(SAMPLE_ID), parts);

		return values.get(key.toLowerCase());
	}
}
