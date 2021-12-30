/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"), you may not use this file except in compliance with
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

-- 
-- Author: Markus Pscheidt
-- Date:   2012-07-02
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.71);

-------------------------------------------------------
-- table studyplancardinaltimeunit
-------------------------------------------------------
ALTER TABLE opuscollege.studyplancardinaltimeunit ADD COLUMN studyIntensityCode VARCHAR;

-- full time in 1st time unit
update opuscollege.studyplancardinaltimeunit
set studyIntensityCode = 'F'
where id IN (
select targetspctu.id from opuscollege.studyplancardinaltimeunit targetspctu
where targetspctu.cardinaltimeunitnumber = 1
);

-- part time in 2nd and later time units
update opuscollege.studyplancardinaltimeunit
set studyIntensityCode = 'P'
where id IN (
select targetspctu.id from opuscollege.studyplancardinaltimeunit targetspctu
inner join opuscollege.studygradetype targetsgt on targetspctu.studygradetypeid = targetsgt.id
inner join opuscollege.academicyear targetacad on targetsgt.currentacademicyearid = targetacad.id
inner join opuscollege.studyplancardinaltimeunit previousspctu on previousspctu.studyplanid = targetspctu.studyplanid
  and previousspctu.cardinaltimeunitnumber+1 = targetspctu.cardinaltimeunitnumber
inner join opuscollege.studygradetype previoussgt on previousspctu.studygradetypeid = previoussgt.id
inner join opuscollege.academicyear previousacad on previoussgt.currentacademicyearid = previousacad.id
inner join opuscollege.progressstatus on previousspctu.progressstatuscode = progressstatus.code and progressstatus.lang = 'en'
where targetspctu.cardinaltimeunitnumber > 1
and previousacad.nextAcademicYearId = targetacad.id
and continuing ='Y' and "increment" = 'N' and carrying = 'S'
);

-- full time in 2nd and later time units
update opuscollege.studyplancardinaltimeunit
set studyIntensityCode = 'F'
where id IN (
select targetspctu.id from opuscollege.studyplancardinaltimeunit targetspctu
inner join opuscollege.studygradetype targetsgt on targetspctu.studygradetypeid = targetsgt.id
inner join opuscollege.academicyear targetacad on targetsgt.currentacademicyearid = targetacad.id
inner join opuscollege.studyplancardinaltimeunit previousspctu on previousspctu.studyplanid = targetspctu.studyplanid
  and previousspctu.cardinaltimeunitnumber+1 = targetspctu.cardinaltimeunitnumber
inner join opuscollege.studygradetype previoussgt on previousspctu.studygradetypeid = previoussgt.id
inner join opuscollege.academicyear previousacad on previoussgt.currentacademicyearid = previousacad.id
inner join opuscollege.progressstatus on previousspctu.progressstatuscode = progressstatus.code and progressstatus.lang = 'en'
where targetspctu.cardinaltimeunitnumber > 1
and previousacad.nextAcademicYearId = targetacad.id
and continuing ='Y' and ("increment" = 'Y' or carrying = 'A')
);
