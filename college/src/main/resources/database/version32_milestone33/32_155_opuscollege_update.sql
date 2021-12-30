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

-- Opus College (c) UCI - Monique in het Veld, February 2012
--
-- KERNEL opuscollege
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.56);

-------------------------------------------------------
-- table studentbalance_hist
-------------------------------------------------------
CREATE TABLE audit.studentbalance_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    writewho character varying NOT NULL,
    writewhen timestamp without time zone NOT NULL DEFAULT now(),    
    id INTEGER NOT NULL,
    studentId INTEGER NOT NULL DEFAULT 0,
    feeId INTEGER NOT NULL DEFAULT 0,
    studyPlanCardinalTimeUnitId INTEGER NOT NULL DEFAULT 0,
    studyPlanDetailId INTEGER NOT NULL DEFAULT 0,
    academicYearId INTEGER NOT NULL DEFAULT 0,
    exemption character(1) NOT NULL DEFAULT 'N',
    --
    PRIMARY KEY(id)
);
ALTER TABLE audit.studentbalance_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.studentbalance_hist TO postgres;

-------------------------------------------------------
-- table financialTransaction
-------------------------------------------------------
ALTER TABLE opuscollege.financialTransaction ADD COLUMN writeWho VARCHAR NOT NULL DEFAULT 'opuscollege';
ALTER TABLE opuscollege.financialTransaction ADD COLUMN writeWhen TIMESTAMP NOT NULL DEFAULT now();

-------------------------------------------------------
-- table financialTransaction_hist
-------------------------------------------------------
CREATE TABLE audit.financialTransaction_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    writewho character varying NOT NULL,
    id INTEGER NOT NULL,
    transactionTypeId INTEGER NOT NULL,      
    financialRequestId VARCHAR NOT NULL,     
    requestId VARCHAR NOT NULL,          
    statusCode INTEGER NOT NULL,         
    errorCode INTEGER NOT NULL,          
    studentId INTEGER NOT NULL,      
    nationalRegistrationNumber VARCHAR NOT NULL,  
    academicYearId INTEGER, 
    timestampProcessed timestamp without time zone,
    amount numeric(10,2) NOT NULL,      
    name VARCHAR NOT NULL, 
    cell VARCHAR, 
    requestString VARCHAR NOT NULL,   
    processedToStudentbalance character(1) NOT NULL DEFAULT 'N'::bpchar, 
    errorReportedToFinancialBankrequest character(1) NOT NULL DEFAULT 'N'::bpchar,
    PRIMARY KEY(id)
);
ALTER TABLE audit.financialTransaction_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.financialTransaction_hist TO postgres;


-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
UPDATE opuscollege.lookuptable set tablename = 'functionlevel' where tablename = 'functionLevel';

-------------------------------------------------------
-- tables audit schema -> no primary key
-------------------------------------------------------
alter TABLE audit.financialTransaction_hist DROP CONSTRAINT financialtransaction_hist_pkey;
alter TABLE audit.studentBalance_hist DROP CONSTRAINT  studentbalance_hist_pkey;

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------

UPDATE opuscollege.lookuptable set active='N' where lower(tablename) = 'fee_feecategory';