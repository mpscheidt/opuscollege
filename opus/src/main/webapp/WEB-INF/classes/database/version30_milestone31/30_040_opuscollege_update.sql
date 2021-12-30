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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.08);

-------------------------------------------------------
-- add sequence thesis
-------------------------------------------------------

CREATE SEQUENCE opuscollege.thesisSeq;

-------------------------------------------------------
-- TABLE thesis
-------------------------------------------------------

CREATE TABLE opuscollege.thesis (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.thesisSeq'), 
    thesisCode VARCHAR NOT NULL, 
    thesisDescription VARCHAR,
    thesisContentDescription VARCHAR,
    studyplanid int4 NOT NULL,
    creditAmount INTEGER NOT NULL,
    BRsApplyingToThesis VARCHAR,
    BRsPassingThesis VARCHAR,
    keywords VARCHAR,
    researchers VARCHAR,
    supervisors VARCHAR,
    publications VARCHAR,
    readingCommittee VARCHAR,
    defenseCommittee VARCHAR,
    statusOfClearness VARCHAR,
    thesisStatusCode VARCHAR NOT NULL, 
    thesisStatusDate DATE NOT NULL DEFAULT now(),
    startAcademicYearId INTEGER,
    affiliationFee numeric(10,2) NOT NULL DEFAULT 0.00,
    research VARCHAR,
    nonRelatedPublications VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),

    --
    PRIMARY KEY(id),
    UNIQUE(thesisCode)
);
ALTER TABLE opuscollege.thesis OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.thesis TO postgres;

-------------------------------------------------------
-- add sequence thesisStatus
-------------------------------------------------------

CREATE SEQUENCE opuscollege.thesisStatusSeq;

-------------------------------------------------------
-- TABLE thesisStatus
-------------------------------------------------------
CREATE TABLE opuscollege.thesisStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.thesisStatusSeq'),
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
ALTER TABLE opuscollege.thesisStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.thesisStatus TO postgres;

-------------------------------------------------------
-- inserts on TABLE thesis: these are examples
-------------------------------------------------------
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','1','admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','2','proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','3','thesis accepted');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','1','admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','2','proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','3','thesis accepted');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('nl','1','verzoek om toelating');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('nl','2','voorstel geaccepteerd');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('nl','3','proefschrift geaccepteerd');

-------------------------------------------------------
-- add thesisStatus as lookup table
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('thesisStatus', 'Lookup', 'Y');



