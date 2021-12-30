/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 
 * 1.1 (the "License"), you may not use this file except in compliance with 
 * the License. You may obtain a copy of the License at 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College accommodationfee module code.
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

package org.uci.opus.accommodationfee.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.expoint.RoomAllocationExtPoint;
import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.fee.service.FeeManagerInterface;

@Service
public class RoomAllocationExtension implements RoomAllocationExtPoint {

    @Autowired private AccommodationFeeManagerInterface accommodationFeeManager;
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private FeeManagerInterface feeManager;

    @Override
    public boolean saveBalance(StudentAccommodation studentAccommodation,
            String writeWho) {

        StudentBalance studentBalance=new StudentBalance();
        studentBalance.setWriteWho(writeWho);
        //get the academicYearId to use for determining fees to use
        int academicYearId = accommodationManager.getAcademicYearId(studentAccommodation.getStudent().getStudentId());
        //use the studentAccommodation's academicYear to set the balance for a student
        studentBalance.setAcademicYearId(studentAccommodation.getAcademicYear().getId());
        studentBalance.setStudentId(studentAccommodation.getStudent().getStudentId());
        studentBalance.setExemption("N");
        
        Map<String,Object> params=new HashMap<String, Object>();
//      params.put("hostelId",studentAccommodation.getRoom().getHostel().getId());
        params.put("hostelTypeCode", studentAccommodation.getRoom().getHostel().getHostelTypeCode());
        params.put("roomTypeCode", studentAccommodation.getRoom().getRoomTypeCode());
        params.put("academicYearId", academicYearId);
        AccommodationFee accommodationFee = accommodationFeeManager.findAccommodationFeeByParams(params);
//      if(useHostelBlocks()){
//          params.put("blockId",studentAccommodation.getRoom().getBlock().getId());
//          AccommodationFee accommodationFee2=accommodationManager.findAccommodationFeeByParams(params);
//          if(accommodationFee2!=null)
//              accommodationFee=accommodationFee2;
//      }
//
//      params.remove("blockId");
//      AccommodationFee accommodationFee2 = accommodationManager.findAccommodationFeeByParams(params);
//      if(accommodationFee==null)
//          accommodationFee=accommodationFee2;
        
        //Check if fees were set, if not then return false;
        if(accommodationFee!=null){ 
//          Fee fee=accommodationManager.findFeeByAccommodationFeeId(accommodationFee.getId());
            studentBalance.setFeeId(accommodationFee.getId());
            studentBalance.setWriteWho(writeWho);
            feeManager.addStudentBalance(studentBalance);
            return true;
        }else{
            return false;
        }

    }

}
