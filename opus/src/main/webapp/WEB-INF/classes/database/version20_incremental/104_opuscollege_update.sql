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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.04);

------------------------------------------------------
-- table markEvaluation
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.markEvaluationSeq CASCADE;

CREATE SEQUENCE opuscollege.markEvaluationSeq;
ALTER TABLE opuscollege.markEvaluationSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.markEvaluation CASCADE;

CREATE TABLE opuscollege.markEvaluation (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.markEvaluationSeq'),
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
ALTER TABLE opuscollege.markEvaluation OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.markEvaluation TO postgres;

DELETE FROM opuscollege.markEvaluation;

-- EN
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','A', '26');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','B', '25');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','C', '24');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','D', '23');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','E', '22');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','F', '21');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','G', '20');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','H', '19');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','I', '18');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','J', '17');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','K', '16');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','L', '15');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','M', '14');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','N', '13');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','O', '12');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','P', '11');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','Q', '10');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','R', '9');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','S', '8');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','T', '7');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','U', '6');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','V', '5');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','W', '4');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','X', '3');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','Y', '2');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('en','Z', '1');

-- PT
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','A', '26');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','B', '25');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','C', '24');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','D', '23');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','E', '22');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','F', '21');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','G', '20');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','H', '19');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','I', '18');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','J', '17');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','K', '16');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','L', '15');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','M', '14');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','N', '13');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','O', '12');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','P', '11');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','Q', '10');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','R', '9');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','S', '8');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','T', '7');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','U', '6');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','V', '5');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','W', '4');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','X', '3');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','Y', '2');
INSERT INTO opuscollege.markEvaluation (lang,code,description) VALUES('pt','Z', '1');

-------------------------------------------------------
-- TABLE examination
-------------------------------------------------------
ALTER TABLE opuscollege.examination DROP column minimumMark;
ALTER TABLE opuscollege.examination DROP column maximumMark;

-------------------------------------------------------
-- TABLE subject
-------------------------------------------------------
ALTER TABLE opuscollege.subject DROP column creditAmountPercTheory;
ALTER TABLE opuscollege.subject DROP column creditAmountPercPractice;

-------------------------------------------------------
-- TABLE examinationResult
-------------------------------------------------------
ALTER TABLE opuscollege.examinationResult DROP column finalAttempt;

-------------------------------------------------------
-- TABLE subjectResult
-------------------------------------------------------
ALTER TABLE opuscollege.subjectResult DROP column finalAttempt;
ALTER TABLE opuscollege.subjectResult DROP column attemptNr;

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------
ALTER TABLE opuscollege.study ADD column minimumMarkSubject VARCHAR;
ALTER TABLE opuscollege.study ADD column maximumMarkSubject VARCHAR;
ALTER TABLE opuscollege.study ADD column BRsPassingSubject VARCHAR;

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
DELETE FROM opuscollege.timeUnit;

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','1','semester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','2','semester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','3','trimester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','4','trimester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','5','trimester 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','6','semester 1 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','7','semester 1 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','8','semester 2 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','9','semester 2 - block 2');

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','1','semestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','2','semestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','3','trimestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','4','trimestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','5','trimestre 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','6','semestre 1 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','7','semestre 1 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','8','semestre 2 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','9','semestre 2 - block 2');
