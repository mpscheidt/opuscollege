/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
 ******************************************************************************/
package org.uci.opus.accommodation.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;

public interface HostelMapper {

    /**
     * The method is used to persist a Hostel Object.
     * 
     * @param hostel
     * @return
     */
    void addHostel(Hostel hostel);

    /**
     * The method is used to update a Hostel Object.
     * 
     * @param hostel
     * @return
     */
    int updateHostel(Hostel hostel);

    /**
     * Checks if there is some hostel with same values (in params) as hostel with id = hostelId
     * 
     * @param params
     * @param roomId
     * @return
     */
    boolean isHostelRepeated(Map<String, Object> params);

    void updateHostelHistory(@Param("Hostel") Hostel hostel, @Param("operation") String operation);

    /**
     * The method is used to remove or delete Hostel information.
     * 
     * @param id
     * @return
     */
    int deleteHostel(int id);

    /**
     * The method is used to find a specific Hostel.
     * 
     * @param id
     */
    Hostel findHostel(int id);

    /**
     * The method is used to retrieve all the Hostels' information<br>
     * It returns null if no record was found
     * 
     * @return
     */
    List<Hostel> findAllHostels();

    /**
     * The method is used to retrieve all Hostels found by matching parameters<br>
     * It returns null if no record was found
     * 
     * @param params
     * @return
     */
    List<Hostel> findHostelsByParams(Map<String, Object> params);


    /**
     * The method is used to persist a Block Object to the database
     * 
     * @param block
     * @return
     */
    void addBlock(HostelBlock block);

    /**
     * The method is used to update a Block Object
     * 
     * @param block
     * @return
     */
    int updateBlock(HostelBlock block);

    void updateHostelBlockHistory(@Param("HostelBlock") HostelBlock hostelBlock, @Param("operation") String operation);

    /**
     * The method is used to remove or delete a Block
     * 
     * @param id
     * @return
     */
    int deleteBlock(int id);

    /**
     * The method is used to find a specific Block
     * 
     * @param id
     */
    HostelBlock findBlock(int id);

    /***
     * This method is used to retrieve all the Blocks It returns null if nor record was found
     * 
     * @return
     */
    List<HostelBlock> findAllBlocks();

    /***
     * This method is used to retrieve all the Block found by matching parameters<br />
     * It returns null if no record was found
     * 
     * @param params
     */
    List<HostelBlock> findBlocksByParams(Map<String, Object> params);


    /**
     * The method is used to persist a Room Object to the database
     * 
     * @param block
     * @return
     */
    void addRoom(Room room);

    /**
     * The method is used to update a Room Object.
     * 
     * @param room
     * @return
     */
    int updateRoom(Room room);

    void updateRoomHistory(@Param("Room") Room room, @Param("operation") String operation);

    /**
     * The method is used to remove or delete a Block
     * 
     * @param id
     * @return
     */
    int deleteRoom(int id);

    /**
     * The method is used to find a specific Room
     * 
     * @param id
     * @return
     */
    Room findRoom(int id);

    /***
     * This method is used to retrieve all the Rooms It returns null if nor record was found
     * 
     * @return
     */
    List<Room> findAllRooms();

    /**
     * Checks if there is some room with same values
     */
    boolean isRoomRepeated(Map<String, Object> params);

    /***
     * This method is used to retrieve all the Rooms found by matching parameters<br />
     * It returns null if no record was found
     * 
     * @param params
     * @return
     */
    List<Room> findRoomsByParams(Map<String, Object> params);

    /**
     * This method is used to retrieve all rooms with available space greater than 0. Param ids can
     * be either any or all of the following id, description,code, active, hostelId, blockId,
     * numberOfBedSpaces,floorNumber
     * 
     * @param params
     * @return List&lt;Room&gt; or Null
     */
    List<Room> findAvailableRoomsByParams(Map<String, Object> params);

}