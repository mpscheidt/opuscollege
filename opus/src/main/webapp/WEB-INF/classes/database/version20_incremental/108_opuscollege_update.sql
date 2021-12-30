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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.08);

-------------------------------------------------------
-- table academicField
-------------------------------------------------------

DELETE from opuscollege.academicField;

INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','1','Agronomy / Agricultural Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','2','Anthropology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','3','Archeology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','4','Arts and Letters');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','5','Astronomy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','6','Biochemistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','7','Bioethics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','8','Biology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','9','Biotechnology (incl. genetic modification)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','10','Business Administration / Management Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','11','Chemistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','12','Climatology / Climate Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','13','Communication Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','14','Computer Science');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','15','Criminology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','16','Demography (incl. Migration)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','17','Dentistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','18','Development Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','19','Earth Sciences – Soil');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','20','Earth Sciences – Water');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','21','Economy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','22','Educational Sciences / Pedagogy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','23','Engineering - Construction');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','24','Engineering - Electronic');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','25','Engineering – Industrial');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','26','Engineering – Mechanical');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','28','Environmental Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','29','Ethics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','30','Ethnography');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','31','Food Sciences / Food technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','32','Gender Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','33','Geography');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','34','Geology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','35','History');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','36','ICT - Information Systems');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','37','ICT - Software development');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','38','ICT – Computer Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','39','ICT – Telecommunications Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','40','Informatics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','41','International studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','42','Journalism');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','43','Languages - Arabic');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','44','Languages - Chinese');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','45','Languages - English');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','46','Languages - French');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','47','Languages - German');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','48','Languages - Portuguese');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','49','Languages - Russian');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','50','Languages - Spanish');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','51','Law');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','52','Linguistics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','53','Literature');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','54','Mathematics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','55','Mechanics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','56','Medicine - Anatomy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','57','Medicine - Cardiology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','58','Medicine - Ear, Nose, Throat');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','59','Medicine - Endocrinology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','60','Medicine - General Practice (GP)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','61','Medicine - Geriatrics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','62','Medicine - Gynaecology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','63','Medicine - Immunology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','64','Medicine - Internal specialisms');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','65','Medicine - Locomotor Apparatus (motion diseases)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','66','Medicine - Oncology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','67','Medicine - Ophthalmology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','68','Medicine - Paediatrics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','69','Medicine - Psychiatry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','70','Medicine - Tropical Medicine');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','71','Medicine - Urology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','72','Microbiology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','73','Nanotechnology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','74','Nuclear Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','75','Pharmacy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','76','Philosophy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','77','Physics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','78','Political Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','79','Psychology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','80','Religious Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','81','Sciences (natural)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','82','Social Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','83','Sociology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','84','Theology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','85','Medicine');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','86','Technology');

INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','1','Agronomia / Ciências Agrícolas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','2','Antropologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','3','Arqueologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','4','Artes e Letras');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','5','Astronomia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','6','Bioquímica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','7','Bioética');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','8','Biologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','9','Biotecnologia (incl. modificação genética)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','10','Administração empresarial / Ciências de Administração');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','11','Química');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','12','Climatologia / Ciências de Clima');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','13','Ciências de comunicação');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','14','Ciência de Computação');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','15','Criminologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','16','Demografia (incl. Migração)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','17','Odontologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','18','Estudos de desenvolvimento');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','19','Ciências de terra - Terra');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','20','Ciências de terra - Água');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','21','Economia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','22','Ciências educacionais / Pedagogia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','23','Engenharia - Construção');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','24','Engenharia - Eletrônica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','25','Engenharia - Industrial');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','26','Engenharia - Mecânica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','28','Estudos ambientais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','29','Ética');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','30','Etnografia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','31','Ciências de comida / tecnologia de Comida');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','32','Estudos de gênero');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','33','Geografia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','34','Geologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','35','História');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','36','TIC - Sistemas de Informação');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','37','TIC - desenvolvimento de Software');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','38','TIC - Tecnologia de Computador');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','39','TIC - Tecnologia de Telecomunicações');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','40','Informática');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','41','Estudos internacionais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','42','Jornalismo');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','43','Idiomas - árabe');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','44','Idiomas - Chinês');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','45','Idiomas - Português');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','46','Idiomas - Francês');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','47','Idiomas - Alemão');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','48','Idiomas - Português');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','49','Idiomas - Russo');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','50','Idiomas - Espanhol');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','51','Lei');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','52','Lingüística');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','53','Literatura');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','54','Matemática');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','55','Mecânicas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','56','Medicina - Anatomia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','57','Medicina - Cardiologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','58','Medicina - Orelha, Cheire, Garganta');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','59','Medicina - Endocrinologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','60','Medicina - Médico de Clícica Geral (MCG)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','61','Medicina - Geriátrico');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','62','Medicina - Ginecologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','63','Medicina - Imunologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','64','Medicina - Especialização Interna');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','65','Medicina - Aparato Locomotor (doenças resultantes de movimento)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','66','Medicina - Cancerologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','67','Medicina - Oftalmologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','68','Medicina - Pediatria');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','69','Medicina - Psiquiatria');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','70','Medicina - Medicina Tropical');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','71','Medicina - Urologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','72','Microbiologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','73','Nanotechnology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','74','Tecnologia nuclear');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','75','Farmácia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','76','Filosofia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','77','Física');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','78','Ciências políticas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','79','Psicologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','80','Estudos Religiosos');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','81','Ciências (naturais)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','82','Ciências sociais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','83','Sociologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','84','Teologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','85','Medicina');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','86','Tecnologia');

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------

DELETE FROM opuscollege.timeUnit;

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','1','semester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','2','semester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','3','trimester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','4','trimester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','5','trimester 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','6','semester 1 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','7','semester 1 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','8','semester 2 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','9','semester 2 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','10','yearly');

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','1','semestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','2','semestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','3','trimestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','4','trimestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','5','trimestre 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','6','semestre 1 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','7','semestre 1 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','8','semestre 2 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','9','semestre 2 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','10','anual');

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType;

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','2','secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','3','bachelor','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','4','licentiate','Lic.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','5','master','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','6','doctor','Ph.D.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','2','ensino secundário','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','3','bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','4','licenciatura','Lic.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','5','mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','6','Ph.D.','Ph.D.');

-------------------------------------------------------
-- table examinationResult
-------------------------------------------------------
ALTER TABLE opuscollege.examinationResult ADD column passed CHAR(1) NOT NULL DEFAULT 'N';

-------------------------------------------------------
-- table subjectResult
-------------------------------------------------------
ALTER TABLE opuscollege.subjectResult ADD column passed CHAR(1) NOT NULL DEFAULT 'N';

-------------------------------------------------------
-- table exam
-------------------------------------------------------
ALTER TABLE opuscollege.exam ADD column passed CHAR(1) NOT NULL DEFAULT 'N';
