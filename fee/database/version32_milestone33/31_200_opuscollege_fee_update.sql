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

-- Opus College (c) UCI - Monique in het Veld 
--
-- KERNEL opuscollege / MODULE fee
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',3.12);

-------------------------------------------------------
-- table fee_fee
-------------------------------------------------------

ALTER TABLE opuscollege.fee_fee add column subjectBlockStudyGradeTypeId integer;
UPDATE opuscollege.fee_fee set subjectBlockStudyGradeTypeId = 0;
ALTER TABLE opuscollege.fee_fee alter column subjectBlockStudyGradeTypeId set not null;
ALTER TABLE opuscollege.fee_fee alter column subjectBlockStudyGradeTypeId set default 0;

ALTER TABLE opuscollege.fee_fee add column subjectStudyGradeTypeId integer;
UPDATE opuscollege.fee_fee set subjectStudyGradeTypeId = 0;
ALTER TABLE opuscollege.fee_fee alter column subjectStudyGradeTypeId set not null;
ALTER TABLE opuscollege.fee_fee alter column subjectStudyGradeTypeId set default 0;

ALTER TABLE opuscollege.fee_fee add column studyGradeTypeId integer;
UPDATE opuscollege.fee_fee set studyGradeTypeId = 0;
ALTER TABLE opuscollege.fee_fee alter column studyGradeTypeId set not null;
ALTER TABLE opuscollege.fee_fee alter column studyGradeTypeId set default 0;

ALTER TABLE opuscollege.fee_fee add column academicYearId integer;
UPDATE opuscollege.fee_fee set academicYearId = 0;
ALTER TABLE opuscollege.fee_fee alter column academicYearId set not null;
ALTER TABLE opuscollege.fee_fee alter column academicYearId set default 0;

ALTER TABLE opuscollege.fee_fee add column numberOfInstallments integer;
UPDATE opuscollege.fee_fee set numberOfInstallments = 0;
ALTER TABLE opuscollege.fee_fee alter column numberOfInstallments set not null;

ALTER TABLE opuscollege.fee_fee add column tuitionWaiverDiscountPercentage integer;
UPDATE opuscollege.fee_fee set tuitionWaiverDiscountPercentage = 0;
ALTER TABLE opuscollege.fee_fee alter column tuitionWaiverDiscountPercentage set not null;

ALTER TABLE opuscollege.fee_fee add column fulltimeStudentDiscountPercentage integer;
UPDATE opuscollege.fee_fee set fulltimeStudentDiscountPercentage = 0;
ALTER TABLE opuscollege.fee_fee alter column fulltimeStudentDiscountPercentage set not null;

ALTER TABLE opuscollege.fee_fee add column localStudentDiscountPercentage integer;
UPDATE opuscollege.fee_fee set localStudentDiscountPercentage = 0;
ALTER TABLE opuscollege.fee_fee alter column localStudentDiscountPercentage set not null;

ALTER TABLE opuscollege.fee_fee add column continuedRegistrationDiscountPercentage integer;
UPDATE opuscollege.fee_fee set continuedRegistrationDiscountPercentage = 0;
ALTER TABLE opuscollege.fee_fee alter column continuedRegistrationDiscountPercentage set not null;

ALTER TABLE opuscollege.fee_fee add column postgraduateDiscountPercentage integer;
UPDATE opuscollege.fee_fee set postgraduateDiscountPercentage = 0;
ALTER TABLE opuscollege.fee_fee alter column postgraduateDiscountPercentage set not null;
-- Conversion
INSERT INTO opuscollege.fee_fee (feedue, deadline, active, writewho, writewhen, categorycode, subjectBlockStudyGradeTypeId, subjectStudyGradeTypeId, studyGradeTypeId, academicYearId, numberOfInstallments, tuitionWaiverDiscountPercentage, fulltimeStudentDiscountPercentage, localStudentDiscountPercentage, continuedRegistrationDiscountPercentage, postgraduateDiscountPercentage)
	SELECT fee.feedue, fee.deadline, fee.active, fee.writewho, fee.writewhen, fee.categorycode, sbsg.id, fee.subjectStudyGradeTypeId, fee.studyGradeTypeId, fee.academicYearId, fee.numberOfInstallments, fee.tuitionWaiverDiscountPercentage, fee.fulltimeStudentDiscountPercentage, fee.localStudentDiscountPercentage, fee.continuedRegistrationDiscountPercentage, fee.postgraduateDiscountPercentage
	 FROM opuscollege.subjectblockstudygradetype sbsg
	  INNER JOIN opuscollege.fee_fee fee ON fee.subjectblockid = sbsg.subjectblockid;

INSERT INTO opuscollege.fee_fee (feedue, deadline, active, writewho, writewhen, categorycode, subjectBlockStudyGradeTypeId, subjectStudyGradeTypeId, studyGradeTypeId, academicYearId, numberOfInstallments, tuitionWaiverDiscountPercentage, fulltimeStudentDiscountPercentage, localStudentDiscountPercentage, continuedRegistrationDiscountPercentage, postgraduateDiscountPercentage)
	SELECT fee.feedue, fee.deadline, fee.active, fee.writewho, fee.writewhen, fee.categorycode, fee.subjectBlockStudyGradeTypeId, ssg.id, fee.studyGradeTypeId, fee.academicYearId, fee.numberOfInstallments, fee.tuitionWaiverDiscountPercentage, fee.fulltimeStudentDiscountPercentage, fee.localStudentDiscountPercentage, fee.continuedRegistrationDiscountPercentage, fee.postgraduateDiscountPercentage
	 FROM opuscollege.subjectstudygradetype ssg
	  INNER JOIN opuscollege.fee_fee fee ON fee.subjectid = ssg.subjectid;

-- studyyearid is  currently removed from fee_fee table, conversion can not be done
-- INSERT INTO opuscollege.fee_fee (feedue, deadline, studyyearid, subjectblockid, subjectid, active, writewho, writewhen, categorycode, subjectBlockStudyGradeTypeId, subjectStudyGradeTypeId, studyGradeTypeId, academicYearId, numberOfInstallments, tuitionWaiverDiscountPercentage, fulltimeStudentDiscountPercentage, localStudentDiscountPercentage, continuedRegistrationDiscountPercentage, postgraduateDiscountPercentage)
--	SELECT fee.feedue, fee.deadline, fee.studyyearid, fee.subjectblockid, fee.subjectid, fee.active, fee.writewho, fee.writewhen, fee.categorycode, fee.subjectBlockStudyGradeTypeId, fee.subjectStudyGradeTypeId, sy.studygradetypeid, fee.academicYearId, fee.numberOfInstallments, fee.tuitionWaiverDiscountPercentage, fee.fulltimeStudentDiscountPercentage, fee.localStudentDiscountPercentage, fee.continuedRegistrationDiscountPercentage, fee.postgraduateDiscountPercentage
--	 FROM opuscollege.studyyear sy
--	  INNER JOIN opuscollege.fee_fee fee ON fee.studyyearid = sy.id;
DELETE FROM opuscollege.fee_fee where fee_fee.subjectBlockStudyGradeTypeId = 0 AND fee_fee.subjectStudyGradeTypeId = 0 AND fee_fee.studyGradeTypeId = 0 AND fee_fee.academicYearId = 0;
ALTER TABLE opuscollege.fee_fee drop column subjectId;
ALTER TABLE opuscollege.fee_fee drop column subjectBlockId;
-------------------------------------------------------
-- table fee_payment
-------------------------------------------------------
ALTER TABLE opuscollege.fee_payment add column feeId integer;
UPDATE opuscollege.fee_payment set feeId = 0;
ALTER TABLE opuscollege.fee_payment alter column feeId set not null;

ALTER TABLE opuscollege.fee_payment add column studentBalanceId integer;
UPDATE opuscollege.fee_payment set studentBalanceId = 0;
ALTER TABLE opuscollege.fee_payment alter column studentBalanceId set not null;

ALTER TABLE opuscollege.fee_payment add column installmentNumber integer;
UPDATE opuscollege.fee_payment set installmentNumber = 0;
ALTER TABLE opuscollege.fee_payment alter column installmentNumber set not null;
ALTER TABLE opuscollege.fee_payment alter column installmentNumber set default 0;
ALTER TABLE opuscollege.fee_payment alter column studyPlanDetailId set default 0;
ALTER TABLE opuscollege.fee_payment drop constraint fee_payment_studyplandetailid_fkey;
-- First conversion of data has to be done
--ALTER TABLE opuscollege.fee_payment add constraint fee_payment_fee_feeid_fkey FOREIGN KEY (feeid)
--      REFERENCES opuscollege.fee_fee (id) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;
--ALTER TABLE opuscollege.fee_payment add constraint fee_payment_studentbalanceid_fkey FOREIGN KEY (studentbalanceid)
--      REFERENCES opuscollege.studentbalance (id) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;
      
-- Conversion, Must be adjusted for converted student balance table
-- INSERT INTO opuscollege.fee_payment (paydate, studentid, studyplandetailid, sumpaid, active, writewho, writewhen, feeid)
--	SELECT payment.paydate, payment.studentid, payment.studyplandetailid, payment.sumpaid, payment.active, payment.writewho, payment.writewhen, fee.id
--	 FROM opuscollege.fee_fee fee
--	  INNER JOIN opuscollege.fee_payment payment ON payment.feeid = fee.id;
---------------------------------------------------------------------
--- table fee_fee
---------------------------------------------------------------------
ALTER TABLE opuscollege.fee_fee alter column tuitionWaiverDiscountPercentage set default 0;
ALTER TABLE opuscollege.fee_fee alter column fulltimeStudentDiscountPercentage set default 0;
ALTER TABLE opuscollege.fee_fee alter column continuedRegistrationDiscountPercentage set default 0;
ALTER TABLE opuscollege.fee_fee alter column postgraduateDiscountPercentage set default 0;