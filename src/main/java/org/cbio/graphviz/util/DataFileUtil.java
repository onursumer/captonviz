package org.cbio.graphviz.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DataFileUtil extends FileParseUtil
{
	public static final String BARCODE = "TCGA_patient_barcode";
	public static final String TUMOR = "Tumor";

	protected HashMap<String, List<Map>> dataMatrix;

	DataFileUtil(String headerLine)
	{
		super(headerLine);
	}

	public void parseLine(String line)
	{
		String parts[] = line.split("\t", -1);

		//record.setHugoGeneSymbol(
		// TabDelimitedFileUtil.getPartString(
		// this.getColumnIndex(MafUtil.HUGO_SYMBOL),
		// parts));

		String barcode = TabDelimitedFileUtil.getPartString(this.getColumnIndex(BARCODE), parts);
		String tumor = TabDelimitedFileUtil.getPartString(this.getColumnIndex(TUMOR), parts);

		Map<String, String> values = new HashMap<>();

		for (String key: this.columnIndexMap.keySet())
		{
			if (!key.equalsIgnoreCase(TUMOR))
			{
				values.put(key,
					TabDelimitedFileUtil.getPartString(this.getColumnIndex(key), parts));
			}
		}

		List<Map> list = dataMatrix.get(tumor.toLowerCase());

		if (list == null)
		{
			list = new ArrayList<>();
			this.dataMatrix.put(tumor.toLowerCase(), list);
		}

		list.add(values);
	}
}
