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

package org.uci.opus.college.web.flow.person;

import java.util.Collection;
import java.util.Comparator;

public class StudentGroupComparator implements Comparator<StudentGroup> {

    private final int EQUAL = 0;

    //
    // Be sure to follow the specification and "ensure that sgn(compare(x, y)) == -sgn(compare(y, x)) for all x and y"
    //
    @Override
    public int compare(StudentGroup o1, StudentGroup o2) {

        if (o1 == o2) return EQUAL;

        // ------------ passedSubjects ------------
        // we want those to be first who have passed least subjects
        int sort = compareCollections(o1.getPassedSubjects(), o2.getPassedSubjects());
        if (sort != EQUAL) return sort;

        // ------------ allSubjects ------------
        // then we want those who have less total subjects
        sort = compareCollections(o1.getAllSubjects(), o2.getAllSubjects());;
        if (sort != EQUAL) return sort;
        
        // ------------ allSubjectBlocks ------------
        sort = compareCollections(o1.getAllSubjectBlocks(), o2.getAllSubjectBlocks());
        if (sort != EQUAL) return sort;
        
        // ------------ subscribedSubjectIds ------------
        // then we want those who have less subscribed subjects
        sort = compareCollections(o1.getSubscribedSubjectIds(), o2.getSubscribedSubjectIds());
        if (sort != EQUAL) return sort;

        // ------------ subscribedSubjectBlockIds ------------
        sort = compareCollections(o1.getSubscribedSubjectBlockIds(), o2.getSubscribedSubjectBlockIds());
        if (sort != EQUAL) return sort;

        // ------------ cardinalTimeUnitStatusCode ------------
        String cardinalTimeUnitStatusCode1 = o1.getCardinalTimeUnitStatusCode() == null ? "" : o1.getCardinalTimeUnitStatusCode();
        String cardinalTimeUnitStatusCode2 = o2.getCardinalTimeUnitStatusCode() == null ? "" : o2.getCardinalTimeUnitStatusCode();
        sort = cardinalTimeUnitStatusCode1.compareTo(cardinalTimeUnitStatusCode2);
        if (sort != EQUAL) return sort;

        //all comparisons have yielded equality
        //verify that compareTo is consistent with equals (optional)
//        assert o1.equals(o2) : "compareTo inconsistent with equals.";
        
        return EQUAL;
    }

    /**
     * Compare based on (1) lower number of items and - if equal - (2) smaller hashCode.
     * @param c1
     * @param c2
     * @return
     */
    private int compareCollections(Collection<?> c1, Collection<?> c2) {
        int size1 = c1 == null ? 0 : c1.size();
        int size2 = c2 == null ? 0 : c2.size();

        // we want those to be first who have passed least subjects
        int sort = size1 - size2;
        if (sort != EQUAL) return sort;

        sort = (c1 == null ? 0 : c1.hashCode()) - (c2 == null ? 0 : c2.hashCode());
        return sort;
    }
}
