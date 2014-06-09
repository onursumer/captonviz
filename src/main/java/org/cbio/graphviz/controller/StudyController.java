package org.cbio.graphviz.controller;

import org.cbio.graphviz.service.CancerContextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.io.IOException;

@Controller
@RequestMapping("/study")
public class StudyController
{
	@Autowired
	CancerContextService cancerContextService;



	public CancerContextService getCancerContextService() {
		return cancerContextService;
	}

	public void setCancerContextService(CancerContextService cancerContextService) {
		this.cancerContextService = cancerContextService;
	}

	@RequestMapping(value = "list",
	                method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> listStudies() {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String cancerStudies;

		try {
			cancerStudies = cancerContextService.listAvailableCancers();
		} catch (IOException e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(cancerStudies, headers, HttpStatus.OK);
	}

	@RequestMapping(value = "methods",
	                method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> listMethods() {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String methods;
		try {
			methods = cancerContextService.listAvailableMethods();
		} catch (IOException e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(methods, headers, HttpStatus.OK);
	}

	@RequestMapping(value = "get/{study}/{method}", method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> getStudyData(@PathVariable String study,
			@PathVariable String method)
	{
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String response;
		try {
			response = cancerContextService.getStudyData(study, method);
		} catch (IOException e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(response, headers, HttpStatus.OK);
	}
}
