package org.uci.opus.ucm.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Reads and validates students results from a file (stream)
 * @author stelio2
 *
 */
public class CedStudentsResultsHandler {
	private static Logger log = LoggerFactory.getLogger(CedStudentsResultsHandler.class);
	private  List<String> errors;
	private  List<String> warnings;
	private  List<String> info;

	private  SortedMap<String, String> duplicatedEntries;
	/**
	 * Stores invalid entries.
	 * The keys are the line numbers of the invalid entries, the values are the specific errors messages
	 */
	private  SortedMap<String, String> invalidEntries;
	/**
	 * Stores valid entries.
	 * The keys are the students codes and the results the values
	 */
	private  SortedMap<String, String> validEntries;
	
	public CedStudentsResultsHandler(){
		
		info = new ArrayList<String>();
		errors = new ArrayList<String>();
		warnings = new ArrayList<String>();
		
		duplicatedEntries = new TreeMap<String, String>();
		invalidEntries = new TreeMap<String, String>();
		validEntries = new TreeMap<String, String>();
	}
	
public SortedMap<String, String> readResultsFromStream(InputStream inp) throws IOException{
		
		invalidEntries.clear();
		validEntries.clear();
		duplicatedEntries.clear();
		
		errors.clear();
		info.clear();
		warnings.clear();
		

		XSSFWorkbook wb = new XSSFWorkbook(inp);

		XSSFSheet sheet = wb.getSheetAt(0);
		Iterator<Row> it = sheet.iterator();

		//first row is header
		for (int i = 1; i < sheet.getLastRowNum(); i++) {

			XSSFRow row = sheet.getRow(i);
			XSSFCell studentCodeCell = row.getCell(1);
			XSSFCell studentResultCell = row.getCell(2);
			
			Object obj = handleCell(studentCodeCell);
			if(obj==null){
				log.info("no data in line "+i);
				continue;
			}
			String studentcodes[] = handleCell(studentCodeCell).toString().trim().split(" ");
			String studentCode = studentcodes[0];
			//String studentCode = handleCell(studentCodeCell).toString().trim();
			String studentMark = handleCell(studentResultCell).toString().trim();
			
			//System.out.println(i + "-" + studentCodeCell.getCellType() + "  : " + studentResultCell.getCellType());
			//System.out.println(i + "-" + studentCode + "  : " + studentResult);
			
			if(isValidEntry(i, studentCode, studentMark)){
				if(!validEntries.containsKey(studentCode)){
					validEntries.put(studentCode, studentMark);
				}else{
					duplicatedEntries.put(studentCode, studentMark);
				}
			} 
		}
		
		return this.validEntries;
	}

public SortedMap<String, String> readResultsFromStreamCedMachine(InputStream inp) throws IOException{
	
	invalidEntries.clear();
	validEntries.clear();
	duplicatedEntries.clear();
	
	errors.clear();
	info.clear();
	warnings.clear();
	

	XSSFWorkbook wb = new XSSFWorkbook(inp);

	XSSFSheet sheet = wb.getSheetAt(0);
	Iterator<Row> it = sheet.iterator();

	//first row is header
	for (int i = 10; i < sheet.getLastRowNum(); i++) {

		XSSFRow row = sheet.getRow(i);
		XSSFCell studentCodeCell = row.getCell(0);
		XSSFCell studentResultCell = row.getCell(2);
		
		Object obj = handleCell(studentCodeCell);
		if(obj==null){
			log.info("no data in line "+i);
			continue;
		}
		String studentcodes[] = handleCell(studentCodeCell).toString().trim().split(" ");
		String studentCode = studentcodes[0];
		//String studentCode = handleCell(studentCodeCell).toString().trim();
		String studentMark = handleCell(studentResultCell).toString().trim();
		
		//System.out.println(i + "-" + studentCodeCell.getCellType() + "  : " + studentResultCell.getCellType());
		//System.out.println(i + "-" + studentCode + "  : " + studentResult);
		
		if(isValidEntry(i, studentCode, studentMark)){
			if(!validEntries.containsKey(studentCode)){
				validEntries.put(studentCode, studentMark);
			}else{
				duplicatedEntries.put(studentCode, studentMark);
			}
		} 
	}
	
	return this.validEntries;
}
	
	/**
	 * Formats cell before retrieving values.
	 * @param cell
	 * @return
	 */
	private static Object handleCell(XSSFCell cell) {
		//cell.setCellType(CellType.STRING);
		//cell.setCellType(CellType.STRING);
		if(cell.getCellTypeEnum()==CellType.STRING){
			return cell.getStringCellValue();
		}
		else if(cell.getCellTypeEnum()==CellType.NUMERIC){
			return cell.getNumericCellValue();
			 
		}	
		return null;
	}
	
//	private static Object handleNumericCell(XSSFCell cell) {
//		cell.setCellType(Cell.CELL_TYPE_NUMERIC);
//		Object val = new Object();
//			val = cell.getNumericCellValue();
//			//new java.text.DecimalFormat("0").format( cell.getNumericCellValue() )
//		return val + "";
//	}
	
	private boolean isValidEntry(int rowNumber, String studentCode, String studentMark){
		boolean isValid = true;
		
		//starts with 7 and no longer then 9 digits
		if(!studentCode.matches("^7[0-9]{8}$")){
			isValid = false;
			invalidEntries.put((invalidEntries.size() + 1) + "", "Código inválido na linha  " + rowNumber + ":" +  studentCode);
		}

		
		//check if is a valid number
		if(!studentMark.matches("[0-9]+([,.][0-9]{1,2})?")){
			isValid = false;
			invalidEntries.put(rowNumber+"", "Resultado inválido: " + studentMark);
			
		} 	
		
		return isValid;
	}
	
	
	/*
	 * Getters and setters **/
	 public void report(){
		 
		 if(!validEntries.isEmpty())
			 System.out.println("ENTRIES");
			 for(Map.Entry<String, String> entry: validEntries.entrySet())
				 System.out.println(entry.getKey() + " : " + entry.getValue());

		 if(!invalidEntries.isEmpty())
			 System.out.println("\n \n INVALID ENTRIES");
				for(Map.Entry<String, String> entry: invalidEntries.entrySet())
				 System.out.println(entry.getKey() + " : " + entry.getValue());

		if(!duplicatedEntries.isEmpty())
			 System.out.println("\n \n DUPLICATE ENTRIES");
				for(Map.Entry<String, String> entry: duplicatedEntries.entrySet())
				 System.out.println(entry.getKey() + " : " + entry.getValue());
	 }

	public List<String> getErrors() {
		return errors;
	}

	public List<String> getWarnings() {
		return warnings;
	}

	public List<String> getInfo() {
		return info;
	}

	public SortedMap<String, String> getDuplicatedEntries() {
		return duplicatedEntries;
	}

	public SortedMap<String, String> getInvalidEntries() {
		return invalidEntries;
	}

	public SortedMap<String, String> getValidEntries() {
		return validEntries;
	}
	 

	public void addValidEntry(String key, String value){
		validEntries.put(key, value);
	}
	
	public void addInvalidEntry(String value){
		this.invalidEntries.put((invalidEntries.size() + 1) + "", value);
	}
	
	public void addError(String error){
		errors.add(error);
	}
	 
}
