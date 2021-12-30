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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions;

INSERT INTO opuscollege.appVersions (coreDb) VALUES(1.02);

-------------------------------------------------------
-- table person
-------------------------------------------------------

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('81','UP-FCNM','Administrator','UP-FCNM'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('82','UP-FCS','Administrator','UP-FCS'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('83','UP-FCEFD','Administrator','UP-FC-FCEFD'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('84','UP-FL','Administrator','UP-FL'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('85','UP-FCP','Administrator','UP-FCP'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('61','UCM-PEMBA','Administrator','UCM-PEMBA'
		,'1960-01-01');

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '81'),'UP-FCNM', 'dce095d3df46247ddbbc1c1219bd4686');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '82'),'UP-FCS', '52b201d82743a4c2208606020d91262a');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '83'),'UP-FCEFD', '9b4474dc3b6e80fa7c3eed73b92fc3e2');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '84'),'UP-FL', 'c82b55aa7bf2154c4e1594ae8b70bb05');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '85'),'UP-FCP', 'd9ca67dd755ff589d896012cb6b55227');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '61'),'UCM-PEMBA', '534a2df4cd17911e7343b9d532908f61');

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------

INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UP-FCNM', 'admin-D');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UP-FCS', 'admin-D');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UP-FCEFD', 'admin-D');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UP-FL', 'admin-D');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UP-FCP', 'admin-D');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('pt','UCM-PEMBA', 'admin-B');

-------------------------------------------------------
-- table branch
-------------------------------------------------------

INSERT INTO opuscollege.branch(branchCode,institutionId,branchDescription) 
VALUES ('02',(SELECT id from opuscollege.institution where institutionCode = 'UNIV02'),'Universidade Católica de Moçambique - Pemba');

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UP-FCNMUN1','Universidade Pedagógica - FCNM',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP-FCNM'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UP-FCSUN1','Universidade Pedagógica - FCS',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP-FCS'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UP-FCEFDUN1','Universidade Pedagógica - FCEFD',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP-FCEFD'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UP-FLUN1','Universidade Pedagógica - FL',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP-FL'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UP-FCPUN1','Universidade Pedagógica - FCP',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP-FCP'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UCM-PEMBAUN1','UCM-Pemba-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Católica de Moçambique - Pemba'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UCM-PEMBA'));

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('81',
    (select id from opuscollege.person where surNameFull = 'UP-FCNM'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UP-FCNMUN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('82',
    (select id from opuscollege.person where surNameFull = 'UP-FCS'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UP-FCSUN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('83',
    (select id from opuscollege.person where surNameFull = 'UP-FCEFD'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UP-FCEFDUN1')
    );
    
INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('84',
    (select id from opuscollege.person where surNameFull = 'UP-FL'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UP-FLUN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('85',
    (select id from opuscollege.person where surNameFull = 'UP-FCP'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UP-FCPUN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('61',
    (select id from opuscollege.person where surNameFull = 'UCM-PEMBA'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UCM-PEMBAUN1')
    );

-------------------------------------------------------
-- table contractType
-------------------------------------------------------

DELETE FROM opuscollege.contractType;

INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','1','full');
INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','2','partial');

INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('pt','1','tempo inteiro');
INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('pt','2','tempo parcial');


    
    
    