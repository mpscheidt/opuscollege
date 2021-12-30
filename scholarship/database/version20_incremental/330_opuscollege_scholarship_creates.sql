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
 * The Original Code is Opus-College scholarship module code.
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

-- Opus College (c) UCI - March 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 
-- Author: Stelio Macumbe

------------------------------------------------------
-- table sch_student
-------------------------------------------------------

CREATE TABLE opuscollege.sch_student (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_studentSeq'),
    studentid INTEGER NOT NULL ,
	bankcode VARCHAR,
    accountnr VARCHAR,
	accountactivated BOOLEAN default false ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writewho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writewhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_student OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_student TO postgres;



------------------------------------------------------
-- table sch_scholarshipType
-------------------------------------------------------

CREATE TABLE opuscollege.sch_scholarshipType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_scholarshipTypeSeq'),
    description VARCHAR NOT NULL,
	code VARCHAR NOT NULL,
	lang CHAR(2)  NOT NULL ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)

    
);
ALTER TABLE opuscollege.sch_scholarshipType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_scholarshipType TO postgres;


------------------------------------------------------
-- table sch_scholarshipTypeYear
-------------------------------------------------------

CREATE TABLE opuscollege.sch_scholarshipTypeYear (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_scholarshipTypeYearSeq'),
    scholarshiptypecode VARCHAR NOT NULL,
    sponsorid INTEGER NOT NULL ,
	amount VARCHAR , 
	academicyear VARCHAR NOT NULL ,
    housingcosts VARCHAR ,    
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_scholarshipTypeYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_scholarshipTypeYear TO postgres;


------------------------------------------------------
-- table sch_scholarship
-------------------------------------------------------

CREATE TABLE opuscollege.sch_scholarship (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_studentSeq'),
	schStudentid INTEGER NOT NULL ,
    scholarshiptypeyearappliedforid INTEGER NOT NULL,	
	scholarshiptypeyeargrantedid INTEGER ,
	decisioncriteriacode VARCHAR NULL ,
	sponsorid INTEGER,
    scholarshipamount NUMERIC(10,2) ,
	decisionstatus VARCHAR ,
    observation VARCHAR ,
    validfrom DATE ,
	validuntil DATE ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_scholarship OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_scholarship TO postgres;


------------------------------------------------------
-- table decisionCriteria
-------------------------------------------------------

CREATE TABLE opuscollege.sch_decisionCriteria (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_decisionCriteriaSeq'),
    --letter CHAR(1),
	description VARCHAR ,
	code VARCHAR NOT NULL ,
	lang CHAR(2) NOT NULL ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_decisionCriteria OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_decisionCriteria TO postgres;



------------------------------------------------------
-- table sch_sponsor
-------------------------------------------------------

CREATE TABLE opuscollege.sch_sponsor (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_sponsorSeq'),
    code VARCHAR ,
    name VARCHAR ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
	--
	PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_sponsor OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_sponsor TO postgres;



------------------------------------------------------
-- table complaint
-------------------------------------------------------

CREATE TABLE opuscollege.sch_complaint (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_complaintSeq'),
   -- studentid INTEGER NOT NULL,
	complaintdate DATE ,
	reason VARCHAR NOT NULL ,
	result CHAR(2) ,
    complaintstatuscode VARCHAR NOT NULL ,
	scholarshipid INTEGER NOT NULL ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
	--
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_complaint OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_complaint TO postgres;



------------------------------------------------------
-- table complaintStatus
-------------------------------------------------------

CREATE TABLE opuscollege.sch_complaintStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_complaintStatusSeq'),
    description VARCHAR,
	code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_complaintStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_complaintStatus TO postgres;



------------------------------------------------------
-- table subsidy
-------------------------------------------------------

CREATE TABLE opuscollege.sch_subsidy (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_subsidySeq'),
	studentid integer not null,
 	subsidytypecode VARCHAR NOT NULL,
	sponsorid INTEGER NOT NULL ,
	amount NUMERIC(10,2) ,
    subsidydate DATE ,
	observation VARCHAR , 
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
	--
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_subsidy OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_subsidy TO postgres;


------------------------------------------------------
-- table subsidyType
-------------------------------------------------------

CREATE TABLE opuscollege.sch_subsidyType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_subsidyTypeSeq'),
 	description VARCHAR ,
	code VARCHAR NOT NULL ,
	lang CHAR(2) NOT NULL ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
    
);
ALTER TABLE opuscollege.sch_subsidyType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_subsidyType TO postgres;


------------------------------------------------------
-- table sch_bank
-------------------------------------------------------

CREATE TABLE opuscollege.sch_bank (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_bankSeq'),
    code VARCHAR NOT NULL ,
 	name VARCHAR NOT NULL ,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opusscholarship',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
	--
    PRIMARY KEY(code)
    
);
ALTER TABLE opuscollege.sch_bank OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_bank TO postgres;

