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

-- Opus College (c) UCI - Monique in het Veld November 2009
--
-- CREATEDB opusCollege --UTF8 --owner postgres --tablespace pg_default
--
-- CREATE SCHEMA opuscollege - new University
--

-------------------------------------------------------
-- table person
-------------------------------------------------------
--DELETE FROM opuscollege.person WHERE surNameFull = 'Unizambeze';

INSERT INTO opuscollege.person
    (personCode,surNameFull, 
    firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('XX101XX','Unizambeze','Beira',''
        ,'1960-01-01');

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
--DELETE FROM opuscollege.opusUser WHERE personId = (select id from opuscollege.person where personCode = 'XX101XX');

INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'XX101XX'),'ADMIN-UNIZAMBEZE', 'dbc34ac18389d735b690b9b743b8378b');

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
--DELETE FROM opuscollege.opusUserRole WHERE userName = 'UNIZAMBEZE';
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','ADMIN-UNIZAMBEZE', 'admin-B');

-------------------------------------------------------
-- table institution
-------------------------------------------------------
--DELETE FROM opuscollege.institution WHERE institutionCode = 'UNIV101' and institutionDescription = 'Universidade Unizambeze';

INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','07','UNIV101','Universidade Unizambeze', NULL);

-------------------------------------------------------
-- table branch
-------------------------------------------------------
--DELETE FROM opuscollege.branch WHERE institutionId = (SELECT id from opuscollege.institution where institutionCode='UNIV101') AND branchDescription = 'Primary Branch Universidade Unizambeze';

INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV101'),'Primary Branch Universidade Unizambeze');

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------
--DELETE FROM opuscollege.organizationalUnit WHERE organizationalUnitCode = 'UNIZAMBEZEBRANCH1UNIT1';

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIZAMBEZEBRANCH1UNIT1','UNIZAMBEZE-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Primary Branch Universidade Unizambeze'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'Unizambeze'));

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------
--DELETE FROM opuscollege.staffMember WHERE staffMemberCode = 'X101X';

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('X101X',
    (select id from opuscollege.person where surNameFull = 'Unizambeze'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIZAMBEZEBRANCH1UNIT1')
    );
