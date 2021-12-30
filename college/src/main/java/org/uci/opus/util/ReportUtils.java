package org.uci.opus.util;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.swing.ImageIcon;

import org.uci.opus.college.domain.ReportProperty;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRImageRenderer;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.renderers.BatikRenderer;

/**
 * 
 * @author stelio2
 *
 */
public class ReportUtils {

	/**
	 * Convertes a list of Report Properties  to a map properties suitable for reports
	 * @param properties
	 * @param reportName
	 * @return
	 * @throws JRException
	 */
	public static Map toPropertiesMap(List<ReportProperty> properties) throws JRException {

        Map map = new HashMap();


        for (Iterator iterator = properties.iterator(); iterator.hasNext();) {
            ReportProperty property = (ReportProperty) iterator.next();
            String propertyName = property.getName();

            //if it is a file property
            if (!property.getType().equalsIgnoreCase("text")) {

                if (property.isVisible()) {
                    if ((property.getFile().length == 0)) {
                        //reportController.putModelParameter(mav, "reportLogo", new ImageIcon().getImage());
                        map.put(propertyName, new ImageIcon().getImage());
                    } else {

                        //choose a different renderer for SVG images
                        if ("image/svg+xml".equals(property.getType())) {
                            map.put(propertyName, BatikRenderer.getInstance(property.getFile()));
                        } else {
                            map.put(propertyName, JRImageRenderer.getInstance(property.getFile()));  
                        }
                    }
                } else {
                    map.put(propertyName, new ImageIcon().getImage());
                }

                //if it is text property
            } else {

                if (property.isVisible()) {
                    map.put(propertyName, property.getText());
                } else {
                    map.put(propertyName, "");
                }
            }
        }

        return map;
    }
	
	public static void exportReportToPdfFile(String sourceJasperFile, String outputFile, Map params, Connection conn) throws JRException{
	
		JasperRunManager.runReportToPdfFile(sourceJasperFile
    			, outputFile
    			, params
    			, conn);
	
	}
	
}
