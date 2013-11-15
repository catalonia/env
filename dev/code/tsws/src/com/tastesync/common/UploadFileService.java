package com.tastesync.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

import org.apache.commons.io.IOUtils;
import org.jboss.resteasy.plugins.providers.multipart.InputPart;
import org.jboss.resteasy.plugins.providers.multipart.MultipartFormDataInput;

import com.tastesync.common.utils.CommonFunctionsUtil;

public class UploadFileService {
	
	public UploadFileService() {
		
	}
	
	public Response uploadFile(MultipartFormDataInput input) throws IOException {
		String fileName = "";
		String upload = "";
		String user_id = null;
		boolean check_photo = false;
 
		Map<String, List<InputPart>> uploadForm = input.getFormDataMap();
		List<InputPart> inputParts = uploadForm.get("uploadedFile");
		
		try {
			user_id = input.getFormDataMap().get("user_id").get(0).getBody(String.class, null);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		if(user_id == null || user_id.trim().equals("")) {
			return Response.status(406).entity("Please enter user_id value.").build();
		}
		
		//Upload photo
		for (InputPart inputPart : inputParts) {
			MultivaluedMap<String, String> header = inputPart.getHeaders();
			fileName = getFileName(header);
				
			//Change filename to random string
			String[] tokens = fileName.split("\\.(?=[^\\.]+$)");
			String extension = tokens[1];
			fileName = CommonFunctionsUtil.generateUniqueKey() + "." + extension;
				
			//Convert the uploaded file to inputstream
			InputStream inputStream = inputPart.getBody(InputStream.class,null);
	 
			byte[] bytes = IOUtils.toByteArray(inputStream);
	 
			//Constructs upload file path
			upload = GlobalVariables.UPLOADED_USER_FILE_PATH + fileName;

			writeFile(bytes, upload);
			
			//Insert/Update user photo
//			MySQL mysql = new MySQL();
//			check_photo = mysql.checkUserPhotoExist(user_id);
			
			if(check_photo) {
				
				//Update user photo
//				mysql.update_user_photo(user_id, fileName);
			}
			else {
				
				//Insert new user photo
//				mysql.insert_user_photo(user_id, fileName);
			}
		}
 
		return Response.status(200).entity("Upload file successfully. Uploaded filename : " + fileName).build();
	}
 
	/**
	 * header sample
	 * {
	 * 	Content-Type=[image/png], 
	 * 	Content-Disposition=[form-data; name="file"; filename="filename.extension"]
	 * }
	 **/
	//Get uploaded filename, is there a easy way in RESTEasy?
	private String getFileName(MultivaluedMap<String, String> header) {
 
		String[] contentDisposition = header.getFirst("Content-Disposition").split(";");
 
		for (String filename : contentDisposition) {
			if ((filename.trim().startsWith("filename"))) {
 
				String[] name = filename.split("=");
 
				String finalFileName = name[1].trim().replaceAll("\"", "");
				return finalFileName;
			}
		}
		return "Unknown";
	}
 
	//Save to somewhere
	private void writeFile(byte[] content, String filename) throws IOException {
		File file = new File(filename);
 
		if (!file.exists()) {
			file.createNewFile();
		}
 
		FileOutputStream fop = new FileOutputStream(file);
 
		fop.write(content);
		fop.flush();
		fop.close();
	}
}
