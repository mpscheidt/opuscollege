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
 * The Original Code is Opus-College unza module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'cbu';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('cbu','A','Y',3.16);

-------------------------------------------------------
-- table financialTransactionTmp
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.financialTransactionTmpSeq CASCADE;
CREATE SEQUENCE opuscollege.financialTransactionTmpSeq;

DROP TABLE IF EXISTS opuscollege.financialTransactionTmp;

CREATE TABLE opuscollege.financialTransactionTmp (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.financialTransactionTmpSeq'),
    transactionTypeId character(5) NOT NULL DEFAULT ''::bpchar,      
    financialRequestId VARCHAR NOT NULL,     
    studentId INTEGER NOT NULL,      
    timestampProcessed timestamp without time zone,
    nationalRegistrationNumber VARCHAR NOT NULL,  
    amount numeric(10,2) NOT NULL,      
    name VARCHAR NOT NULL, 
    requestString VARCHAR NOT NULL,   
    processedToFinancialTransaction character(1) NOT NULL DEFAULT 'N'::bpchar, 
    writeWho VARCHAR NOT NULL DEFAULT 'cbu',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.financialTransactionTmp OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.financialTransactionTmp TO postgres;

-------------------------------------------------------
-- table studentBalanceTmp
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.studentBalanceTmpSeq CASCADE;
CREATE SEQUENCE opuscollege.studentBalanceTmpSeq;
ALTER TABLE opuscollege.studentBalanceTmpSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.studentBalanceTmp;

CREATE TABLE opuscollege.studentBalanceTmp (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentBalanceTmpSeq'),
    studentId INTEGER NOT NULL DEFAULT 0,
    financialRequestId VARCHAR NOT NULL,     
    balanceBefore numeric(10,2) NOT NULL,      
    balanceAfter numeric(10,2) NOT NULL,      
    timestampProcessed timestamp without time zone,
    processedToStudentBalance character(1) NOT NULL DEFAULT 'N'::bpchar, 
    writeWho VARCHAR NOT NULL DEFAULT 'cbu',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentBalanceTmp OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.studentBalanceTmp TO postgres;


-------------------------------------------------------
-- table financialTransactionTmp_hist
-------------------------------------------------------
DROP TABLE IF EXISTS audit.financialTransactionTmp_hist;

CREATE TABLE audit.financialTransactionTmp_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    writewho character varying NOT NULL,
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    id INTEGER NOT NULL,
    transactionTypeId character(5) NOT NULL DEFAULT ''::bpchar,      
    financialRequestId VARCHAR NOT NULL,     
    timestampProcessed timestamp without time zone,
    studentId INTEGER NOT NULL,      
    nationalRegistrationNumber VARCHAR NOT NULL,  
    amount numeric(10,2) NOT NULL,      
    name VARCHAR NOT NULL, 
    requestString VARCHAR NOT NULL,   
    processedToFinancialTransaction character(1) NOT NULL DEFAULT 'N'::bpchar 
);
ALTER TABLE audit.financialTransactionTmp_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.financialTransactionTmp_hist TO postgres;

-------------------------------------------------------
-- table studentBalanceTmp_hist
-------------------------------------------------------
DROP TABLE IF EXISTS audit.studentBalanceTmp_hist;

CREATE TABLE audit.studentBalanceTmp_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    writewho character varying NOT NULL,
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    id INTEGER NOT NULL,
    studentId INTEGER NOT NULL DEFAULT 0,
    financialRequestId VARCHAR NOT NULL,     
    balanceBefore numeric(10,2) NOT NULL,      
    balanceAfter numeric(10,2) NOT NULL,      
    timestampProcessed timestamp without time zone,
    processedToStudentBalance character(1) NOT NULL DEFAULT 'N'::bpchar

);
ALTER TABLE audit.studentBalanceTmp_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.studentBalanceTmp_hist TO postgres;

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'administratorMailAddress','admin@cbu.ac.zm');
    
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'numberOfSubjectsToCountForStudyPlanMark','0');
    
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointRelativesCreditMale';

DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointRelativesCreditMale';

DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointRelativesCreditMale';

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointCreditFemale','2');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointCreditMale','1');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointCreditFemale','0.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointCreditMale','1');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointCreditFemale','1');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointCreditMale','3');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointRelativesCreditFemale','2.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointRelativesCreditMale','1.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointRelativesCreditFemale','0');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointRelativesCreditMale','0.5');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointRelativesCreditFemale','0');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointRelativesCreditMale','2');

