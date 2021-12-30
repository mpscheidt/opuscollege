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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',1.02);

-------------------------------------------------------
-- sequences
-------------------------------------------------------
ALTER TABLE opuscollege.sch_scholarshipseq RENAME TO sch_scholarshipApplicationseq;
ALTER TABLE opuscollege.sch_scholarshiptypeyearseq RENAME TO sch_scholarshipseq;


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

