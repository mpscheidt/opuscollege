package org.uci.opus.ucm.validator;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.poi.poifs.filesystem.FileMagic;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.ucm.web.form.ImportStudentsResultsForm;
import org.uci.opus.util.StringUtil;

@Component
public class ImportStudentsResultsFormValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return ImportStudentsResultsForm.class.isAssignableFrom(clazz);    }

    @Override
    public void validate(Object object, Errors errors) {
        
        ImportStudentsResultsForm form = (ImportStudentsResultsForm) object;

        if ((form.getStudentsResultsFile() == null) 
        		|| (form.getStudentsResultsFile().length == 0)) {
            errors.rejectValue("studentsResultsFile", "invalid.empty.format");
        }

        if ( StringUtil.isNullOrEmpty(form.getFileModel().getValue(), true)){ 
            errors.rejectValue("fileModel", "invalid.empty.format");
        }
        if(form.getTeacherId() == 0){
        	errors.rejectValue("teacherId", "invalid.empty.format");
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

    	// see: https://stackoverflow.com/q/54177333/606662
    	// https://poi.apache.org/apidocs/dev/org/apache/poi/poifs/filesystem/FileMagic.html
    	FileMagic fileMagic = FileMagic.valueOf(in);
    	boolean isValid = fileMagic.equals(FileMagic.OOXML);

//		// For .xlsx
//		boolean isValid = POIXMLDocument.hasOOXMLHeader(in);
//
//		if (!isValid) {
//			isValid = POIFSFileSystem.hasPOIFSHeader(in);
//		}
//
//		try {
//			XSSFWorkbook wb = new XSSFWorkbook(in);
//			// For .xls
//			// POIFSFileSystem.hasPOIFSHeader(in);
//		} catch (org.apache.poi.POIXMLException e) {
//			isValid = false;
//		}

		return isValid;
	 }

}
