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
package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.domain.StudentAccommodation;

public class AllocationsForm {
	
	private String txtErr;
	private String txtMsg;
	
	private List<StudentAccommodation> allocations;
	private List<Hostel> hostels;
	private List<HostelBlock> blocks;
	private List<Room> rooms;
	private boolean useHostelBlocks;
	
	public String getTxtErr() {
		return txtErr;
	}
	
	public void setTxtErr(String txtErr) {
		this.txtErr = txtErr;
	}
	
	public String getTxtMsg() {
		return txtMsg;
	}
	
	public void setTxtMsg(String txtMsg) {
		this.txtMsg = txtMsg;
	}

	public List<StudentAccommodation> getAllocations() {
		return allocations;
	}

	public void setAllocations(List<StudentAccommodation> allocations) {
		this.allocations = allocations;
	}

	public List<Hostel> getHostels() {
		return hostels;
	}

	public void setHostels(List<Hostel> hostels) {
		this.hostels = hostels;
	}

	public List<HostelBlock> getBlocks() {
		return blocks;
	}

	public void setBlocks(List<HostelBlock> blocks) {
		this.blocks = blocks;
	}

	public List<Room> getRooms() {
		return rooms;
	}

	public void setRooms(List<Room> rooms) {
		this.rooms = rooms;
	}

	public boolean getUseHostelBlocks() {
		return useHostelBlocks;
	}

	public void setUseHostelBlocks(boolean useHostelBlocks) {
		this.useHostelBlocks = useHostelBlocks;
	}
	
}