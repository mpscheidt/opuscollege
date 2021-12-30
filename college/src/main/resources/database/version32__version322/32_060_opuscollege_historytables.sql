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

-- Opus College (c) UCI - Markus
--
-- KERNEL opuscollege / MODULE - : history tables
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.38);


-------------------------------------------------------
-- Schema: audit
-------------------------------------------------------

-- DROP SCHEMA audit;

CREATE SCHEMA audit
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA audit TO postgres;


-------------------------------------------------------
-- examinationResultHistory moves to audit schema
-------------------------------------------------------
DROP TABLE opuscollege.examinationResultHistory;

-------------------------------------------------------
-- Table: audit.examinationResult_Hist
-------------------------------------------------------

-- DROP TABLE audit.examinationResult_Hist;

CREATE TABLE audit.examinationResult_Hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  id integer NOT NULL,
  examinationid integer NOT NULL,
  subjectid integer NOT NULL,
  studyplandetailid integer NOT NULL,
  examinationresultdate date,
  attemptnr integer NOT NULL,
  mark character varying,
  staffmemberid integer NOT NULL,
  active character(1) NOT NULL,
  passed character(1) NOT NULL
);
ALTER TABLE audit.examinationResult_Hist OWNER TO postgres;
GRANT ALL ON TABLE audit.examinationResult_Hist TO postgres;

-------------------------------------------------------
-- Table: audit.subjectresult_hist
-------------------------------------------------------

-- DROP TABLE audit.subjectResult_Hist;

CREATE TABLE audit.subjectResult_Hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  id integer NOT NULL,
  subjectid integer NOT NULL,
  studyplandetailid integer NOT NULL,
  subjectresultdate date,
  mark character varying,
  staffmemberid integer NOT NULL,
  active character(1) NOT NULL,
  passed character(1) NOT NULL,
  endgradecomment character varying
 );
ALTER TABLE audit.subjectResult_Hist OWNER TO postgres;
GRANT ALL ON TABLE audit.subjectResult_Hist TO postgres;

-------------------------------------------------------
-- Table: audit.testResult_Hist
-------------------------------------------------------

-- DROP TABLE audit.testResult_Hist;

CREATE TABLE audit.testResult_Hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  id integer NOT NULL,
  testid integer NOT NULL,
  examinationid integer NOT NULL,
  studyplandetailid integer NOT NULL,
  testresultdate date,
  attemptnr integer NOT NULL,
  --finalattempt character(1) NOT NULL,
  mark character varying,
  passed character(1) NOT NULL,
  staffmemberid integer NOT NULL,
  --brspassingtest character varying,
  active character(1) NOT NULL
);
ALTER TABLE audit.testResult_Hist OWNER TO postgres;
GRANT ALL ON TABLE audit.testResult_Hist TO postgres;

-------------------------------------------------------
-- Table: audit.cardinalTimeUnitResult_Hist
-------------------------------------------------------

-- DROP TABLE audit.cardinalTimeUnitResult_Hist;

CREATE TABLE audit.cardinalTimeUnitResult_Hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  id integer NOT NULL,
  studyplanid integer NOT NULL DEFAULT 0,
  studyplancardinaltimeunitid integer NOT NULL DEFAULT 0,
  cardinaltimeunitresultdate date,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  passed character(1) NOT NULL DEFAULT 'N'::bpchar,
  mark character varying,
  endgradecomment character varying
);
ALTER TABLE audit.cardinalTimeUnitResult_Hist OWNER TO postgres;
GRANT ALL ON TABLE audit.cardinalTimeUnitResult_Hist TO postgres;

