package org.cbio.graphviz.controller;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.List;

@Controller
@RequestMapping("/upload")
public class UploadController
{
//	public ResponseEntity<String> upload(MultipartHttpServletRequest request, HttpServletResponse response) {
//
//		//0. notice, we have used MultipartHttpServletRequest
//
//		//1. get the files from the request object
//		Iterator<String> itr =  request.getFileNames();
//
//		MultipartFile mpf = request.getFile(itr.next());
//
//		try {
//			//just temporary save file info into ufile
//			ufile.length = mpf.getBytes().length;
//			ufile.bytes= mpf.getBytes();
//			ufile.type = mpf.getContentType();
//			ufile.name = mpf.getOriginalFilename();
//
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//
//		//2. send it back to the client as <img> that calls get method
//		//we are using getTimeInMillis to avoid server cached image
//
//		return "<img src='http://localhost:8080/spring-mvc-file-upload/rest/cont/get/"+Calendar.getInstance().getTimeInMillis()+"' />";
//
//	}

	@RequestMapping(value = "file",
	                method = {RequestMethod.POST},
	                headers = "Accept=multipart/form-data")
	public ResponseEntity<String> uploadFile(HttpServletRequest request,
			HttpServletResponse response)
	{
		HttpHeaders headers = new HttpHeaders();

		try
		{
			List<FileItem> items =
				new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);

			Iterator<FileItem> iter = items.iterator();

			String result = "NA";

			if (iter.hasNext())
			{
				FileItem item = iter.next();

				InputStream contentStream = item.getInputStream();
				String fieldName = item.getFieldName();

				if (item.getSize() == 0)
				{
					return new ResponseEntity<String>("Empty file.", headers, HttpStatus.BAD_REQUEST);
				}

				result = fieldName + ":" + Long.toString(item.getSize());
			}

			return new ResponseEntity<String>(result, headers, HttpStatus.OK);
		}
		catch (IOException e)
		{
			return new ResponseEntity<String>("IO error.", headers, HttpStatus.BAD_REQUEST);
		}
		catch (FileUploadException e)
		{
			return new ResponseEntity<String>("File upload error.", headers, HttpStatus.BAD_REQUEST);
		}
	}
}
