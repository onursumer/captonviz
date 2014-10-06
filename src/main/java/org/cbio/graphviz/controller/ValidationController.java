package org.cbio.graphviz.controller;

import org.cbio.graphviz.service.SampleValidationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.io.IOException;

@Controller
@RequestMapping("/validate")
public class ValidationController
{
	@Autowired
	SampleValidationService sampleValidationService;

	@RequestMapping(value = "samples/{samples}",
	                method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> validateSamples(
			@PathVariable String samples) {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String validationResult;

		try {
			validationResult = sampleValidationService.validateSamples(samples);
		} catch (Exception e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(validationResult, headers, HttpStatus.OK);
	}
}
