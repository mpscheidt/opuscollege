/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.college.domain;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

/**
 * @author stelio2
 * @author markus
 */
public class AcademicYear implements Serializable {

    private static final long serialVersionUID = 1L;

    private static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	private int id;
	private String description;
	private Date startDate;
	private Date endDate;
	private int nextAcademicYearId;
	
	public AcademicYear() {
		description = "";
		startDate = new Date();
		endDate = new Date();
	}
	
	public AcademicYear(String description, Date startDate, Date endDate) {
		this.description = description;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	
	/**
	 * @param description
	 * @param startDate in format "yyyy-MM-dd"
	 * @param endDate same format as {@link #startDate}
	 * @throws ParseException
	 */
	public AcademicYear(String description, String startDate, String endDate) throws ParseException {
		this(description, df.parse(startDate), df.parse(endDate));
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = StringUtils.trim(description);
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
    public int getNextAcademicYearId() {
        return nextAcademicYearId;
    }
    public void setNextAcademicYearId(int nextAcademicYearId) {
        this.nextAcademicYearId = nextAcademicYearId;
    }
    
    public String toString() {
        return
        "\n AcademicYear is: "
        + "\n id = " + this.id
        + "\n description = " + this.description
        + "\n startDate = " + this.startDate
        + "\n endDate = " + this.endDate 
        + "\n nextAcademicYearId = " + this.nextAcademicYearId;
    }

}
