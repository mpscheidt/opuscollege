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

-- Opus College (c) CBU - Ben Mazyopa
--
-- KERNEL opuscollege / MODULE accommodation
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'accommodation';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('accommodation','A','Y',3.15);

-------------------------------------------------------
-- table acc_accommodationfee
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.acc_accommodationfeeseq CASCADE;
CREATE SEQUENCE opuscollege.acc_accommodationfeeseq;
ALTER TABLE opuscollege.acc_accommodationfeeseq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.acc_accommodationfee CASCADE;
----------------------------------------------------------------------------------------------------------------
--Table acc_accommodationfee: table which stores hostel and room charges for each academic year
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_accommodationfee (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_accommodationfeeseq'), 
    amountdue NUMERIC(10,2) NOT NULL,
    description VARCHAR NOT NULL,
    hostelid INTEGER NOT NULL,
    blockid INTEGER DEFAULT 0,
    roomid INTEGER NOT NULL DEFAULT 0,
    academicyearid INTEGER NOT NULL DEFAULT 0,
    deadline DATE,
    numberofinstallments INTEGER NOT NULL DEFAULT 0,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_accommodationfee OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_accommodationfee TO postgres;
