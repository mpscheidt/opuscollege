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

package org.uci.opus.college.web.util.exam;

import java.text.Collator;
import java.util.Comparator;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ResultsBuilderComparator implements Comparator<ResultLine> {

    private static Logger log = LoggerFactory.getLogger(ResultsBuilderComparator.class);

    private String preferredPersonSorting;
    
    // use Collator to sort correctly á etc.
    // eventually the Locale should be specified to get the appropriate Collator
    private Collator coll = Collator.getInstance();


    public ResultsBuilderComparator(String preferredPersonSorting) {

        setPreferredPersonSorting(preferredPersonSorting);
    }
    
    
    @Override
    public int compare(ResultLine line1, ResultLine line2) {
		int result;
		
		String name1;
		String name2;
        try {
            name1 = BeanUtils.getProperty(line1, preferredPersonSorting);
            name2 = BeanUtils.getProperty(line2, preferredPersonSorting);
        } catch (Exception e) {
            throw new RuntimeException("Check the 'preferredPersonSorting' init parameter!", e);
        }
		if (name1 == null) name1 = "";
        if (name2 == null) name2 = "";
		
		result = coll.compare(name1, name2);

		// prevent 0 since the SortedSet would consider it equal, and refuse to add it,
		// even though it may differ in other property values
		if (result == 0 && line1 != line2) result = -1;
		
		return result;
	}

    public String getPreferredPersonSorting() {
        return preferredPersonSorting;
    }

    public void setPreferredPersonSorting(String preferredPersonSorting) {
        this.preferredPersonSorting = preferredPersonSorting;
    }

}
