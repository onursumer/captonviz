package org.cbio.graphviz.util;

public class DataUtil
{
	/**
	 * Removes the last digits (patient specific digits) from the sample id.
	 *
	 * @param sample    sample id (or patient id)
	 * @return          sample id (patient specific digits removed)
	 */
	public static String normalizeSample(String sample)
	{
		String normalized = sample;

		// no removal if not a TCGA sample...
		if (sample.toUpperCase().startsWith("TCGA"))
		{
			String[] parts = sample.split("-");

			if (parts.length > 3)
			{
				normalized = parts[0] + "-" +
				             parts[1] + "-" +
				             parts[2];
			}
		}

		return normalized;
	}
}
