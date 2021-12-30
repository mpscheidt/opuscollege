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

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.09);

-------------------------------------------------------
-- add sequence studyPlanStatus
-------------------------------------------------------

CREATE SEQUENCE opuscollege.studyPlanStatusSeq;


-------------------------------------------------------
-- TABLE studyPlanStatus
-------------------------------------------------------
CREATE TABLE opuscollege.studyPlanStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyPlanStatusSeq'),
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
ALTER TABLE opuscollege.studyPlanStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyPlanStatus TO postgres;

-------------------------------------------------------
-- add studyPlanStatus as lookup table
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyPlanStatus', 'Lookup', 'Y');

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
ALTER TABLE opuscollege.studyplan ADD COLUMN studyplanstatuscode varchar;

-------------------------------------------------------
-- table studyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.studyGradeType ADD COLUMN BRsPassingSubject VARCHAR;


-------------------------------------------------------
-- table subject
-------------------------------------------------------
ALTER TABLE opuscollege.subject ALTER freeChoiceOption SET DEFAULT 'N';
UPDATE opuscollege.subject SET freeChoiceOption = 'N';

-------------------------------------------------------
-- table subjectBlock
-------------------------------------------------------
ALTER TABLE opuscollege.subjectBlock DROP COLUMN creditAmountOverall;
ALTER TABLE opuscollege.subjectBlock DROP COLUMN creditAmountPercCompulsory;
ALTER TABLE opuscollege.subjectBlock DROP COLUMN creditAmountPercCompulsoryFromList;
ALTER TABLE opuscollege.subjectBlock DROP COLUMN creditAmountPercFreechoice;



