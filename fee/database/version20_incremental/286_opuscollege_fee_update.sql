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
 * The Original Code is Opus-College fee module code.
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
 * ***** END LICENSE BLOCK *****/

-- Opus College (c) UCI - Stelio Alexandre July 2010
--
-- KERNEL opuscollege / MODULE fee
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',3.1);


-------------------------------------------------------
-- sequence feeCategory
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.fee_feeCategorySeq CASCADE;
CREATE SEQUENCE opuscollege.fee_feeCategorySeq;
ALTER TABLE opuscollege.fee_feeCategorySeq OWNER TO postgres;

-------------------------------------------------------
-- table feeCategory
-------------------------------------------------------
CREATE TABLE opuscollege.fee_feeCategory (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_feeCategorySeq'),
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
ALTER TABLE opuscollege.fee_feeCategory OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fee_feeCategory TO postgres;

------------------------------------------------------
-- table feeCategory inserts
-------------------------------------------------------
DELETE FROM opuscollege.fee_feeCategory;

INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','1','Tuition');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','2','Housing / Accomodation');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','3','Examinations');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','4','Medical');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','5','Recreations');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','6','Admission - Initial Application');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','7','Registration');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('en','8','Insurance / Caution');


INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','1','Instrução/Ensino');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','2','Acomodação');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','3','Exames');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','4','Médica');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','5','Recreação');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','6','Ingresso - Matrícula Inicial');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','7','Inscrição');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('pt','8','Seguro');


INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','1','Studiegeld');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','2','Huisvesting');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','3','Examens');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','4','Medisch');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','5','Recreatie');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','6','Inschrijving - 1e aanmelding');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','7','Registratie');
INSERT INTO opuscollege.fee_feeCategory (lang,code,description) VALUES ('nl','8','Verzekeringen');


------------------------------------------------------
-- table lookupTable
---Add new entry fee_feeCategory
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('fee_feeCategory'        , 'Lookup'  , 'Y');

----------
---table tabledependency
----update dependencies
----

INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) 
VALUES ((SELECT id FROM opuscollege.lookuptable WHERE lower(tableName) = lower('fee_feeCategory')), 'fee_feeCategory', 'categoryCode','Y');

------------------------------------------------------
-- table fee_fee
-------------------------------------------------------
ALTER TABLE opuscollege.fee_fee ADD COLUMN categoryCode VARCHAR(4) ;

-- move current values of studyYearId to subjectBlockId:
--UPDATE opuscollege.fee_fee a
--	SET subjectBlockId = (
--		SELECT studyYearId from opuscollege.fee_fee b
--		WHERE a.id = b.id 
--	);

--UPDATE opuscollege.fee_payment a
--	SET subjectBlockId = (
--		SELECT studyYearId from opuscollege.fee_payment b
--		WHERE a.id = b.id 
--	);

	
UPDATE opuscollege.fee_fee a
	SET subjectBlockId = (
		SELECT opuscollege.subjectBlock.id 
		FROM opuscollege.fee_fee b
		INNER JOIN opuscollege.subjectBlock ON subjectBlock.subjectBlockCode = CAST (b.studyYearId AS VARCHAR) 
		INNER JOIN opuscollege.studyYear ON b.studyYearId = studyYear.id
		WHERE b.id = a.id
	)
	WHERE studyYearId <> 0;

UPDATE opuscollege.fee_payment a
	SET subjectBlockId = (
		SELECT opuscollege.subjectBlock.id 
		FROM opuscollege.fee_payment b
		INNER JOIN opuscollege.subjectBlock ON subjectBlock.subjectBlockCode = CAST (b.studyYearId AS VARCHAR) 
		INNER JOIN opuscollege.studyYear ON b.studyYearId = studyYear.id
		WHERE b.id = a.id
	)
	WHERE studyYearId <> 0;


------------------------------------------------------
-- REMOVAL OF STUDYYEAR
-------------------------------------------------------
ALTER TABLE opuscollege.fee_fee DROP COLUMN studyYearId;
ALTER TABLE opuscollege.fee_payment DROP COLUMN studyYearId;

