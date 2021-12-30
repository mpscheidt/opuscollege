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
-- Author: Stelio Macumbe
-- Date:   2013-02-14
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('college','A','Y',4.07);

-------------------------------------------------------
-- table OpusUserPrivilege
-------------------------------------------------------
--Different privileges with same description are confusing to users

--Previous description was 'Create study addresses'
UPDATE opuscollege.OpusPrivilege SET Description = 'Update study addresses' WHERE OpusPrivilege.code = 'UPDATE_STUDY_ADDRESSES' AND lang = 'en';
UPDATE opuscollege.OpusPrivilege SET Description = 'Actualizar endereços do curso' WHERE OpusPrivilege.code = 'UPDATE_STUDY_ADDRESSES' AND lang = 'pt';

--Previous description was 'Delete student absences'
UPDATE opuscollege.OpusPrivilege SET Description = 'Update students absences' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_ABSENCES' AND lang = 'en';
UPDATE opuscollege.OpusPrivilege SET Description = 'Actualizar ausências do estudante' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_ABSENCES' AND lang = 'pt';

--Previous description was 'Delete student addresses'
UPDATE opuscollege.OpusPrivilege SET Description = 'Update student addresses' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_ADDRESSES' AND lang = 'en';
UPDATE opuscollege.OpusPrivilege SET Description = 'Actualizar endereços do estudante' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_ADDRESSES' AND lang = 'pt';

--Previous description was 'Delete subjects'
UPDATE opuscollege.OpusPrivilege SET Description = 'Delete subject blocks' WHERE OpusPrivilege.code = 'DELETE_SUBJECTBLOCKS' AND lang = 'en';
UPDATE opuscollege.OpusPrivilege SET Description = 'Remover blocos de disciplinas' WHERE OpusPrivilege.code = 'DELETE_SUBJECTBLOCKS' AND lang = 'pt';

--Previous description was 'View student subscription data'
UPDATE opuscollege.OpusPrivilege SET Description = 'Update student subscription data' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_SUBSCRIPTION_DATA' AND lang = 'en';
UPDATE opuscollege.OpusPrivilege SET Description = 'Actualizar dados de inscrição do estudante' WHERE OpusPrivilege.code = 'UPDATE_STUDENT_SUBSCRIPTION_DATA' AND lang = 'pt';


