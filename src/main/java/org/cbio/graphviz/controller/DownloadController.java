package org.cbio.graphviz.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;

@Controller
@RequestMapping("/download")
public class DownloadController
{
	@RequestMapping(value = "network/{type}",
	                method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> dowloadNetwork(@PathVariable String type,
			@RequestParam String filename,
			@RequestParam String content)
	{
		HttpHeaders headers = new HttpHeaders();

		headers.add("Content-Type", "application/force-download; charset=utf-8");
		headers.add("Content-Disposition", "inline; filename=" + filename);

		if (content == null)
		{
			return new ResponseEntity<String>("Invalid content", headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(content, headers, HttpStatus.OK);
	}

}
