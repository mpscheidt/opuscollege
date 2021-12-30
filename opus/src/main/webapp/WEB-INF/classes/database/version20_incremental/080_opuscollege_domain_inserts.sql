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

-- Opus College (c) UCI - Monique in het Veld May 2007
--
-- CREATEDB opusCollege --UTF8 --owner postgres --tablespace pg_default
--
-- CREATE SCHEMA opuscollege
--

-------------------------------------------------------
-- Domain tables
-------------------------------------------------------

-------------------------------------------------------
-- table role
-------------------------------------------------------
DELETE FROM opuscollege.opusUserRole;
DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin', 'system administrator');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-C', 'central administrator institution');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-B', 'central administrator branch');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-D', 'decentral administrator');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','staff', 'staff member');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','teacher', 'teacher');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','student', 'student');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','guest', 'system guest');
-- PT
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin', 'administrador de sistema');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-C', 'administrador central avaliação institucional');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-B', 'central administrator avaliação das delegações');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-D', 'administrador decentral');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','staff', 'funcionário');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','teacher', 'professor');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','student', 'estudante');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','guest', 'visitante de sistema');
-- NL
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin', 'systeem beheerder');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-C', 'centrale beheerder institutuut');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-B', 'centrale beheerder vestiging');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-D', 'decentrale beheerder');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','staff', 'medewerker');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','teacher', 'docent');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','student', 'student');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','guest', 'gast');

-------------------------------------------------------
-- table person
-------------------------------------------------------
DELETE FROM opuscollege.person;

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('1','MEC','Administrator','AMS'
		,'1960-01-01');

INSERT INTO opuscollege.person
(personCode,surNameFull, 
firstNamesFull,firstNamesAlias,birthDate) 
			VALUES ('2','Student',
			'Sample Student','SaS',
			'2005-05-16');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('3','MECAdmin','Administrator','AMS'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('4','UEM','Administrator','UEM'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('5','ISPU','Administrator','ISPU'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('6','UCM','Administrator','UCM'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('7','UMBB','Administrator','UMBB'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('8','UP','Administrator','UP'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('9','ACIPOL','Administrator','ACIPOL'
		,'1960-01-01');

INSERT INTO opuscollege.person
	(personCode,surNameFull, 
	firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('XPX','DEMO','Administrator','DEMO'
		,'1960-01-01');

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
DELETE FROM opuscollege.opusUser;

INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '1'),'MEC', 'e9e14c66502be9d6cbad2be3aa48041e');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '2'),'student', 'cd73502828457d15655bbd7a63fb0bc8');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '3'),'MECAdmin', '6c4f158d214fab78e77b36922dad2ba3');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '4'),'UEM', '15293a346954103279c3090f2c4fa27e');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '5'),'ISPU', '4d0e20b738444025bff257a8e8069066');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '6'),'UCM', '658a4eb2cd69b9085f8e01fea16b49a2');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '7'),'UMBB', '7c509f9729b18df22148a272ac5938c0');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '8'),'UP', '5e2c45d2640c8a6b29cca5c9c90dfd90');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '9'),'ACIPOL', 'b374e30896c3e3f06f4b4feaba2abda7');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'XPX'),'DEMO', '962d89c410bc4623b8d2670d2d975405');

--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '61'),'UCM-PEMBA', '534a2df4cd17911e7343b9d532908f61');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '85'),'UP-FCP', 'd9ca67dd755ff589d896012cb6b55227');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '84'),'UP-FL', 'c82b55aa7bf2154c4e1594ae8b70bb05');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '83'),'UP-FCED', '9b4474dc3b6e80fa7c3eed73b92fc3e2');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '82'),'UP-FCS', '52b201d82743a4c2208606020d91262a');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '81'),'UP-FCNM', 'dce095d3df46247ddbbc1c1219bd4686');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'XX101XX'),'ADMIN-UNIZAMBEZE', 'dbc34ac18389d735b690b9b743b8378b');

--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'P01'),'UNZA', 'c09bfd56c08194a5b3dfba27919acd43');
--INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'P02'),'CBU', '058ff1c3bc92c40c8f62f7612ac1c1b0');

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
DELETE FROM opuscollege.opusUserRole;

INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','MEC', 'admin');
INSERT INTO opuscollege.opusUserRole (lang,username,role) VALUES ('en','student', 'student');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','MECAdmin', 'admin-C');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','UEM', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','ISPU', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','UCM', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','UMBB', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','UP', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','ACIPOL', 'admin-B');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','DEMO', 'admin-B');

-------------------------------------------------------
-- table institution
-------------------------------------------------------
DELETE FROM opuscollege.institution;

INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','01','10257','Escola  Secunádria Januario Pedro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','01','10319','Escola Secundária de Montepuez', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','01','10394','Escola Secundária de Mueda', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','01','10592','Escola Secundária de Pemba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','01','10594','Colégio Liceal Dom José Garcia', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110016','Colégio Arco Íris', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110019','Liceu Cristovão Colombo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110026','Escola Secundária Francisco Manyanga', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110027','Escola Secundária Josina Machel', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110033','Liceu Polana', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110034','Colégio Kitabu', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110035','Colégio Isaac Newton', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110036','Escola da Polana Cimento A B', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110039','Escola da Comunidade Mahometana', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110042','Liceu Alvorada', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110043','Colégio Horizonte', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110048','Escola Estrela da Manha', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110072','Escola Secundária dos CFM Sul', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110113','Escola Nacional de Aeronáutica Civil', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110140','Escola Secundária de Lhanguene', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110147','Escola Anglicana de São Cipriano', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110170','Escola Secundária 14 de Outubro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110181','Escola Secundária Eduardo Mondlane', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110210','Escola Secundária Laulane', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110218','Escola Heman Gmener SOS', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110226','Escola São Paulo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110228','Escola União Baptista', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110260','Centro Dom Bosco', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110266','Escola Secundária de Malhazine', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110272','Colégio Gutemberg', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110273','Escola Secundária Estrela do Mar', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110275','Willow International School', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110276','Colégio Reis de Maputo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110284','COLÉGIO MODERNO', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110285','Escola Comunitária Albert Einstein', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110289','Escola Secundária Quisse Mavota', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','11','110294','Escola Secundária do ISCTEM', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','02','20168','Escola Pré Universitária Handam Bim Rashid', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','02','20496','Escola Pré Universitária de Chókwe', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','02','20607','Escola Secundária de Manjacaze', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','02','20770','Escola Secundária Joaquim Chissano', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','02','20772','Escola Secundária 1º de Janeiro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30132','Escola Secundária Emília Daússe', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30134','Escola dos CFM de Inhambane', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30299','Escola Secundária de Massinga', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30384','Escola Secundária de Cambine', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30479','Escola Secundária Padre Gumeiro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30480','Escola Secundária de Vilankulo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30580','Escola Secundária 29 de Setembro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','03','30759','Escola Secundária de Muelé', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','04','40059','Escola Secundária de Catandica', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','04','40234','Escola Secundária Samora Machel', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','04','40309','Escola Secundária de Jécua', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50027','Escola Secundária Joaquim A. Chissano', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50338','Escola Secundária da Moamba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50420','Escola Secundária da Namaacha', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50469','Escola Secundaria da Zona Verde', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50536','Escola Aboobacar Sidik (Rta)', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50555','Escola Secundária da Matola', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50584','Escola Secundária São Gabriel', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50585','Escola Secundária São Gabriel CD', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','05','50597','Escola Secundária da Nª Srª do Livramento', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60024','Escola Primária Handan Bin Rashid', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60025','Escola Secundária Handan Bin Rashid', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60077','Escola Secundária de Angoche', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60212','Escola Secundária de Nacala Porto', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60216','Escola Primária do Centro Cultural Islâmico', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60222','Escola Primária do Centro Cultural Islâmico de Nac', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','60742','Escola Secundária de Nametil', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','61436','Escola Secundária 1º de Maio', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','61440','Escola Secundária 12 de Outubro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','61510','Escola Secundária da Ribaue (Frelimo)', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','61733','Escola Secundária de Namapa', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','06','62030','Escola Secundária do Triângulo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','07','70062','Escola Secundária Padre Menegon', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','07','70063','Escola Secundária Padre Menegon', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','07','70762','Escola Secundária Paulo Samuel Kankomba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','07','71153','ESAM Mecanhelas', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','07','71192','ESG1 de Cuamba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80026','Escola Primária Municipal Anjo da Guarda', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80059','Escola Comunitária João XXIII', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80097','Escola Secundária Samora Moises Machel', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80098','Escola Primária Mateus Sansão Mutemba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80099','Escola Secundária da Manga', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80116','Escola Nossa Senhora de Fátima', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80127','Escola Primária da Catedral da Beira', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80128','Escola Privada do Chaimite', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80134','Escola Sol de Moçambique', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80203','Escola Comunitária Santo António de Barada - Buzi', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80220','Escola Secundária do Buzi', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80267','Escola Secundária de Caia', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80269','Escola Comunitária Nossa Senhora de Fátima-Murraça', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80331','Escola Santa Teresinha do Menino Jesus', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80440','Escola Comunitária São Francisco de Assis', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80533','Escola Secundária do Dondo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80534','Escola Secundária de Mafambisse', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','08','80843','Colégio Académico', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','09','90030','Escola Secundária de Ulongue', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','09','90158','Escola Secundária de Songo', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','09','90584','Escola Secundária de Tete', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','09','90703','Escola Secundária de Emília Dausse', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','10','100509','Escola Secundária de Gurué', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','10','101169','Escola Secundária Geral de Mocuba', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','10','101810','Escola Secundária 25 de Setembro', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ( '1','10','101818','Escola Secundária Geral Mãe África', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV01','Universidade Eduardo Mondlane', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','07','UNIV02','Universidade Católica de Moçambique', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV03','Universidade Pedagógica', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV04','Universidade Mussa Bin Bique ', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV05','Instituto Superior de Transportes e Comunicações', NULL);

INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV00','MEC', NULL);
INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV06','Universidade ACIPOL', NULL);

-------------------------------------------------------
-- table branch
-------------------------------------------------------
DELETE FROM opuscollege.branch;

INSERT INTO opuscollege.branch(branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode = '10257'),'Escola  Secunádria Januario Pedro');
INSERT INTO opuscollege.branch(branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode = '10319'),'Escola Secundária de Montepuez');
INSERT INTO opuscollege.branch(branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode = '10394'),'Escola Secundária de Mueda');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='10592'),'Escola Secundária de Pemba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='10594'),'Colégio Liceal Dom José Garcia');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110016'),'Colégio Arco Íris');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110019'),'Liceu Cristovão Colombo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110026'),'Escola Secundária Francisco Manyanga');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110027'),'Escola Secundária Josina Machel');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110033'),'Liceu Polana');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110034'),'Colégio Kitabu');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110035'),'Colégio Isaac Newton');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110036'),'Escola da Polana Cimento A B');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110039'),'Escola da Comunidade Mahometana');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110042'),'Liceu Alvorada');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110043'),'Colégio Horizonte');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110048'),'Escola Estrela da Manha');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110072'),'Escola Secundária dos CFM Sul');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110113'),'Escola Nacional de Aeronáutica Civil');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110140'),'Escola Secundária de Lhanguene');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110147'),'Escola Anglicana de São Cipriano');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110170'),'Escola Secundária 14 de Outubro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110181'),'Escola Secundária Eduardo Mondlane');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110210'),'Escola Secundária Laulane');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110218'),'Escola Heman Gmener SOS');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110226'),'Escola São Paulo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110228'),'Escola União Baptista');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110260'),'Centro Dom Bosco');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110266'),'Escola Secundária de Malhazine');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110272'),'Colégio Gutemberg');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110273'),'Escola Secundária Estrela do Mar');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110275'),'Willow International School');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110276'),'Colégio Reis de Maputo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110284'),'Colégio Moderno');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110285'),'Escola Comunitária Albert Einstein');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110289'),'Escola Secundária Quisse Mavota');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='110294'),'Escola Secundária do ISCTEM');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='20168'),'Escola Pré Universitária Handam Bim Rashid');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='20496'),'Escola Pré Universitária de Chókwe');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='20607'),'Escola Secundária de Manjacaze');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='20770'),'Escola Secundária Joaquim Chissano');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='20772'),'Escola Secundária 1º de Janeiro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30132'),'Escola Secundária Emília Daússe');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30134'),'Escola dos CFM de Inhambane');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30299'),'Escola Secundária de Massinga');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30384'),'Escola Secundária de Cambine');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30479'),'Escola Secundária Padre Gumeiro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30480'),'Escola Secundária de Vilankulo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30580'),'Escola Secundária 29 de Setembro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='30759'),'Escola Secundária de Muelé');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='40059'),'Escola Secundária de Catandica');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='40234'),'Escola Secundária Samora Machel');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='40309'),'Escola Secundária de Jécua');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50027'),'Escola Secundária Joaquim A. Chissano');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50338'),'Escola Secundária da Moamba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50420'),'Escola Secundária da Namaacha');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50469'),'Escola Secundaria da Zona Verde');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50536'),'Escola Aboobacar Sidik (Rta)');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50555'),'Escola Secundária da Matola');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50584'),'Escola Secundária São Gabriel');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50585'),'Escola Secundária São Gabriel CD');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='50597'),'Escola Secundária da Nª Srª do Livramento');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60024'),'Escola Primária Handan Bin Rashid');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60025'),'Escola Secundária Handan Bin Rashid');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60077'),'Escola Secundária de Angoche');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60212'),'Escola Secundária de Nacala Porto');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60216'),'Escola Primária do Centro Cultural Islâmico');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60222'),'Escola Primária do Centro Cultural Islâmico de Nac');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='60742'),'Escola Secundária de Nametil');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='61436'),'Escola Secundária 1º de Maio');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='61440'),'Escola Secundária 12 de Outubro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='61510'),'Escola Secundária da Ribaue (Frelimo)');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='61733'),'Escola Secundária de Namapa');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='62030'),'Escola Secundária do Triângulo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='70062'),'Escola Secundária Padre Menegon');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='70063'),'Escola Secundária Padre Menegon');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='70762'),'Escola Secundária Paulo Samuel Kankomba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='71153'),'ESAM Mecanhelas');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='71192'),'ESG1 de Cuamba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80026'),'Escola Primária Municipal Anjo da Guarda');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80059'),'Escola Comunitária João XXIII');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80097'),'Escola Secundária Samora Moises Machel');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80098'),'Escola Primária Mateus Sansão Mutemba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80099'),'Escola Secundária da Manga');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80116'),'Escola Nossa Senhora de Fátima');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80127'),'Escola Primária da Catedral da Beira');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80128'),'Escola Privada do Chaimite');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80134'),'Escola Sol de Moçambique');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80203'),'Escola Comunitária Santo António de Barada - Buzi');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80220'),'Escola Secundária do Buzi');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80267'),'Escola Secundária de Caia');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80269'),'Escola Comunitária Nossa Senhora de Fátima-Murraça');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80331'),'Escola Santa Teresinha do Menino Jesus');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80440'),'Escola Comunitária São Francisco de Assis');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80533'),'Escola Secundária do Dondo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80534'),'Escola Secundária de Mafambisse');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='80843'),'Colégio Académico');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='90030'),'Escola Secundária de Ulongue');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='90158'),'Escola Secundária de Songo');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='90584'),'Escola Secundária de Tete');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='90703'),'Escola Secundária de Emília Dausse');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='100509'),'Escola Secundária de Gurué');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='101169'),'Escola Secundária Geral de Mocuba');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='101810'),'Escola Secundária 25 de Setembro');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='101818'),'Escola Secundária Geral Mãe África');

INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV01'),'Universidade Eduardo Mondlane');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV02'),'Universidade Católica de Moçambique');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV03'),'Universidade Pedagógica');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV04'),'Universidade Mussa Bin Bique');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV05'),'Instituto Superior de Transportes e Comunicações');

INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV00'),'MEC Branch');
INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV06'),'Universidade ACIPOL');

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------
DELETE FROM opuscollege.organizationalUnit;

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('MECBRANCH1UNIT1','MEC-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'MEC Branch'),
1,'1','1','1',(select id from opuscollege.person where personCode = '1'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV1BRANCH1UN1','UEM-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Eduardo Mondlane'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UEM'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV2BRANCH1UN1','ISPU-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Instituto Superior de Transportes e Comunicações'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'ISPU'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV3BRANCH1UN1','UCM-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Católica de Moçambique'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UCM'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV4BRANCH1UN1','UMBB-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Mussa Bin Bique'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UMBB'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV5BRANCH1UN1','UP-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade Pedagógica'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'UP'));

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('UNIV6BRANCH1UN1','ACIPOL-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'Universidade ACIPOL'),
1,'1','1','1',(select id from opuscollege.person where surNameFull = 'ACIPOL'));

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------
DELETE FROM opuscollege.staffMember;

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    dateOfAppointment,
    appointmentTypeCode,
    staffTypeCode,
    primaryUnitOfAppointmentId,
    educationTypeCode)
    VALUES('1',(select id from opuscollege.person where surNameFull = 'MEC'),'2005-01-01','1','1',
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1'),'3');

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('2',
    (select id from opuscollege.person where surNameFull = 'MECAdmin'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('3',
    (select id from opuscollege.person where surNameFull = 'UEM'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV1BRANCH1UN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('4',
    (select id from opuscollege.person where surNameFull = 'ISPU'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV2BRANCH1UN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('5',
    (select id from opuscollege.person where surNameFull = 'UCM'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV3BRANCH1UN1')
    );
    
INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('6',
    (select id from opuscollege.person where surNameFull = 'UMBB'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV4BRANCH1UN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('7',
    (select id from opuscollege.person where surNameFull = 'UP'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV5BRANCH1UN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('8',
    (select id from opuscollege.person where surNameFull = 'ACIPOL'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'UNIV6BRANCH1UN1')
    );

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('XSX',
    (select id from opuscollege.person where surNameFull = 'DEMO'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1')
    );

-------------------------------------------------------
-- table staffMemberFunction
-------------------------------------------------------
DELETE FROM opuscollege.staffMemberFunction;

-------------------------------------------------------
-- table contract
-------------------------------------------------------
DELETE FROM opuscollege.contract;

INSERT INTO opuscollege.contract
    (contractCode,
    staffMemberId, 
    contractTypeCode,
    contractDurationCode,
    contractStartDate,
    contractEndDate,
    contactHours,
    fteAppointmentOverall,
    fteEducation,
    fteResearch,
    fteAdministrativeTasks)
    VALUES('1',(select staffMemberId from opuscollege.staffMember where staffMemberCode = '1'),'2','1','2005-01-01','2008-05-01',10.5,80,40,30,0);

INSERT INTO opuscollege.contract
    (contractCode,
    staffMemberId, 
    contractTypeCode,
    contractDurationCode,
    contractStartDate,
    contractEndDate,
    contactHours,
    fteAppointmentOverall,
    fteEducation,
    fteResearch,
    fteAdministrativeTasks)
    VALUES('2',(select staffMemberId from opuscollege.staffMember where staffMemberCode = '1'),'1','2','2007-01-01','2009-01-01',36,90,40,30,20);

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------
DELETE FROM opuscollege.study;

INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Biomatem&aacute;tica','1','1','2003-08-01');
INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Biofisica','1','1','2003-08-01');
INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Biologia M&eacute;dica','1','1','2003-08-01');
INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Qu&iacute;mica M&eacute;dica','1','1','2003-08-01');
INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Anatomia Humana I','1','1','2003-08-01');

-------------------------------------------------------
-- table student
-------------------------------------------------------
DELETE FROM opuscollege.student;

INSERT INTO opuscollege.student
    (studentCode, 
    personId,
    dateOfEnrolment ,
    primaryStudyId ,
    statusCode,
    previousInstitutionId,
	previousInstitutionName ,
    previousInstitutionDistrictCode ,
    previousInstitutionProvinceCode ,
    previousInstitutionCountryCode ,
    previousInstitutionEducationTypeCode ,
    previousInstitutionFinalGradeTypeCode, 
    previousInstitutionFinalMark,
    previousInstitutionDiplomaPhotograph,
    scholarship,
    fatherFullName,
    fatherEducationCode,
    fatherProfessionCode,
    motherFullName,
    motherEducationCode,
    motherProfessionCode,
    financialGuardianFullName,
    financialGuardianRelation,
    financialGuardianProfession
    )
    VALUES('1XX',(select id from opuscollege.person where personCode = '2'),'2005-01-01',(select id from opuscollege.study where studyDescription = 'Biofisica'),'1',1,
    'Escola Secunádria Januario Pedro','03-002','03','008','2','1','8PLUS', NULL,
    'Y','Some Father','3','1','Some Mother', '2','2','Some Guardian','3','4');

-------------------------------------------------------
-- TABLE studyGradeType
-------------------------------------------------------
DELETE FROM opuscollege.studyGradeType;

INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (1,'1',4,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (1,'2',2,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (2,'1',4,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (2,'2',2,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (3,'1',4,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (3,'2',2,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (4,'1',4,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (4,'2',2,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (5,'1',4,(select id from opuscollege.person where personCode = '1'));
INSERT INTO opuscollege.studyGradeType (
    studyId,
	gradeTypeCode,
    numberOfYears,
    contactId ) VALUES (5,'2',2,(select id from opuscollege.person where personCode = '1'));

-------------------------------------------------------
-- TABLE studyYear
-------------------------------------------------------
DELETE FROM opuscollege.studyYear;

-------------------------------------------------------
-- TABLE subject
-------------------------------------------------------
DELETE FROM opuscollege.subject;

-------------------------------------------------------
-- TABLE subjectBlock
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlock;

-------------------------------------------------------
-- table subjectSubjectBlock
-------------------------------------------------------
DELETE FROM opuscollege.subjectSubjectBlock;

-------------------------------------------------------
-- table subjectStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyYear;

-------------------------------------------------------
-- table subjectTeacher
-------------------------------------------------------
DELETE FROM opuscollege.subjectTeacher;

-------------------------------------------------------
-- table subjectBlockStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlockStudyYear;

-------------------------------------------------------
-- table subjectStudyType
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyType;

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
DELETE FROM opuscollege.studyPlan;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanDetail;

-------------------------------------------------------
-- TABLE address
-------------------------------------------------------
DELETE FROM opuscollege.address;

INSERT INTO opuscollege.address
    (
    addressTypeCode,
    personId, 
    studyId,
    organizationalUnitId,
	street ,
	number,
	numberExtension,
	zipCode,
	city,
	administrativePostCode,
	districtCode,
    provinceCode,
    countryCode,
	telephone ,
	faxNumber,
	mobilePhone ,
	emailAddress)
    VALUES(
    '1',(select id from opuscollege.person where personCode = '1'),0,0,'main street',16,'','HB11100','Maputo','1','1','1','2','018-222333',NULL,
    '06-33322111','info@maputo.mp');

      
