/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia
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

--
-- Author: Markus Pscheidt
-- Date: 2015-07-27
--

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.04 WHERE lower(module) = 'accommodation';

-------------------------------------------------------
-- sequences ownership
-------------------------------------------------------
ALTER SEQUENCE opuscollege.acc_accommodationresourceseq OWNED BY opuscollege.acc_accommodationresource.id;
ALTER SEQUENCE opuscollege.acc_accommodationfeeseq OWNED BY opuscollege.acc_accommodationfee.accommodationfeeid;
ALTER SEQUENCE opuscollege.acc_blockseq OWNED BY opuscollege.acc_block.id;
ALTER SEQUENCE opuscollege.acc_hostelseq OWNED BY opuscollege.acc_hostel.id;
ALTER SEQUENCE opuscollege.acc_hosteltypeseq OWNED BY opuscollege.acc_hosteltype.id;
ALTER SEQUENCE opuscollege.acc_roomtypeseq OWNED BY opuscollege.acc_roomtype.id;
ALTER SEQUENCE opuscollege.acc_roomseq OWNED BY opuscollege.acc_room.id;
ALTER SEQUENCE opuscollege.acc_studentaccommodationresourceseq OWNED BY opuscollege.acc_studentaccommodationresource.id;
ALTER SEQUENCE opuscollege.acc_studentaccommodationseq OWNED BY opuscollege.acc_studentaccommodation.id;

-- Set all sequence values to the correct values
SELECT SETVAL('opuscollege.acc_accommodationfeeseq', COALESCE(MAX(accommodationfeeid), 1) ) FROM opuscollege.acc_accommodationfee;
SELECT SETVAL('opuscollege.acc_accommodationresourceseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_accommodationresource;
SELECT SETVAL('opuscollege.acc_blockseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_block;
SELECT SETVAL('opuscollege.acc_hostelseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_hostel;
SELECT SETVAL('opuscollege.acc_hosteltypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_hosteltype;
SELECT SETVAL('opuscollege.acc_roomseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_room;
SELECT SETVAL('opuscollege.acc_roomtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_roomtype;
SELECT SETVAL('opuscollege.acc_studentaccommodationresourceseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_studentaccommodationresource;
SELECT SETVAL('opuscollege.acc_studentaccommodationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.acc_studentaccommodation;
