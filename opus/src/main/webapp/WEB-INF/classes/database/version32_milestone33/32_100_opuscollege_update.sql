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

-- Opus College (c) UCI - Janneke Nooitgedagt
--
-- KERNEL opuscollege / MODULE - : privileges
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.45);

-------------------------------------------------------
-- table studyIntensity
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studyIntensitySeq;
ALTER TABLE opuscollege.studyIntensitySeq OWNER TO postgres;

CREATE TABLE opuscollege.studyIntensity (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyIntensitySeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.studyIntensity OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyIntensity TO postgres;

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tablename, lookuptype, active) VALUES ('studyintensity', 'Lookup', 'N');
UPDATE opuscollege.lookuptable SET active = 'N' where lower(tablename) = 'progressstatus';

-------------------------------------------------------
-- table studyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.studyGradeType ADD COLUMN studyIntensityCode character varying;
-- set default value
UPDATE opuscollege.studyGradeType SET studyIntensityCode = 'F';

ALTER TABLE opuscollege.studygradetype
    ADD CONSTRAINT study_gradetype_studyform_studytime_studyintensity_academicyear_key UNIQUE (studyid, gradetypecode, studyformcode, studytimecode, studyintensitycode, currentacademicyearid);
ALTER TABLE opuscollege.studygradetype DROP CONSTRAINT study_gradetype_studyform_studytime_academicyear_key;


-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('REVERSE_PROGRESS_STATUS','en','Y','Reverse progress statuses in cntd registration');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','REVERSE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','REVERSE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','REVERSE_PROGRESS_STATUS');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL');

-- clean up databases:
DROP SEQUENCE IF EXISTS opuscollege.studyyearacademicyearseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectblockstudyyearseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.htmlfieldseq CASCADE;

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
DELETE FROM opuscollege.opusprivilege where code = 'TRANSFER_SUBJECTS';
