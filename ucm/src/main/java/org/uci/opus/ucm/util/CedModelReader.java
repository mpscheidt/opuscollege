package org.uci.opus.ucm.util;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.uci.opus.ucm.domain.StudentResult;


public class CedModelReader implements StudentsResultsReader{

	@Override
	public List<StudentResult> getResults(InputStream stream) throws IOException {
		// TODO Auto-generated method stub
	
	
	//InputStream inp = new FileInputStream(
			//"/home/stelio2/development/eclipse_workspaces/test_workspace/TestExcel/src/CLIMATO.xlsx");

	XSSFWorkbook wb = new XSSFWorkbook(stream);

	XSSFSheet sheet = wb.getSheetAt(0);
	// Row row = sheet.getRow(5);
	// Cell cell = row.getCell(4);
	Iterator<Row> it = sheet.iterator();

	List<StudentResult> results = new ArrayList<StudentResult>(sheet.getLastRowNum());
	
	
	for (int i = 2; i < sheet.getLastRowNum(); i++) {

		XSSFRow row = sheet.getRow(i);
		XSSFCell batchCell = row.getCell(0);
		XSSFCell studentCodeCell = row.getCell(4);
		XSSFCell studentResultCell = row.getCell(69);

		String batch = handleCell(batchCell).toString();
		
		if("0".equals(batch)) break;
			
		String studentCode = handleCell(studentCodeCell).toString();
		BigDecimal studentResult = new BigDecimal(handleCell(studentResultCell).toString());
		
		//System.out.println(i + "-" + studentCodeCell.getCellType() + "  : " + studentResultCell.getCellType());
		System.out.println(i + "-" + studentCode + "  : " + studentResult);
	
		StudentResult sr = new StudentResult();
		sr.setStudentCode(studentCode);
		sr.setResult(studentResult);
		
		results.add(sr);
		
	}


	return null;
}

private static Object handleCell(XSSFCell cell) {
	cell.setCellType(CellType.STRING);
	Object val = new Object();

		val = cell.getStringCellValue();
	return val;
}


}
