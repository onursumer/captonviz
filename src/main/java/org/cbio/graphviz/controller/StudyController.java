package org.cbio.graphviz.controller;

import org.cbio.graphviz.service.CancerContextService;
import org.cbio.graphviz.service.CustomizedContextService;
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

	@Autowired
	CustomizedContextService customContextServe;

	public CustomizedContextService getCustomContextServe()
	{
		return customContextServe;
	}

	public void setCustomContextServe(CustomizedContextService customContextServe)
	{
		this.customContextServe = customContextServe;
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

	@RequestMapping(value = "get/{study}/{method}/{size}", method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> getStudyData(@PathVariable String study,
			@PathVariable String method,
			@PathVariable Integer size)
	{
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String response;
		try {
			response = cancerContextService.getStudyData(study, method, size);
		} catch (IOException e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(response, headers, HttpStatus.OK);
	}

	@RequestMapping(value = "custom/{study}/{method}/{size}/{samples}",
	                method = {RequestMethod.GET, RequestMethod.POST},
	                headers = "Accept=application/json")
	public ResponseEntity<String> getCustomData(@PathVariable String study,
			@PathVariable String method,
			@PathVariable Integer size,
			@PathVariable String samples)
	{
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json; charset=utf-8");

		String response;
		try {
			response = customContextServe.getStudyData(study, method, size, samples);
		} catch (Exception e) {
			return new ResponseEntity<String>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<String>(response, headers, HttpStatus.OK);
	}
}
