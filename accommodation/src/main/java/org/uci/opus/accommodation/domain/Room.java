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
 * Computer Center, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2011
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
package org.uci.opus.accommodation.domain;

import java.util.Date;

public class Room {
	private Integer id;
	private String code;
	private String description;
	private int floorNumber;
	private int numberOfBedSpaces;
	private int availableBedSpace;
	private Hostel hostel;
	private String roomTypeCode;
	private HostelBlock block;
	private Date writeWhen;
	private String writeWho;
	private String active="Y";

	public static final Room EMPTY;
	
	static {
	    EMPTY = new Room();
	    EMPTY.setID(0);
	}
	
	/**
	 *Gets Room ID
	 * @return
	 */
	public Integer getID() {
		return id;
	}

	public int getId() {
	    return getID() != null ? getID() : 0;
	}

	/**
	 * Sets Room ID
	 * @param id
	 */
	public void setID(Integer id) {
		this.id = id;
	}

	/**
	 * Gets the Code
	 * @return
	 */
	public String getCode() {
		return code;
	}

	/**
	 * Sets the Code
	 * @param code
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * Gets the Room Description
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * Sets the Room Description
	 * @param description
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * Gets the floor number on which the room is found 
	 * @return
	 */
	public int getFloorNumber() {
		return floorNumber;
	}

	/**
	 * Sets the floor number on which the room is found
	 * @param floorNumber
	 */
	public void setFloorNumber(int floorNumber) {
		this.floorNumber = floorNumber;
	}

	/**
	 * Gets the number of BedSpace which the room has
	 * @return
	 */
	public int getNumberOfBedSpaces() {
		return numberOfBedSpaces;
	}

	/**
	 * Sets the number of BedSpace which the room has
	 * @param numberOfBedSpaces
	 */
	public void setNumberOfBedSpaces(int numberOfBedSpaces) {
		this.numberOfBedSpaces = numberOfBedSpaces;
	}

	/**
	 * Gets the Hoste
	 * @return
	 */
	public Hostel getHostel() {
		return hostel;
	}
	
	/**
	 * Sets the Hostel
	 * @param hostel
	 */
	public void setHostel(Hostel hostel) {
		this.hostel = hostel;
	}
	
	/**
	 * Gets the block to which the room blongs to
	 * 
	 * @return 
	 */
	public HostelBlock getBlock() {
		return block;
	}
	
	/**
	 * Sets the block to which the room blongs to
	 * 
	 * @param block
	 */
	public void setBlock(HostelBlock block) {
		this.block = block;
	}
	
	/**
	 * Gets the Date when the record was first written to the database
	 * @return
	 */
	public Date getWriteWhen() {
		return writeWhen;
	}

	/**
	 * Sets the Date when the record was first written to the database
	 * @param writeWhen
	 */
	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}

	/**
	 * Gets the application application or user which persisted the data to the database
	 * @return
	 */
	public String getWriteWho() {
		return writeWho;
	}

	/**
	 * Sets the application or user who will persist the data to the database
	 * @param writeWho
	 */
	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}

	/**
	 * Gets the state of the Hostel
	 * @return
	 */
	public String getActive() {
		return active;
	}

	/**
	 * Sets the state of the Hostel. Possible values are 'Y' and 'N'
	 * Default value is 'Y'
	 * 
	 * @param active
	 */
	public void setActive(String active) {
		if (active.equals("Y") || active.equals("N")) {
            this.active = active;
        } else {
            throw new IllegalArgumentException("Invalid Argument! The value can either be 'Y' or 'N'");
        }
	}
	/**
	 * Gets the number of bed spaces available
	 * @return
	 */
	public int getAvailableBedSpace() {
		return availableBedSpace;
	}

	/**
	 * Sets the number of bed space available
	 * @param availableBedSpace
	 */
	public void setAvailableBedSpace(int availableBedSpace) {
		this.availableBedSpace = availableBedSpace;
	}

    public void setRoomTypeCode(String roomTypeCode) {
        this.roomTypeCode = roomTypeCode;
    }

    public String getRoomTypeCode() {
        return roomTypeCode;
    }
	
	
}