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

package org.uci.opus.util;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.Lookup;

/**
 * @author J. Nooitgedagt
 * created to add a lookup (e.g. an addresstype) to an arraylist of lookups
 * ordered by description, keeping the ordering correct.
 */
public class ExtendedArrayList extends ArrayList {
    
    /**
	 * Generated serialVersionID.
	 */
	private static final long serialVersionUID = -1125055919669596671L;

	private static Logger log = LoggerFactory.getLogger(ExtendedArrayList.class);
    
    public void insertLookupByDescription(final Lookup newLookup) {
  
        String newLookupDescription = newLookup.getDescription();
        Lookup lookup = null;
        String description = "";
        boolean addLookup = true;
        int i = 0;
        if (this.size() != 0) {
            for (i = 0; i < this.size(); i++) {
                lookup = (Lookup) this.get(i);
                description = lookup.getDescription();
                // new before existing
                if (description.compareTo(newLookupDescription) > 0) {
                    this.add(newLookup);
                    addLookup = false;
                    break;
                }
            }
            // lookup not added yet: add to end of array
            if (addLookup) {
                this.add(newLookup);
            }
        // add to empty array
        } else {
            this.add(newLookup);
        }   
    }
}
