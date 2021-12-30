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
 ******************************************************************************/
package org.uci.opus.accommodation.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.persistence.HostelMapper;


public class HostelManager implements HostelManagerInterface {

	@Autowired
	private HostelMapper hostelMapper;

	@Override
	public void addHostel(Hostel hostel) {
		hostelMapper.addHostel(hostel);
		hostelMapper.updateHostelHistory(hostel, "I");
	}

	@Override
	public void addRoom(Room room) {
		hostelMapper.addRoom(room);
		hostelMapper.updateRoomHistory(room, "I");
	}
	
	@Override
	public int updateHostel(Hostel hostel) {
		int rows = hostelMapper.updateHostel(hostel);
		hostelMapper.updateHostelHistory(hostel, "U");
        return rows;
	}

	@Override
	public int updateRoom(Room room) {
		int rows = hostelMapper.updateRoom(room);
		hostelMapper.updateRoomHistory(room, "U");
        return rows;
	}
	
	@Override
	public int deleteHostel(int id, String writeWho) {
        Hostel hostel = findHostelById(id);
        hostel.setWriteWho(writeWho);
        
        int rows = hostelMapper.deleteHostel(id);
        hostelMapper.updateHostelHistory(hostel, "D");
        
        return rows; 
	}

	@Override
	public int deleteRoom(int id, String writeWho) {
        Room room = findRoomById(id);
        room.setWriteWho(writeWho);
        
        int rows = hostelMapper.deleteRoom(id);
        hostelMapper.updateRoomHistory(room, "D");
        
        return rows;
	}
	
	@Override
	public Hostel findHostelById(int id) {
		return hostelMapper.findHostel(id);
	}

	@Override
	public Room findRoomById(int id) {
		return hostelMapper.findRoom(id);
	}
	
	@Override
	public List<Hostel> findAllHostels() {
		return hostelMapper.findAllHostels();
	}

	@Override
	public List<Room> findAllRooms() {
		return hostelMapper.findAllRooms();
	}
	
	@Override
	public Hostel findHostelByParams(Map<String, Object> params) {
		List<Hostel> list = hostelMapper.findHostelsByParams(params);
        return list.isEmpty() ? null : list.get(0);
	}
	
	@Override
	public List<Hostel> findHostelsByParams(Map<String, Object> params) {
		return hostelMapper.findHostelsByParams(params);
	}

	@Override
	public Room findRoomByParams(Map<String, Object> params) {
		List<Room> list = hostelMapper.findRoomsByParams(params);
        return list.isEmpty() ? null : list.get(0);
	}
	
	@Override
	public List<Room> findRoomsByParams(Map<String, Object> params) {
		return hostelMapper.findRoomsByParams(params);
	}
	
	@Override
	public void addBlock(HostelBlock block) {
		hostelMapper.addBlock(block);
        hostelMapper.updateHostelBlockHistory(block, "I");
	}

	@Override
	public int updateBlock(HostelBlock block) {
		int rows = hostelMapper.updateBlock(block);
		hostelMapper.updateHostelBlockHistory(block, "U");
        return rows;
	}

	@Override
	public int deleteBlock(int id, String writeWho) {
        HostelBlock hostelBlock = findBlockById(id);
        hostelBlock.setWriteWho(writeWho);

        int rows = hostelMapper.deleteBlock(id);
        hostelMapper.updateHostelBlockHistory(hostelBlock, "D");

        return rows;
	}

	@Override
	public HostelBlock findBlockById(int id) {
		return hostelMapper.findBlock(id);
	}

	@Override
	public List<HostelBlock> findAllBlocks() {
		return hostelMapper.findAllBlocks();
	}

	@Override
	public List<HostelBlock> findBlocksByHostelId(Integer hostelId) {
	    if (hostelId == null || hostelId == 0) return null;
	    
	    Map<String, Object> params = new HashMap<String, Object>();
        params.put("hostelId", hostelId);
        List<HostelBlock> allHostelBlocks = findBlocksByParams(params);
        return allHostelBlocks;
	}

	@Override
	public HostelBlock findBlockByParams(Map<String, Object> params) {
		List<HostelBlock> list = hostelMapper.findBlocksByParams(params);
        return list.isEmpty() ? null : list.get(0);
	}

	@Override
	public List<HostelBlock> findBlocksByParams(Map<String, Object> params) {
		return hostelMapper.findBlocksByParams(params);
	}

	@Override
	public List<Room> findAvailableRoomsByParams(Map<String, Object> params) {
		return hostelMapper.findAvailableRoomsByParams(params);
	}

	@Override
	public synchronized void reduceAvailableBedSpaceByOne(int roomId) {

       Room room=findRoomById(roomId);
        if(room.getAvailableBedSpace()>0){
            room.setAvailableBedSpace(room.getAvailableBedSpace()-1);
            updateRoom(room);
        }

	}

	@Override
	public synchronized void increaseAvailableBedSpaceByOne(int roomId) {
        Room room=findRoomById(roomId);
        if(room.getAvailableBedSpace()>=0 && room.getAvailableBedSpace()<room.getNumberOfBedSpaces()){
            room.setAvailableBedSpace(room.getAvailableBedSpace()+1);
            updateRoom(room);
        }
	}

	@Override
	public boolean isRoomRepeated(int roomId, Map<String, Object> params) {
	    
        if (params == null) {
            params = new HashMap<String, Object>();
        }
        params.put("id", roomId);

        return hostelMapper.isRoomRepeated(params);
	}

	@Override
	public boolean isHostelRepeated(int hostelId, Map<String, Object> params) {

        if (params == null) {
            params = new HashMap<String, Object>();
        }
        params.put("id", hostelId);

        return hostelMapper.isHostelRepeated(params);
	}

}
