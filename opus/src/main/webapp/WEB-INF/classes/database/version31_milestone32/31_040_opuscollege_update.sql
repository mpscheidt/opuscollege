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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.21);

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
--a user can not have different roles for the same organizational unit
ALTER TABLE opuscollege.opususerrole ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalUnitId);
--a user may have same role but in different organizational units
ALTER TABLE opuscollege.opususerrole DROP CONSTRAINT opususerrole_role_key;


-------------------------------------------------------
-- SEQUENCE thesisResultSeq
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.thesisResultSeq CASCADE;
CREATE SEQUENCE opuscollege.thesisResultSeq;
ALTER TABLE opuscollege.thesisResultSeq OWNER TO postgres;

-------------------------------------------------------
-- TABLE thesisResult
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.thesisResult CASCADE;

CREATE TABLE opuscollege.thesisResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.thesisResultSeq'), 
    studyPlanId INTEGER NOT NULL DEFAULT 0,
    thesisResultDate DATE,
	mark VARCHAR,
 	active CHAR(1) NOT NULL DEFAULT 'Y',
	passed CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(studyPlanId)
);
ALTER TABLE opuscollege.thesisResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.thesisResult TO postgres;

