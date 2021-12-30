package org.uci.opus.ucm.validator;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.poi.POIXMLDocument;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.ucm.web.form.SubjectResultsForm;
import org.uci.opus.util.StringUtil;

@Component
public class SubjectResultsFormValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return SubjectResultsForm.class.isAssignableFrom(clazz);    }

    @Override
    public void validate(Object object, Errors errors) {
        
        SubjectResultsForm form = (SubjectResultsForm) object;

        if ((form.getStudentsResultsFile() == null) 
        		|| (form.getStudentsResultsFile().length == 0)) {
            errors.rejectValue("studentsResultsFile", "invalid.empty.format");
        }

        if ( StringUtil.isNullOrEmpty(form.getFileModel(), true)){ 
            errors.rejectValue("fileModel", "invalid.empty.format");
        }

        try {
			if(!isValidXlsxFile(new ByteArrayInputStream(form.getStudentsResultsFile()))){
				errors.rejectValue("studentsResultsFile", "invalid.invalid");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    
    protected boolean isValidXlsxFile(InputStream in) throws IOException{
		 // For .xlsx
		 boolean isValid = POIXMLDocument.hasOOXMLHeader(in);
		 try{
		 XSSFWorkbook wb = new XSSFWorkbook(in);
		 // For .xls
		 //POIFSFileSystem.hasPOIFSHeader(in);
		 }catch(org.apache.poi.POIXMLException e){
			 isValid = false;
		 }
		 
		 return isValid;
	 }

}
