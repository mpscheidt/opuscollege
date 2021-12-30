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

-- Opus College (c) UCI - MoVe March 2009
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',3.0);

-- Opus College (c) UCI -  Feb 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 
-- Author: Celso Nhapulo

-------------------------------------------------------
-- Sequences
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.sch_studentSeq CASCADE; 
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipTypeSeq CASCADE; 
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipTypeYearSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_decisionCriteriaSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_sponsorSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_complaintSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_complaintStatusSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_subsidySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_subsidyTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_bankSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipApplicationSeq CASCADE; 


CREATE SEQUENCE opuscollege.sch_studentSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipTypeSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipApplicationSeq;
CREATE SEQUENCE opuscollege.sch_decisionCriteriaSeq;
CREATE SEQUENCE opuscollege.sch_sponsorSeq;
CREATE SEQUENCE opuscollege.sch_complaintSeq;
CREATE SEQUENCE opuscollege.sch_complaintStatusSeq;
CREATE SEQUENCE opuscollege.sch_subsidySeq;
CREATE SEQUENCE opuscollege.sch_subsidyTypeSeq;
CREATE SEQUENCE opuscollege.sch_bankSeq;


-------------------------------------------------------
-- ownership sequences
-------------------------------------------------------
ALTER TABLE opuscollege.sch_studentSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipApplicationSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_decisionCriteriaSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_sponsorSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_complaintSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_complaintStatusSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_subsidySeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_subsidyTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_bankSeq OWNER TO postgres;

-- Opus College (c) UCI - March 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 
-- Author: Ambrosio Vumo

------------------------------------------------------------------
-- table sch_student
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_student CASCADE;

------------------------------------------------------------------
-- table sch_type 
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_scholarshipType CASCADE;

------------------------------------------------------------------
-- table sch_type_year
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_scholarshipTypeYear CASCADE;
------------------------------------------------------------------
-- table sch_scholarship
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_scholarship  CASCADE;

------------------------------------------------------------------
-- table sch_decisioncriteria
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_decisionCriteria CASCADE;

------------------------------------------------------------------
-- table sch_sponsor
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_sponsor  CASCADE;
------------------------------------------------------------------
-- table sch_complaint
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_complaint  CASCADE;
-- table sch_complaint status
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_complaintStatus  CASCADE;
-- table sch_subsidy
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_subsidy  CASCADE;
-- table sch_subsidytype
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_subsidyType  CASCADE;
-- table sch_bank
------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.sch_bank CASCADE;

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
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_scholarshipSeq'),
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

------------------------------------------------------
-- create CONSTRAINTS
-------------------------------------------------------

ALTER TABLE opuscollege.sch_student 
add CONSTRAINT fk_student
  FOREIGN KEY (studentid)
  REFERENCES opuscollege.student (studentid);

ALTER TABLE opuscollege.sch_student 
add CONSTRAINT fk_bank
  FOREIGN KEY (bankcode)
  REFERENCES opuscollege.sch_bank (code);

--ALTER TABLE opuscollege.sch_scholarshipTypeYear 
--add CONSTRAINT fk_scholarshiptype
--  FOREIGN KEY (scholarshiptypecode)
--  REFERENCES scholarshiptype (code);

ALTER TABLE opuscollege.sch_scholarshipTypeYear 
add CONSTRAINT fk_sponsor
  FOREIGN KEY (sponsorid)
  REFERENCES opuscollege.sch_sponsor (id);

--ALTER TABLE opuscollege.sch_scholarship 
--add CONSTRAINT fk_studentscholarship
--  FOREIGN KEY (schstudentid)
--  REFERENCES opuscollege.sch_student (id);

--ALTER TABLE opuscollege.sch_scholarship 
--add CONSTRAINT fk_decisioncriteria
--  FOREIGN KEY (decisioncriteriacode)
--  REFERENCES opuscollege.sch_decisioncriteria (code);


ALTER TABLE opuscollege.sch_scholarship 
add CONSTRAINT fk_scholarshiptypeyearappliedforid
  FOREIGN KEY (scholarshiptypeyearappliedforid)
  REFERENCES opuscollege.sch_scholarshipTypeYear (id);


--ALTER TABLE opuscollege.sch_scholarship 
--add CONSTRAINT fk_scholarshiptypeyeargrantedid
--  FOREIGN KEY (scholarshiptypeyeargrantedid)
--  REFERENCES opuscollege.sch_scholarshipTypeYear (id);

ALTER TABLE opuscollege.sch_scholarship 
add CONSTRAINT fk_sponsorid
  FOREIGN KEY (sponsorid)
  REFERENCES opuscollege.sch_sponsor (id);

--ALTER TABLE opuscollege.sch_complaint 
--add CONSTRAINT fk_complaintscholarshipid
--  FOREIGN KEY (scholarshipid)
--  REFERENCES opuscollege.sch_scholarship (id);

ALTER TABLE opuscollege.sch_subsidy 
add CONSTRAINT fk_subsidysponsorid
  FOREIGN KEY (sponsorid)
  REFERENCES opuscollege.sch_sponsor (id);

-------------------------------------------------------
-- table sch_scholarshipType
-------------------------------------------------------

DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'housing scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'reduced scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% discount', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'free of fees', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'merit scholarship', 'EN');
-- PT
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'bolsa completa', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'bolsa de alojamento', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'bolsa reduzida', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', 'redu��o 50%', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'insen��o', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'bolsa de m�rito', 'PT');

---------------------------------------------------------
-- sch_decisionCriteria
---------------------------------------------------------

DELETE FROM opuscollege.sch_decisionCriteria;

-- EN
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('ID', 'Insufficient documentation', 'EN');
-- PT
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('ID', 'Insuficiencia de documentos', 'PT');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_sponsor;

INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OE', 'Mozal');

---------------------------------------------------------
-- sch_complaintStatus
---------------------------------------------------------

DELETE FROM opuscollege.sch_complaintStatus;

-- EN
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('RS', 'resolved', 'EN');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('NR', 'not resolved', 'EN');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('OP', 'open', 'EN');

-- PT
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('RS', 'resolvido', 'PT');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('NR', 'n�o resolvido', 'PT');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('OP', 'aberto', 'PT');

-------------------------------------------------------

DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'housing scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'reduced scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% discount', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'free of fees', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'merit scholarship', 'en');
-- PT
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'bolsa completa', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'bolsa de alojamento', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'bolsa reduzida', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', 'redu��o 50%', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'insen��o', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'bolsa de m�rito', 'pt');

-------------------------------------------------------
-- sequences
-------------------------------------------------------


-------------------------------------------------------
-- table sch_scholarship
-------------------------------------------------------
ALTER SEQUENCE opuscollege.sch_scholarshipapplicationseq
   RESTART WITH 1000;

ALTER TABLE opuscollege.sch_scholarship
   ALTER COLUMN id SET DEFAULT nextval('opuscollege.sch_scholarshipapplicationseq'::regclass);
ALTER Table opuscollege.sch_scholarship RENAME TO sch_scholarshipApplication;

-------------------------------------------------------
-- table sch_scholarshipApplication
-------------------------------------------------------
ALTER TABLE opuscollege.sch_scholarshipapplication RENAME scholarshiptypeyearappliedforid  TO scholarshipappliedforid;
ALTER TABLE opuscollege.sch_scholarshipapplication RENAME scholarshiptypeyeargrantedid  TO scholarshipgrantedid;

ALTER TABLE opuscollege.sch_scholarshiptypeyear
   ALTER COLUMN id SET DEFAULT nextval('opuscollege.sch_scholarshipseq'::regclass);
ALTER Table opuscollege.sch_scholarshiptypeyear RENAME TO sch_scholarship;


-------------------------------------------------------
-- table sch_student
-------------------------------------------------------
ALTER TABLE opuscollege.sch_student RENAME id TO scholarshipStudentId;
ALTER TABLE opuscollege.sch_student DROP column bankCode;
ALTER TABLE opuscollege.sch_student ADD COLUMN bankId INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.sch_student RENAME accountNr TO account;

-------------------------------------------------------
-- table sch_complaint
-------------------------------------------------------
ALTER TABLE opuscollege.sch_complaint RENAME scholarshipid TO scholarshipApplicationId;

ALTER TABLE opuscollege.sch_subsidy RENAME studentid TO scholarshipStudentId;
ALTER TABLE opuscollege.sch_scholarshipApplication RENAME schstudentid TO scholarshipStudentId;

ALTER TABLE opuscollege.sch_scholarshipApplication DROP column sponsorid;
ALTER TABLE opuscollege.sch_scholarshipApplication DROP column decisionstatus;

ALTER TABLE opuscollege.sch_scholarshipApplication DROP column scholarshipAmount;

------------------------------------------------------------
-- table sch_scholarship
------------------------------------------------------------

ALTER TABLE opuscollege.sch_scholarship ADD COLUMN tmpamount numeric(10, 2);

update opuscollege.sch_scholarship
set tmpAmount = amount::text::float::numeric 
where amount is not null
and amount != '';

ALTER TABLE opuscollege.sch_scholarship DROP COLUMN amount;

ALTER TABLE opuscollege.sch_scholarship RENAME tmpamount TO amount;

ALTER TABLE opuscollege.sch_scholarship ADD COLUMN tmphousing numeric(10, 2);

update opuscollege.sch_scholarship
set tmphousing = housingcosts::text::float::numeric 
where housingcosts is not null
and housingcosts != '';

update opuscollege.sch_scholarship
set housingcosts = 0.00 
where housingcosts is null;

ALTER TABLE opuscollege.sch_scholarship DROP COLUMN housingcosts;

ALTER TABLE opuscollege.sch_scholarship RENAME tmphousing TO housingcosts;

ALTER TABLE opuscollege.sch_complaint DROP COLUMN result;
ALTER TABLE opuscollege.sch_complaint ADD COLUMN result VARCHAR;


DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'housing scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'reduced scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% discount', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'free of fees', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'merit scholarship', 'en');
-- PT
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'bolsa completa', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'bolsa de alojamento', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'bolsa reduzida', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', 'redu&ccedil;&atilde;o 50%', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'insen&ccedil;&atilde;o', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'bolsa de m&eacute;rito', 'pt');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_sponsor;

INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OE', 'OE');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('MOZ', 'Mozal');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('SID', 'Sida/Sarec');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('GdG', 'Governo de Gaza');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('GdT', 'Governo de Tete');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OTH', 'Outro');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('CTB', 'CTB');

------------------------------------------------------
-- table subsidyType
-------------------------------------------------------

DELETE FROM opuscollege.sch_subsidyType;

-- EN
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('mat', 'Material', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesB', 'Thesis (Bank)', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesA', 'Thesis (Signature)', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesF', 'Thesis (Final)', 'en');
-- PT
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('mat', 'Material', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesB', 'Tese (Banco)', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesA', 'Tese (Assinatura)', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesF', 'Tese (DFin)', 'pt');


---------------------------------------------------------
-- sch_decisionCriteria
---------------------------------------------------------
DELETE FROM opuscollege.sch_decisionCriteria;

-- EN
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('A', 'A', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.13', 'Art.13', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.14,3', 'Art.14,3', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('B', 'B', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('C', 'C', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Dez', 'December', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('E', 'E', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Excep', 'Exceptional', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Extemp', 'Out of time', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('F', 'F', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('G', 'G', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('H', 'H', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('I', 'I', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('J', 'J', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Jul', 'July', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('K', 'K', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L', 'L', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L) Excep', 'L) Exceptional', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('M', 'M', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('N', 'N', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Nov', 'November', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O', 'O', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O) Art.14,3', 'O) Art.14,3', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Out', 'October', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('P', 'P', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Q', 'Q', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('R', 'R', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('S', 'S', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Set', 'September', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('T', 'T', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U', 'U', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U) Art.13', 'U) Art.13', 'en');
-- PT
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('A', 'A', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.13', 'Art.13', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.14,3', 'Art.14,3', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('B', 'B', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('C', 'C', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Dez', 'Dezembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('E', 'E', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Excep', 'Excepcional', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Extemp', 'Extempor&atilde;neo', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('F', 'F', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('G', 'G', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('H', 'H', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('I', 'I', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('J', 'J', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Jul', 'Julho', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('K', 'K', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L', 'L', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L) Excep', 'L) Excepcional', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('M', 'M', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('N', 'N', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Nov', 'Novembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O', 'O', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O) Art.14,3', 'O) Art.14,3', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Out', 'Outubro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('P', 'P', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Q', 'Q', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('R', 'R', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('S', 'S', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Set', 'Setembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('T', 'T', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U', 'U', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U) Art.13', 'U) Art.13', 'pt');

---------------------------------------------------------
-- sch_bank
---------------------------------------------------------

DELETE FROM opuscollege.sch_bank;

INSERT INTO opuscollege.sch_bank(code, name) VALUES ('PB', 'Postbank');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('ABN', 'ABN-AMRO');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('RABO', 'Rabobank');


--
--Inserts lookup tables within the scholarship module in lookupTable table and tableDependencies table 
--
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('sch_complaintStatus' , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('sch_decisionCriteria', 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('sch_scholarshipType' , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('sch_subsidyType'     , 'Lookup'  , 'Y');

INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (44 , 'sch_complaint'           , 'complaintstatuscode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (45 , 'sch_scholarship'         , 'decisioncriteriacode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (46 , 'sch_scholarshipTypeYear' , 'scholarshiptypecode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (47 , 'sch_subsidyType'         , 'subsidytypecode'                      , 'Y');


-- error in dependency of decisioncriteriacode - not sch_scholarship but sch_decisionCriteria
UPDATE opuscollege.tableDependency set dependentTable = 'sch_decisionCriteria'
WHERE lookupTableId = 45
AND dependentTable = 'sch_scholarship' 
AND  dependentTableColumn = 'decisioncriteriacode';


-- OPTIONAL SCRIPT: if the column academicYearId already exists, skip this script.

ALTER TABLE opuscollege.sch_scholarship ADD column academicYearId INTEGER;

UPDATE opuscollege.sch_scholarship 
SET academicYearId = 
    (SELECT id from opuscollege.academicYear 
        WHERE opuscollege.academicYear.description = opuscollege.sch_scholarship.academicYear);

ALTER TABLE opuscollege.sch_scholarship DROP column academicYear;  
