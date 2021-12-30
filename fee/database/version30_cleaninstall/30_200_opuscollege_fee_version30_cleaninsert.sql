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

-- Opus College (c) UCI - Monique in het Veld March 2009
--
-- KERNEL opuscollege / MODULE fee
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',3.0);

-- Opus College (c) UCI - Monique in het Veld Feb 2008
--
-- KERNEL opuscollege / MODULE fee
-- 

-------------------------------------------------------
-- Sequences
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.fee_feeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.fee_paymentSeq CASCADE;

CREATE SEQUENCE opuscollege.fee_feeSeq;
CREATE SEQUENCE opuscollege.fee_paymentSeq;

ALTER TABLE opuscollege.fee_feeSeq OWNER TO postgres;
ALTER TABLE opuscollege.fee_paymentSeq OWNER TO postgres;

-------------------------------------------------------
-- table fee
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.fee_fee CASCADE;

-------------------------------------------------------
-- table payment
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.fee_payment CASCADE;

-- Opus College (c) UCI - Monique in het Veld Feb 2008
--
-- KERNEL opuscollege / MODULE fee
-- 
-------------------------------------------------------
-- table fee
-------------------------------------------------------
CREATE TABLE opuscollege.fee_fee (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_feeSeq'), 
    feeDue numeric(10,2) NOT NULL DEFAULT 0.00,
    deadline DATE NOT NULL DEFAULT now(),
    subjectBlockId INTEGER NOT NULL DEFAULT 0,
    subjectId INTEGER NOT NULL DEFAULT 0,
    categoryCode VARCHAR(4),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-fees',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.fee_fee OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fee_fee TO postgres;

-------------------------------------------------------
-- table payment
-------------------------------------------------------
CREATE TABLE opuscollege.fee_payment (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_paymentSeq'), 
    payDate DATE NOT NULL DEFAULT now(),
    studentId INTEGER NOT NULL REFERENCES opuscollege.student(studentId) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subjectBlockId INTEGER NOT NULL DEFAULT 0,
    subjectId INTEGER NOT NULL DEFAULT 0,
    sumPaid numeric(10,2) NOT NULL DEFAULT 0.00,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-fees',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.fee_payment OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fee_payment TO postgres;
