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
 ******************************************************************************/

-- 
-- Author: Stelio Macumbe
-- Date:   2013-01-15
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('college','A','Y',4.02);

-------------------------------------------------------
-- table opuscollege.OpusUser
-------------------------------------------------------
ALTER TABLE opuscollege.OpusUser ALTER COLUMN lang TYPE character varying(5);
CREATE INDEX lower_userName_idx ON opuscollege.OpusUser ((lower(userName)));

-------------------------------------------------------
-- table OpusUserPrivilege
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.opusUserPrivilegeSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.OpusUserPrivilege;

CREATE SEQUENCE opuscollege.opusUserPrivilegeSeq;
ALTER TABLE opuscollege.opusUserPrivilegeSeq OWNER TO postgres;

CREATE TABLE opuscollege.OpusUserPrivilege (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.opusUserPrivilegeSeq'),
    userId INTEGER NOT NULL,
    privilegeCode VARCHAR NOT NULL ,
    organizationalUnitId INTEGER NOT NULL,
    validFrom date,
    validThrough date,
    active CHAR(1) NOT NULL DEFAULT 'Y',    
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    
    PRIMARY KEY(id),
    UNIQUE(userId, privilegeCode, organizationalUnitId),
    FOREIGN KEY(organizationalUnitId) REFERENCES opuscollege.OrganizationalUnit(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES opuscollege.OpusUser(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (validThrough >= validFrom)
    
);
ALTER TABLE opuscollege.opusUserPrivilege OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.opusUserPrivilege TO postgres;

-------------------------------------------------------
-- table OpusUserPrivilege
-------------------------------------------------------

DROP TABLE IF EXISTS audit.OpusUserPrivilege_hist;

CREATE TABLE audit.OpusUserPrivilege_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    id INTEGER,
    userId INTEGER ,
    privilegeCode VARCHAR ,
    organizationalUnitId INTEGER ,
    validFrom date,
    validThrough date,
    active CHAR(1) ,
    writeWho VARCHAR NOT NULL ,
    writeWhen TIMESTAMP NOT NULL DEFAULT now()
    
);
ALTER TABLE audit.opusUserPrivilege_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.opusUserPrivilege_hist TO postgres;
