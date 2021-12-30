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
-- KERNEL opuscollege / MODULE - : applicantCategory
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.40);


-------------------------------------------------------
-- table applicantCategory
-------------------------------------------------------

CREATE SEQUENCE opuscollege.applicantCategorySeq;

CREATE TABLE opuscollege.applicantCategory (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.applicantCategorySeq'),
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
ALTER TABLE opuscollege.applicantCategory OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.applicantCategory TO postgres;


-------------------------------------------------------
-- table studyPlan
-------------------------------------------------------

ALTER TABLE opuscollege.studyplan
   ADD COLUMN applicantCategoryCode character varying;
   
   
-------------------------------------------------------
-- table nationalityGroup
-------------------------------------------------------
  
CREATE SEQUENCE opuscollege.nationalityGroupSeq;

CREATE TABLE opuscollege.nationalityGroup (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.nationalityGroupSeq'),
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
ALTER TABLE opuscollege.nationalityGroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.nationalityGroup TO postgres;
   

-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER TABLE opuscollege.student
   ADD COLUMN nationalityGroupCode character varying;


INSERT INTO opuscollege.lookuptable(tablename, lookuptype) VALUES ('applicantcategory', 'Lookup');
INSERT INTO opuscollege.lookuptable(tablename, lookuptype) VALUES ('nationalitygroup', 'Lookup');

-------------------------------------------------------
-- changes on cutoffpoint admission
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','PROGRESS_ADMISSION_FLOW');

DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC' AND role='finance';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC');

DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'FINALIZE_ADMISSION_FLOW' AND role='finance';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','FINALIZE_ADMISSION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','FINALIZE_ADMISSION_FLOW');

--------------------------------------------------------
-- changes on studyplancardinaltimeunit
--------------------------------------------------------
ALTER TABLE opuscollege.studyplancardinaltimeunit
  ADD COLUMN tuitionwaiver character(1);
UPDATE opuscollege.studyplancardinaltimeunit set tuitionwaiver = 'N';
ALTER TABLE opuscollege.studyplancardinaltimeunit alter column tuitionwaiver set NOT NULL;
ALTER TABLE opuscollege.studyplancardinaltimeunit alter column tuitionwaiver set DEFAULT 'N';