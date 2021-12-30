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

-- Opus College
-- Lookup inserts for Portuguese language
--

------------------------------------------------------
-- table civilTitle
-------------------------------------------------------
DELETE FROM opuscollege.civilTitle where lang='pt';
--INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','1','mr.');
--INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','2','mrs.');
--INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','3','ms.');

INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('pt','1','senhor');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('pt','2','senhora');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('pt','3','senhorita');

-------------------------------------------------------
-- table gender
-------------------------------------------------------
delete from opuscollege.gender where lang='pt';

--INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','1','male');
--INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','2','female');

INSERT INTO opuscollege.gender (lang,code,description) VALUES ('pt','1','masculino');
INSERT INTO opuscollege.gender (lang,code,description) VALUES ('pt','2','feminino');

-------------------------------------------------------
-- table nationality
-------------------------------------------------------
DELETE FROM opuscollege.nationality where lang='pt';
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','1','AFG', 'Afghan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','2','ALB', 'Albanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','3','ALG', 'Algerian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','4','AME', 'American (US)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','5','ANG', 'Angolan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','6','ARG', 'Argentine');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','7','AUS', 'Australian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','8','AUT', 'Austrian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','9','BAN', 'Bangladeshian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','10','BLR', 'Belarusian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','11','BEL', 'Belgian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','12','BEN', 'Beninese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','13','BOL', 'Bolivian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','14','BOS', 'Bosnian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','15','BOT', 'Botswanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','16','BRA', 'Brazilian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','17','BRI', 'British');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','18','BUL', 'Bulgarian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','19','BRK', 'Burkinese (B. Fasso)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','20','BRM', 'Burmese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','21','BRN', 'Burundese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','22','CMB', 'Cambodian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','23','CAM', 'Cameroonian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','24','CAN', 'Canadian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','25','CAF', 'Central African');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','26','CHA', 'Chadian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','27','CHI', 'Chilean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','28','CHI', 'Chinese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','29','COL', 'Colombian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','30','CNB', 'Congolese (Brazaville)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','31','CNC', 'Congolese (DR Congo)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','32','CRO', 'Croatian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','33','CUB', 'Cuban');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','34','DAN', 'Danish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','35','DOM', 'Dominican Republican');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','36','DUT', 'Dutch');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','37','ECU', 'Ecuadorian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','38','EGY', 'Egyptian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','39','EQU', 'Equatorial Guinean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','40','ERI', 'Eritrean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','41','EST', 'Estonian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','42','ETH', 'Ethiopian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','43','FIL', 'Fillipino');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','44','FIN', 'Finnish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','45','FRE', 'French');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','46','GAB', 'Gabonese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','47','GAM', 'Gambian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','48','GER', 'German');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','49','GHA', 'Ghanese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','50','GRE', 'Greek');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','51','GUI', 'Guinean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','52','GUY', 'Guyanese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','53','HAI', 'Haitian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','54','HUN', 'Hungarian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','55','ICE', 'Icelandian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','56','IND', 'Indian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','57','IDN', 'Indonesian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','58','IRN', 'Iranian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','59','IRA', 'Iraqi');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','60','IRE', 'Irish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','61','ITA', 'Italian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','62','IVO', 'Ivory Coastan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','63','JAM', 'Jamaican');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','64','JAP', 'Japanese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','65','JEW', 'Jewish (Israel)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','66','JOR', 'Jordanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','67','KAZ', 'Kazakhstanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','68','KYRG', 'Kyrgyzistanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','69','KEN', 'Kenian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','70','LA', 'Laotian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','71','LAT', 'Latvian (Lettish)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','72','LEB', 'Lebanese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','73','LES', 'Lesothan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','74','LIB', 'Liberian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','75','LIT', 'Lituanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','76','MLW', 'Malawian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','77','MLS', 'Malasian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','78','MAL', 'Malian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','79','MAU', 'Mauritanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','80','MEX', 'Mexican');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','81','MOL', 'Moldavian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','82','MON', 'Mongolian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','83','MOR', 'Morrocan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','84','NAM', 'Namibian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','85','NEP', 'Nepalese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','86','NWG', 'New Guinean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','87','NWZ', 'New Zealandian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','88','NGA', 'Nigerian (Nigeria)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','89','NGE', 'Nigerees (Niger)');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','90','NOR', 'Norvegian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','91','OMA', 'Omani');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','92','PAK', 'Pakistani');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','93','PAR', 'Paraguayan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','94','PER', 'Peruvian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','95','POL', 'Polish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','96','PRT', 'Portuguese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','97','PUE', 'PuertoRican');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','98','ROM', 'Romanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','99','RUS', 'Russian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','100','RSQ', 'Rwandese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','101','SAU', 'Saudi Arabian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','102','SEN', 'Senegalese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','103','SER', 'Serbian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','104','SIE', 'Sierra Leonian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','105','SIN', 'Singaporean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','106','SLO', 'Slovenian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','107','SOM', 'Somalian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','108','SAF', 'South African');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','109','ESP', 'Spanish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','110','SUD', 'Sudanese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','111','SUR', 'Surinamese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','112','SYR', 'Syrian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','113','SWA', 'Swazilandean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','114','SWE', 'Swedish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','115','SWI', 'Swiss');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','116','TAJ', 'Tajikistanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','117','TAN', 'Tanzanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','118','THA', 'Thai');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','119','TOG', 'Togolese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','120','TUN', 'Tunisian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','121','TUR', 'Turkish');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','122','TKM', 'Turkmenistanian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','123','UGA', 'Ugandan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','124','UKR', 'Ukranian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','125','URU', 'Uruguayan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','126','UZB', 'Uzbek');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','127','VEN', 'Venezuelan');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','128','VIE', 'Vietnamese');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','129','YEM', 'Yemenite');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','130','ZAM', 'Zambian');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','131','ZIM', 'Zimbabwean');
--INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','132','MOZ', 'Mozambican');

INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','1','AFG', 'Afeg&atilde;o');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','2','ALB', 'Alban&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','3','ALG', 'Algeriano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','4','AME', 'Americano (EUA)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','5','ANG', 'Angolano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','6','ARG', 'Argentino');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','7','AUS', 'Australiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','8','AUT', 'Austr&iacute;aco');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','9','BAN', 'Bengali');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','10','BLR', 'Belarusso');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','11','BEL', 'Belga');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','12','BEN', 'Beninese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','13','BOL', 'Boliviano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','14','BOS', 'B&oacute;snio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','15','BOT', 'Tswana');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','16','BRA', 'Brasileiro');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','17','BRI', 'Brit&acirc;nico');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','18','BUL', 'B&uacute;lgaro');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','19','BRK', 'Burkinese (B. Fasso)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','20','BRM', 'Birmane');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','21','BRN', 'Burundese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','22','CMB', 'Cambojano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','23','CAM', 'Camaron&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','24','CAN', 'Canadense');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','25','CAF', 'Centro Africano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','26','CHA', 'Chadiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','27','CHI', 'Chileno');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','28','CHI', 'Chin&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','29','COL', 'Colombiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','30','CNB', 'Congol&ecirc;s (Brazaville)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','31','CNC', 'Congol&ecirc;s (RD Congo)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','32','CRO', 'Croata');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','33','CUB', 'Cubano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','34','DAN', 'Dinamarqu&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','35','DOM', 'Republica dominicano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','36','DUT', 'Holand&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','37','ECU', 'Equatoriano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','38','EGY', 'Eg&iacute;pcio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','39','EQU', 'Guine equatoriano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','40','ERI', 'Eritreano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','41','EST', 'Estoniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','42','ETH', 'Et&iacute;ope');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','43','FIL', 'Fillipino');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','44','FIN', 'Finland&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','45','FRE', 'Franc&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','46','GAB', 'Gabonese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','47','GAM', 'Gambiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','48','GER', 'Alem&atilde;o');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','49','GHA', 'Ghan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','50','GRE', 'Grego');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','51','GUI', 'Guinese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','52','GUY', 'Guyanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','53','HAI', 'Haitiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','54','HUN', 'H&uacute;ngaro');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','55','ICE', 'Island&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','56','IND', '&Iacute;ndio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','57','IDN', 'Indon&eacute;sio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','58','IRN', 'Iraniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','59','IRA', 'Iraquiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','60','IRE', 'Irland&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','61','ITA', 'Italiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','62','IVO', 'Costa Marfin&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','63','JAM', 'Jamaicano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','64','JAP', 'Japon&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','65','JEW', 'Judeu (Israel)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','66','JOR', 'Jordaniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','67','KAZ', 'Kazaquistan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','68','KYRG', 'Kirguisiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','69','KEN', 'Keniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','70','LA', 'Laociano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','71','LAT', 'Latviano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','72','LEB', 'Liban&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','73','LES', 'Lesotano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','74','LIB', 'Liberiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','75','LIT', 'Lituan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','76','MLW', 'Malawiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','77','MLS', 'Malaio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','78','MAL', 'Maliano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','79','MAU', 'Mauriciano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','80','MEX', 'Mexicano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','81','MOL', 'Moldaviano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','82','MON', 'Mongol');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','83','MOR', 'Morroquino');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','84','NAM', 'Namibiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','85','NEP', 'Nepal&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','86','NWG', 'New Guinese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','87','NWZ', 'Zeland&ecirc;s (nova)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','88','NGA', 'Nigeriano (Nig&eacute;ria)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','89','NGE', 'Nigerino (N&iacute;ger)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','90','NOR', 'Noruegu&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','91','OMA', 'Oman&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','92','PAK', 'Paquistan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','93','PAR', 'Paraguaio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','94','PER', 'Peruano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','95','POL', 'Polon&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','96','PRT', 'Portugu&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','97','PUE', 'PuertoRican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','98','ROM', 'Romano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','99','RUS', 'Russo');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','100','RSQ', 'Ruand&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','101','SAU', '&Aacute;rabe Saudita');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','102','SEN', 'Senegal&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','103','SER', 'S&eacute;rvio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','104','SIE', 'Serra Leoniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','105','SIN', 'Singaporeano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','106','SLO', 'Esloveno');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','107','SOM', 'Somali');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','108','SAF', 'Sul Africano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','109','ESP', 'Espanhol');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','110','SUD', 'Sudan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','111','SUR', 'Surinamese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','112','SYR', 'S&iacute;rio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','113','SWA', 'Swazi');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','114','SWE', 'Sueco');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','115','SWI', 'Su&iacute;&ccedil;o');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','116','TAJ', 'Tagiquistan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','117','TAN', 'Tanzaniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','118','THA', 'Tailand&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','119','TOG', 'Togolese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','120','TUN', 'Tunisiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','121','TUR', 'Turco');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','122','TKM', 'Turquimenistan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','123','UGA', 'Ugand&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','124','UKR', 'Ucraniano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','125','URU', 'Uruguaio');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','126','UZB', 'Uzbequistan&ecirc;s');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','127','VEN', 'Venezuelano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','128','VIE', 'Vietnamita');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','129','YEM', 'Yemenita');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','130','ZAM', 'Zambiano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','131','ZIM', 'Zimbabweano');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('pt','132','MOZ', 'Mo&ccedil;ambicano');

-------------------------------------------------------
-- table country
-------------------------------------------------------
delete from opuscollege.country where lang='pt';

--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ALGERIA','DZ','DZA','012');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ANGOLA','AO','AGO','024');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ARGENTINA','AR','ARG','032');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','AUSTRALIA','AU','AUS','036');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','AUSTRIA','AT','AUT','040');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BANGLADESH','BD','BGD','050');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BELARUS','BY','BLR','112 ');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BELGIUM','BE','BEL','056');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BENIN','BJ','BEN','204');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOLIVIA','BO','BOL','068');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOSNIA HERZEGOVINA','BA','BIH','070');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOTSWANA','BW','BWA','072');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BRAZIL','BR','BRA','076');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BULGARIA','BG','BGR','100');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BURKINA FASO','BF','BFA','854');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BURUNDI','BI','BDI','108');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CAMEROON','CM','CMR','120');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CANADA','CA','CAN','124');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CAPO VERDE','CV','CPV','132');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CENTRAL AFRICAN REPUBLIC','CF','CAF','140');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TCHAD','TD','TCD','148');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHILE','CL','CHL','152');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHINA','CN','CHN','156');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COLOMBIA','CO','COL','170');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COMORE ISLAND','KM','COM','174');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CONGO','CG','COG','178');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COSTA RICA','CR','CRI','188');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COSTA DO MARFIM','CI','CIV','384');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CUBA','CU','CUB','192');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHECH REPUBLIC','CZ','CZE','203');  
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DENMARK','DK','DNK','208');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DJIBOUTI','DJ','DJI','262');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EAST TIMOR','TP','TMP','626');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ECUADOR','EC','ECU','218');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EGYPT','EG','EGY','818');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EL SALVADOR','SV','SLV','222');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EQUITORIAL GUINEE','GQ','GNQ','226');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ERITREA','ER','ERI','232');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ETHIOPIA','ET','ETH','210');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','FINLAND','FI','FIN','246');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','FRANCE','FR','FRA','250');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GABON','GA','GAB','266');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GAMBIA','GM','GMB','270');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GERMANY','DE','DEU','276');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GHANA','GH','GHA','288');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GREECE','GR','GRC','300');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUATEMALA','GT','GTM','320');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUINEE','GN','GIN','324');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUINEE-BISSAU','GW','GNB','624');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','HONG KONG','HK','HKG','344');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','HUNGARIA','HU','HUN','348');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','INDIA','IN','IND','356');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','INDONESIA','Id','IdN','360');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRAN','IR','IRN','364');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRAQ','IQ','IRQ','368');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRELAND','IE','IRL','372');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ISRAEL','IL','ISR','376');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ITALY','IT','ITA','380');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','JAMAICA','JM','JAM','388');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','JAPAN','JP','JPN','392');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','KENYA','KE','KEN','404');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NORTH COREA','KP','PRK','408');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOUTH COREA','KR','KOR','410');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','KUWAIT','KW','KWT','414');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LEBANON','LB','LBN','422');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LESOTHO','LS','LSO','426');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LIBERIA','LR','LBR','430');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LYBIA','LY','LBY','434');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LUXEMBURG','LU','LUX','442');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MACAU','MO','MAC','446');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MADAGASCAR','MG','MDG','450');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALAWI','MW','MWI','454');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALAYSIA','MY','MYS','458');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALI','ML','MLI','466');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MAURETANIA','MR','MRT','478');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MAURITIUS','MU','MUS','480');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MEXICO','MX','MEX','484');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MORROCOS','MA','MAR','504');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MOZAMBIQUE','MZ','MOZ','508');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NAMIBIA','NA','NAM','516');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NETHERLANDS','NL','NLD','528');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NEW ZEALAND','NZ','NZL','554');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NIGER','NE','NER','562');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NIGERIA','NG','NGA','566');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NORWAY','NO','NOR','578');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PAKISTAN','PK','PAK','586');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PANAMA','PA','PAN','591');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PARAGUAY','PY','PRY','600');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PERU','PE','PER','604');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PHILIPPINES','PH','PHL','608');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','POLAND','PL','POL','616');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PORTUGAL','PT','PRT','620');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PUERRTO RICO','PR','PRI','630');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','QATAR','QA','QAT','634');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','REUNION','RE','REU','638');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RUMENIA','RO','ROM','642');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RUSSIA','RU','RUS','643');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RWANDA','RW','RWA','646');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SANTO TOMAS AND PRINCIPE','ST','STP','678');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SAUDI ARABIA','SA','SAU','682');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SENEGAL','SN','SEN','686');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SEYCHELLES','SC','SYC','690');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SIERRA LEONE','SL','SLE','694');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SINGAPOUR','SG','SGP','702');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SLOVAKIA','SK','SVK','703');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOMALIA','SO','SOM','706');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOUTH AFRICA','ZA','ZAF','710');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SPAIN','ES','ESP','724');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SRI LANKA','LK','LKA','144');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SUDAN','SD','SDN','736');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWAZILAND','SZ','SWZ','748');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWEDEN','SE','SWE','752');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWITZERLAND','CH','CHE','756');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SYRIA','SY','SYR','760');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TAIWAN','TW','TWN','158');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TANZANIA','TZ','TZA','834');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TAILANDIA','TH','THA','764');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TOGO','TG','TGO','768');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TUNISIA','TN','TUN','788');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TURKEY','TR','TUR','792');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UGANDA','UG','UGA','800');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UKRAINE','UA','UKR','804');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UNITED ARAB EMIRATES','AE','ARE','784');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GREAT BRITAIN','GB','GBR','826');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UNITED STATES','US','USA','840');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','URUGUAY','UY','URY','858');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','VENEZUELA','VE','VEN','862');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','VIETNAM','VN','VNM','704');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','WESTERN SAHARA','EH','ESH','732');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','YEMEN','YE','YEM','887');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','YUGOSLAVIA','YU','YUG','891');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DR OF CONGO','RC','RDC','180');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ZAMBIA','ZM','ZMB','894');
--INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ZIMBABWE','ZW','ZWE','716');

INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARGELIA','DZ','DZA','012');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ANGOLA','AO','AGO','024');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARGENTINA','AR','ARG','032');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','AUSTRALIA','AU','AUS','036');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','AUSTRIA','AT','AUT','040');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BANGLADESH','BD','BGD','050');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BIOLORUSSIA','BY','BLR','112 ');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','B&Eacute;LGICA','BE','BEL','056');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BENIN','BJ','BEN','204');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOLIVIA','BO','BOL','068');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOSNIA HERZEGOVINA','BA','BIH','070');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOTSWANA','BW','BWA','072');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BRASIL','BR','BRA','076');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BULGARIA','BG','BGR','100');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BURKINA FASO','BF','BFA','854');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BURUNDI','BI','BDI','108');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CAMAR&otilde;ES','CM','CMR','120');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CANADA','CA','CAN','124');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CABO VERDE','CV','CPV','132');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','REP&uAcute;BLICA CENTRO AFRICANA','CF','CAF','140');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHADE','TD','TCD','148');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHILE','CL','CHL','152');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHINA','CN','CHN','156');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COLOMBIA','CO','COL','170');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHAS COMORES','KM','COM','174');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CONGO','CG','COG','178');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COSTA RICA','CR','CRI','188');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COSTA DO MARFIM','CI','CIV','384');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CUBA','CU','CUB','192');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','REP&Uacute;BLICA CHECA','CZ','CZE','203');  
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','DINAMARCA','DK','DNK','208');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','DJIBOUTI','DJ','DJI','262');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TIMOR LESTE','TP','TMP','626');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EQUADOR','EC','ECU','218');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EGIPTO','EG','EGY','818');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EL SALVADOR','SV','SLV','222');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUIN&Eacute; EQUATORIAL','GQ','GNQ','226');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ERITREA','ER','ERI','232');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ETIOPIA','ET','ETH','210');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FINLANDIA','FI','FIN','246');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FRANCA','FR','FRA','250');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GABA&otilde;','GA','GAB','266');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GAMBIA','GM','GMB','270');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ALEMANHA','DE','DEU','276');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GHANA','GH','GHA','288');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GRECIA','GR','GRC','300');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUATEMALA','GT','GTM','320');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUIN&Eacute; CONACRI','GN','GIN','324');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUIN&Eacute;-BISSAU','GW','GNB','624');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HONG KONG','HK','HKG','344');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HUNGRIA','HU','HUN','348');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','INDIA','IN','IND','356');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','INDON&Eacute;SIA','Id','IdN','360');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRA&otilde; (ISLAMIC REPUBLIC OF)','IR','IRN','364');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRAQUE','IQ','IRQ','368');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRLANDA','IE','IRL','372');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ISRAEL','IL','ISR','376');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ITALIA','IT','ITA','380');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','JAMAICA','JM','JAM','388');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','JAPA&otilde;','JP','JPN','392');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KENYA','KE','KEN','404');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KOREA DO NORTE','KP','PRK','408');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KOREA DO SUL','KR','KOR','410');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KUWAIT','KW','KWT','414');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','L&Iacute;BANO','LB','LBN','422');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LESOTHO','LS','LSO','426');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LIB&Eacute;RIA','LR','LBR','430');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LIBIA','LY','LBY','434');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LUXEMBURGO','LU','LUX','442');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MACAU','MO','MAC','446');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MADAGASCAR','MG','MDG','450');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALAWI','MW','MWI','454');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALASIA','MY','MYS','458');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALI','ML','MLI','466');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MAURITANIA','MR','MRT','478');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHA DAS MAURICIAS','MU','MUS','480');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','M&Eacute;XICO','MX','MEX','484');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MORROCOS','MA','MAR','504');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MOCAMBIQUE','MZ','MOZ','508');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NAMIBIA','NA','NAM','516');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HOLANDA','NL','NLD','528');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NOVA ZELANDIA','NZ','NZL','554');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NIGER','NE','NER','562');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NIGERIA','NG','NGA','566');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NOROEGA','NO','NOR','578');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PAQUISTA&otilde;','PK','PAK','586');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PANAM&Aacute;','PA','PAN','591');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PARAGUAI','PY','PRY','600');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PER&Uacute;','PE','PER','604');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FILIPINAS','PH','PHL','608');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','POL&Oacute;NIA','PL','POL','616');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PORTUGAL','PT','PRT','620');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PORTO RICO','PR','PRI','630');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','QATAR','QA','QAT','634');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHA DE REUNIA&otilde;','RE','REU','638');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ROMENIA','RO','ROM','642');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','RUSSIA','RU','RUS','643');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','RUANDA','RW','RWA','646');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SAO TOM&Eacute; E PRINCIPE','ST','STP','678');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARABIA SAUDITA','SA','SAU','682');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SENEGAL','SN','SEN','686');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SEYCHELLES','SC','SYC','690');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SERRA LEOA','SL','SLE','694');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SINGAPURA','SG','SGP','702');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ESLOVAQUIA','SK','SVK','703');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SOMALIA','SO','SOM','706');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','&Aacute;FRICA DO SUL','ZA','ZAF','710');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ESPANHA','ES','ESP','724');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SRI LANKA','LK','LKA','144');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SUDAO','SD','SDN','736');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SWAZILANDIA','SZ','SWZ','748');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SU&Eacute;CIA','SE','SWE','752');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SUICA','CH','CHE','756');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SIRIA','SY','SYR','760');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TAIWAN','TW','TWN','158');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TANZANIA','TZ','TZA','834');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TAILANDIA','TH','THA','764');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TOGO','TG','TGO','768');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TUNISIA','TN','TUN','788');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TURQUIA','TR','TUR','792');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','UGANDA','UG','UGA','800');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','UCRANIA','UA','UKR','804');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EMIRATES ARABES UNIDOS','AE','ARE','784');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','REINO UNIDO','GB','GBR','826');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ESTADOS UNIDOS','US','USA','840');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','URUGUAY','UY','URY','858');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','VENEZUELA','VE','VEN','862');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','VIETNAM','VN','VNM','704');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SAHARA OCIDENTAL','EH','ESH','732');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','YEMEN','YE','YEM','887');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','JUGOSLAVIA','YU','YUG','891');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','RD DE CONGO','RC','RDC','180');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ZAMBIA','ZM','ZMB','894');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ZIMBABWE','ZW','ZWE','716');

-------------------------------------------------------
-- table civilStatus
-------------------------------------------------------
DELETE FROM opuscollege.civilStatus where lang='pt';

--INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','1','married');
--INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','2','single');
--INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','3','widow');
--INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','4','divorced');

INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','1','casado/casada');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','2','solteiro/solteira');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','3','vi&uacute;vo/vi&uacute;va');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','4','divorciado/divorciada');

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
DELETE FROM opuscollege.identificationType where lang='pt';

--INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','1','BI');
--INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','2','Coupon Stub of BI');
--INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','3','passport');
--INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','4','drivers license');

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','1','BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','2','Tal&atilde;o de BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','3','Passaporte');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','4','DIRE');

-------------------------------------------------------
-- table language
-------------------------------------------------------
delete from opuscollege.language where lang='pt';

--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'chi', 'Chinese', 'zh');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'dut', 'Dutch', 'nl');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'eng', 'English', 'en');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'fre', 'French', 'fr');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ger', 'German', 'de');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ita', 'Italian', 'it');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'jpn', 'Japonese', 'ja');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'por', 'Portuguese', 'pt');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'rus', 'Russian', 'ru');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'spa', 'Spanish', 'es');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'zul', 'Zulu', 'zu');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cha', 'Changana', 'ca'); 
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cho', 'Chope', 'co');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'bit', 'Bitonga', 'bt');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cit', 'Chitsua', 'ci'); 
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ron', 'Ronga', 'ro');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'sen', 'Sena', 'se');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nda', 'Ndau', 'nd');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nhu', 'Nhungue', 'nh');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'tev', 'Teve', 'tv');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'coa', 'Chona', 'cn');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nde', 'Ndevele', 'nv');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nja', 'Nhandja', 'nj');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'chu', 'Chuabo', 'cb');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'lom', 'Lomu&eacute;', 'lm');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mac', 'Macua', 'mc');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cot', 'Coti', 'ci');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'jaw', 'Jawa', 'jw');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mac', 'Macondi', 'mc');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'met', 'Met&oacute;', 'mt');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mua', 'Muan&iacute;', 'mu');
--insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'swa', 'Swahili', 'sw');

insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'chi', 'Chin&ecirc;s', 'zh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'dut', 'Holand&ecirc;s', 'nl');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'eng', 'Ingl&ecirc;s', 'en');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'fre', 'Franc&ecirc;s', 'fr');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'ger', 'Alem&atilde;o', 'de');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'ita', 'Italiano', 'it');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'jpn', 'Japon&ecirc;s', 'ja');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'por', 'Portugu&ecirc;s', 'pt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'rus', 'Russo', 'ru');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'spa', 'Espanhol', 'es');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'zul', 'Zulu', 'zu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'cha', 'Changana', 'ca'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'cho', 'Chope', 'co');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'bit', 'Bitonga', 'bt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'cit', 'Chitsua', 'ci'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'ron', 'Ronga', 'ro');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'sen', 'Sena', 'se');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'nda', 'Ndau', 'nd');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'nhu', 'Nhungue', 'nh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'tev', 'Teve', 'tv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'coa', 'Chona', 'cn');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'nde', 'Ndevele', 'nv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'nja', 'Nhandja', 'nj');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'chu', 'Chuabo', 'cb');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'lom', 'Lomu&eacute;', 'lm');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mac', 'Macua', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'cot', 'Coti', 'ci');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'jaw', 'Jawa', 'jw');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mac', 'Macondi', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'met', 'Met&oacute;', 'mt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mua', 'Muan&iacute;', 'mu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'swa', 'Swahili', 'sw');

-------------------------------------------------------
-- table masteringLevel
-------------------------------------------------------
DELETE FROM opuscollege.masteringLevel where lang='pt';
--INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','1','fluent');
--INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','2','basic');
--INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','3','poor');

INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('pt','1','fluente');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('pt','2','intermediario');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('pt','3','b&aacute;sico');

-------------------------------------------------------
-- table appointmentType
-------------------------------------------------------
DELETE FROM opuscollege.appointmentType where lang='pt';
--INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','1','tenured');
--INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','2','associate');

INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('pt','1','empossado');
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('pt','2','s&oacute;cio');

-------------------------------------------------------
-- table staffType
-------------------------------------------------------
DELETE from opuscollege.staffType where lang='pt';

--INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','1','Academic');
--INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','2','Non-academic');

INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('pt','1','Corpo docente');
INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('pt','2','CTA (corpo t&eacute;cnico/adm.)');

-------------------------------------------------------
-- table unitArea
-------------------------------------------------------
DELETE from opuscollege.unitArea where lang='pt';

--INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('en','1','Academic');
--INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('en','2','Administrative');

INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('pt','1','Acad&eacute;micas');
INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('pt','2','Administrativas');

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType where lang='pt';

--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','Faculty');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');
--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','7','Institute');

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','1','Faculdade');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','2','Departamento');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','3','Reparti&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','4','Sec&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','5','Direc&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','6','Secretaria');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','7','Instituto');
-------------------------------------------------------
-- table academicField
-------------------------------------------------------
DELETE from opuscollege.academicField where lang='pt';

--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','1','Agronomy / Agricultural Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','2','Anthropology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','3','Archeology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','4','Arts and Letters');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','5','Astronomy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','6','Biochemistry');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','7','Bioethics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','8','Biology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','9','Biotechnology (incl. genetic modification)');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','10','Business Administration / Management Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','11','Chemistry');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','12','Climatology / Climate Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','13','Communication Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','14','Computer Science');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','15','Criminology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','16','Demography (incl. Migration)');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','17','Dentistry');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','18','Development Studies');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','19','Earth Sciences - Soil');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','20','Earth Sciences - Water');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','21','Economy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','22','Educational Sciences / Pedagogy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','23','Engineering - Construction');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','24','Engineering - Electronic');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','25','Engineering - Industrial');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','26','Engineering - Mechanical');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','28','Environmental Studies');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','29','Ethics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','30','Ethnography');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','31','Food Sciences / Food technology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','32','Gender Studies');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','33','Geography');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','34','Geology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','35','History');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','36','ICT - Information Systems');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','37','ICT - Software development');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','38','ICT - Computer Technology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','39','ICT - Telecommunications Technology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','40','Informatics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','41','International studies');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','42','Journalism');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','43','Languages - Arabic');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','44','Languages - Chinese');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','45','Languages - English');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','46','Languages - French');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','47','Languages - German');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','48','Languages - Portuguese');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','49','Languages - Russian');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','50','Languages - Spanish');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','51','Law');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','52','Linguistics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','53','Literature');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','54','Mathematics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','55','Mechanics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','56','Medicine - Anatomy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','57','Medicine - Cardiology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','58','Medicine - Ear, Nose, Throat');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','59','Medicine - Endocrinology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','60','Medicine - General Practice (GP)');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','61','Medicine - Geriatrics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','62','Medicine - Gynaecology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','63','Medicine - Immunology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','64','Medicine - Internal specialisms');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','65','Medicine - Locomotor Apparatus (motion diseases)');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','66','Medicine - Oncology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','67','Medicine - Ophthalmology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','68','Medicine - Paediatrics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','69','Medicine - Psychiatry');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','70','Medicine - Tropical Medicine');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','71','Medicine - Urology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','72','Microbiology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','73','Nanotechnology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','74','Nuclear Technology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','75','Pharmacy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','76','Philosophy');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','77','Physics');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','78','Political Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','79','Psychology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','80','Religious Studies');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','81','Sciences (natural)');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','82','Social Sciences');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','83','Sociology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','84','Theology');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','85','Medicine');
--INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','86','Technology');

INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','1','Agronomia / Ci&ecirc;ncias Agr&iacute;colas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','2','Antropologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','3','Arqueologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','4','Artes e Letras');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','5','Astronomia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','6','Bioqu&iacute;mica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','7','Bio&eacute;tica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','8','Biologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','9','Biotecnologia (incl. modifica&ccedil;&atilde;o gen&eacute;tica)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','10','Administra&ccedil;&atilde;o empresarial / Ci&ecirc;ncias de Administra&ccedil;&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','11','Qu&iacute;mica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','12','Climatologia / Ci&ecirc;ncias de Clima');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','13','Ci&ecirc;ncias de comunica&ccedil;&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','14','Ci&ecirc;ncia de Computa&ccedil;&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','15','Criminologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','16','Demografia (incl. Migra&ccedil;&atilde;o)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','17','Odontologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','18','Estudos de desenvolvimento');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','19','Ci&ecirc;ncias de terra - Terra');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','20','Ci&ecirc;ncias de terra - &Aacute;gua');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','21','Economia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','22','Ci&ecirc;ncias educacionais / Pedagogia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','23','Engenharia - Constru&ccedil;&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','24','Engenharia - Eletr&ocirc;nica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','25','Engenharia - Industrial');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','26','Engenharia - Mec&acirc;nica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','28','Estudos ambientais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','29','&Eacute;tica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','30','Etnografia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','31','Ci&ecirc;ncias de comida / tecnologia de Comida');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','32','Estudos de g&ecirc;nero');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','33','Geografia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','34','Geologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','35','Hist&oacute;ria');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','36','TIC - Sistemas de Informa&ccedil;&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','37','TIC - desenvolvimento de Software');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','38','TIC - Tecnologia de Computador');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','39','TIC - Tecnologia de Telecomunica&ccedil;&otilde;es');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','40','Inform&aacute;tica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','41','Estudos internacionais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','42','Jornalismo');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','43','Idiomas - &Aacute;rabe');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','44','Idiomas - Chin&ecirc;s');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','45','Idiomas - Portugu&ecirc;s');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','46','Idiomas - Franc&ecirc;s');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','47','Idiomas - Alem&atilde;o');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','48','Idiomas - Portugu&ecirc;s');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','49','Idiomas - Russo');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','50','Idiomas - Espanhol');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','51','Lei');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','52','Lingu&iacute;stica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','53','Literatura');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','54','Matem&aacute;tica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','55','Mec&acirc;nicas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','56','Medicina - Anatomia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','57','Medicina - Cardiologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','58','Medicina - Orelha, Cheire, Garganta');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','59','Medicina - Endocrinologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','60','Medicina - M&eacute;dico de Cl&iacute;cica Geral (MCG)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','61','Medicina - Geri&aacute;trico');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','62','Medicina - Ginecologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','63','Medicina - Imunologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','64','Medicina - Especializa&ccedil;&atilde;o Interna');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','65','Medicina - Aparato Locomotor (doen&ccedil;as resultantes de movimento)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','66','Medicina - Cancerologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','67','Medicina - Oftalmologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','68','Medicina - Pediatria');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','69','Medicina - Psiquiatria');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','70','Medicina - Medicina Tropical');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','71','Medicina - Urologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','72','Microbiologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','73','Nanotechnology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','74','Tecnologia nuclear');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','75','Farm&aacute;cia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','76','Filosofia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','77','F&iacute;sica');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','78','Ci&ecirc;ncias pol&iacute;ticas');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','79','Psicologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','80','Estudos Religiosos');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','81','Ci&ecirc;ncias (naturais)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','82','Ci&ecirc;ncias sociais');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','83','Sociologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','84','Teologia');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','85','Medicina');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('pt','86','Tecnologia');

-------------------------------------------------------
-- table function
-------------------------------------------------------
DELETE FROM opuscollege.function where lang='pt';

--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','1','Chief Professor');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','2','Associate Professor');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','3','Assistant Professor');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','4','Researcher');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','5','Assistant');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','6','Assistant-stagiaire');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','7','Monitor');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','8','Director');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','9','Sub Director of Education');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','10','Sub Director of Research');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','11','Dean of Faculty');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','12','Head of Department');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','13','Head of Vakgroep??');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','14','Head of Subject');
--INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','15','Head of Section');

INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','1','Professor Catedr&aacute;tico');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','2','Professor Associado');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','3','Professor Auxiliar');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','4','Investigador');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','5','Assistente');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','6','Assistente-Estagi&aacute;rio');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','7','Monitor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','8','Director');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','9','Director Adjunto para Doc&ecirc;ncia');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','10','Director Adjunto para Investiga&ccedil;ao');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','11','Director de faculdade');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','12','Chefe de Departamento');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','13','Chefe de Reparti&ccedil;&atilde;o');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','14','Director de Curso');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','15','Chefe de Sec&ccedil;&atilde;o');

-------------------------------------------------------
-- table functionLevel
-------------------------------------------------------
DELETE FROM opuscollege.functionLevel where lang='pt';
--INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','1','management');
--INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','2','non-management');

INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('pt','1','administra&ccedil;&atilde;o');
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('pt','2','n;&atilde;o administrac;&atilde;o');

-------------------------------------------------------
-- table educationType
-------------------------------------------------------
DELETE FROM opuscollege.educationType where lang='pt';

--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','1','Elementary');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','2','Basic');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','3','Secondary school');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','4','Bachelor');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','5','Licenciate');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','6','Diploma');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','7','Master');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','8','Doctor');
--INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','9','Post graduate');

INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','1','Elementar');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','2','B&aacute;sico');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','3','M&eacute;dio');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','4','Bacharel');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','5','Licenciado');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','6','Diploma');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','7','Mestre');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','8','Doutorado');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','9','P&oacute;s gradua&ccedil;&atilde;o');

-------------------------------------------------------
-- table levelOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.levelOfEducation where lang='pt';
--INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','1','No education');
--INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','2','1.-7. class');
--INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','3','8.-10. class');
--INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','4','11.-12. class');
--INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','5','Everything above');

INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('pt','1','Nenhum');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('pt','2','Primario');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('pt','3','B&aacute;sico');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('pt','4','M&eacute;dio');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('pt','5','Superior');

-------------------------------------------------------
-- table fieldOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.fieldOfEducation where lang='pt';
--INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','1','general');
--INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','2','agricultural');
--INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','3','technical');
--INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','4','pedagogical');

INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('pt','1','geral');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('pt','2','agr&iacute;cola');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('pt','3','t&eacute;cnico');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('pt','4','pedag&oacute;gico');

-------------------------------------------------------
-- table profession
-------------------------------------------------------
DELETE FROM opuscollege.profession where lang='pt';
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','1','accountant');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','2','academic staff (professor)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','3','academic staff (assistant)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','4','artist');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','5','baker');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','6','bank director');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','7','bank employee');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','8','buss driver');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','9','butcher');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','10','civil servant');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','11','cook');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','12','company clerk');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','13','company manager');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','14','craftsman');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','15','dentist');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','16','electrician');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','17','engineer');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','18','farmer');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','19','fisherman');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','20','furniture maker');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','21','garage manager');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','22','gardener');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','23','hairdresser');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','24','herdsman (cow, sheep, etc..)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','25','hotel manager');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','26','hotel employee');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','27','housewife');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','28','ICT specialist');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','29','interpreter');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','30','journalist');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','31','lawyer');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','32','manual labourer');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','33','market vendor');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','34','mechanic');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','35','medical doctor (general practicioner)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','36','medical doctor (specialist)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','37','musician');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','38','nurse (medical, incl. midwife)');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','39','(house-)painter');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','40','postman');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','41','psychologist');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','42','restaurant manager');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','43','restaurant employee');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','44','school director');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','45','salesman');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','46','shop owner');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','47','shop employee');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','48','seamstress');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','49','secretary');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','50','shoemaker');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','51','(black)smith');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','52','teacher primary school');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','53','teacher secondary school');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','54','train conductor');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','55','train engine driver');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','56','tailor');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','57','taxi driver');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','58','waiter/waitress');
--INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','59','weaver');

INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','1','contabilista');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','2','pessoal acad&ecirc;mico (professor)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','3','pessoal acad&ecirc;mico (assistente)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','4','artista');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','5','padeiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','6','Diretor  banc&aacute;rio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','7','Funcion&aacute;rio banc&aacute;rio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','8','motorista de autocarro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','9','a&ccedil;ougueiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','10','funcion&aacute;rio p&uacute;blico');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','11','cozinheiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','12','balconista da institui&ccedil;&atilde;o');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','13','gerente da institui&ccedil;&atilde;o');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','14','artes&atilde;o');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','15','dentista');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','16','eletricista');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','17','engenheiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','18','fazendeiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','19','pescador');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','20','fabricante de mob&iacute;lia');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','21','gerente de garagem');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','22','jardineiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','23','cabeleireiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','24','pastor (vaca, ovelha, etc..)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','25','gerente de hotel');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','26','empregado de hotel');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','27','dona de casa');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','28','Especialista de TIC');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','29','int&eacute;rprete');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','30','jornalista');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','31','advogado');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','32','Oper&aacute;rio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','33','vendedor de mercado');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','34','mec&acirc;nico');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','35','medical doctor (geral practicioner)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','36','M&eacute;dico (especialista)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','37','m&uacute;sico');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','38','enfermeira (m&eacute;dico, incl. parteira)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','39','(casa -) pintor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','40','carteiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','41','psic&oacute;logo');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','42','gerente de restaurante');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','43','empregado de restaurante');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','44','diretor de escola');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','45','vendedor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','46','dono de loja');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','47','empregado de loja');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','48','costureira');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','49','secret&aacute;rio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','50','sapateiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','51','(preto) ferreiro');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','52','Professor de escola prim&aacute;ria');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','53','teacher escola secund&aacute;ria');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','54','Condutor de comboio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','55','Maquinista de comboio');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','56','alfaiate');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','57','Motorista de taxi');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','58','Empregado de restaurante');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('pt','59','tecedor');
-------------------------------------------------------
-- table studyForm
-------------------------------------------------------
DELETE FROM opuscollege.studyForm where lang='pt';
--INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','1','regular learning');
--INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','3','distant learning');
--INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','4','various forms');

INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('pt','1','Ensino regular');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('pt','3','Ensino a dist&acirc;ncia');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('pt','4','various forms');

-------------------------------------------------------
-- table studyTime
-------------------------------------------------------
DELETE FROM opuscollege.studyTime where lang='pt';
--INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','1','daytime');
--INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','2','evening');
--INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','3','daytime&evening');

INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','1','diurno');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','2','nocturno');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','3','diurno&nocturno');

-------------------------------------------------------
-- table targetGroup
-------------------------------------------------------
DELETE FROM opuscollege.targetGroup where lang='pt';
--INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','1','all students');
--INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','2','students from study');
--INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','3','all international students');
--INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','4','all national students');

INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('pt','1','todos os estudantes');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('pt','2','estudantes do estudo');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('pt','3','todos os estudantes estrangeiros');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('pt','4','todos os estudantes nacionais');

-------------------------------------------------------
-- table contractType
-------------------------------------------------------
DELETE FROM opuscollege.contractType where lang='pt';

--INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','1','full');
--INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','2','partial');

INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('pt','1','tempo inteiro');
INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('pt','2','tempo parcial');

-------------------------------------------------------
-- table contractDuration
-------------------------------------------------------
DELETE FROM opuscollege.contractDuration where lang='pt';
--INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('en','1','permanent');
--INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('en','2','temporary');

INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('pt','1','permanente');
INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('pt','2','tempor&aacute;rio');

-------------------------------------------------------
-- table bloodType
-------------------------------------------------------
DELETE FROM opuscollege.bloodType where lang='pt';

--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','1','A');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','2','B');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','3','AB');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','4','0');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','5','unknown');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','6','A-Pos');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','7','A-Neg');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','8','B-Pos');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','9','B-Neg');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','10','AB-Pos');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','11','AB-Neg');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','12','0-Pos');
--INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','13','0-Neg');

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','5','desconhecido');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','13','0-Neg');

-------------------------------------------------------
-- table addressType
-------------------------------------------------------
DELETE FROM opuscollege.addressType where lang='pt';
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','1','home');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','2','formal communication address student');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','3','financial guardian');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','4','formal communication address study');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','5','formal communication address organizational unit');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','6','formal communication address work');
--INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','7','parents');

INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','1','casa');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','2','endere&ccedil;o de comunica&ccedil;&atilde;o formal estudante');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','3','guardi&atilde;o financeiro');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','4','endere&ccedil;o de comunica&ccedil;&atilde;o formal estudo');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','5','endere&ccedil;o de comunica&ccedil;&atilde;o formal unidade organizacional');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','6','endere&ccedil;o de comunica&ccedil;&atilde;o formal funcion&aacute;rio');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('pt','7','pai e m&atilde;e');

-------------------------------------------------------
-- table relationType
-------------------------------------------------------
DELETE FROM opuscollege.relationType where lang='pt';
--INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','1','brother');
--INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','2','sister');
--INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','3','uncle');
--INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','4','aunt');

INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('pt','1','irm&atilde;o');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('pt','2','irm&atilde;');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('pt','3','tio');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('pt','4','tia');

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
DELETE FROM opuscollege.studyType where lang='pt';

--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','1','lecture');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','2','workshop');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','3','experiment');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','4','self study');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','5','paper');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','6','e-learning');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','7','group work');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','8','individual assistance by teacher');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','9','literature');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','10','lab/practical');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','11','project');
--INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','12','seminar');

INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','1','aula');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','2','workshop');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','3','experimenta&ccedil;&atilde;o');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','4','estudo individual');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','5','trabalho escrito');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','6','e-Learning');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','7','trabalho de grupo');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','8','assist&ecirc;ncia individual pelo professor');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','9','literatura');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','10','laborat&oacute;rio/pr&aacute;ctica');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','11','projecto');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','12','semin&aacute;rio');

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='pt';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','SEC','ensino secund&aacute;rio','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BSC','bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LIC','licentiatura','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MSC','mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','PHD','Ph.D.','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BA','bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MA','master of art','M.A.');

-------------------------------------------------------
-- table endGradeType (for calculations on all levels)
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------

DELETE FROM opuscollege.endGradeType where lang='pt';

-- fixed values
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CA','Avalia&ccedil;&atilde;o cont&iacute;nua');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SE','Exame');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SR','Resultado da cadeira');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PC','Resultado do projecto');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','AR','Resultado do est&aacute;gio');

-- flexible values, all on level of cardinaltimeunit, thesis and studyplan
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CTU','Nota final do semestre/ano');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','TR','Resultado da tese');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BSC','Bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BA','Bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MSC','Master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MA','Master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PHD','Doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','LIC','Licenciatura');

-------------------------------------------------------
-- table frequency
-------------------------------------------------------
DELETE FROM opuscollege.frequency where lang='pt';

--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','1','1');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','2','1,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','3','2');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','4','2,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','5','3');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','6','3,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','7','4');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','8','4,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','9','5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','10','5,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','11','6');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','12','6,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','13','7');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','14','7,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','15','8');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','16','8,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','17','9');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','18','9,5');
--INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','19','10');

INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','1','1');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','2','1,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','3','2');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','4','2,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','5','3');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','6','3,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','7','4');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','8','4,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','9','5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','10','5,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','11','6');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','12','6,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','13','7');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','14','7,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','15','8');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','16','8,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','17','9');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','18','9,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('pt','19','10');


-------------------------------------------------------
-- table blockType
-------------------------------------------------------
DELETE FROM opuscollege.blockType where lang='pt';
--INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('en','1','thematic');
--INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('en','2','study year');

INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('pt','1','tem&aacute;tico');
INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('pt','2','estudo year');

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
DELETE FROM opuscollege.rigidityType where lang='pt';
--INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','1','compulsory');
--INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','3','elective');

INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('pt','1','compuls&oacute;rio');
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('pt','3','opcional');

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
DELETE FROM opuscollege.timeUnit where lang='pt';

--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','1','semester 1');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','2','semester 2');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','3','trimester 1');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','4','trimester 2');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','5','trimester 3');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','6','semester 1 - block 1');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','7','semester 1 - block 2');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','8','semester 2 - block 1');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','9','semester 2 - block 2');
--INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','10','yearly');

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','1','semestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','2','semestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','3','trimestre 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','4','trimestre 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','5','trimestre 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','6','semestre 1 - bloco 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','7','semestre 1 - bloco 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','8','semestre 2 - bloco 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','9','semestre 2 - bloco 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','10','anual');

-------------------------------------------------------
-- table subjectImportance
-------------------------------------------------------
DELETE FROM opuscollege.subjectImportance where lang='pt';
--INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('en','1','major');
--INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('en','2','minor');

INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('pt','1','principal');
INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('pt','2','secund&aacute;rio');

-------------------------------------------------------
-- table examType
-------------------------------------------------------
DELETE FROM opuscollege.examType where lang='pt';
--INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','1','multiple event');
--INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','2','single event');

INSERT INTO opuscollege.examType (lang,code,description) VALUES ('pt','1','uncia forma');
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('pt','2','varias formas');

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
DELETE FROM opuscollege.examinationType where lang='pt';

--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','1','oral');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','2','written');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','3','paper');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','4','lab/practical');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','5','thesis');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','6','case study');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','7','presentation');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','100','combined tests');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','101','final examination');
--INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','8','homework');

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','2','escrito');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','3','papel');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','4','pratico');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','5','tese');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','6','caso de estudo');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','7','apresentacao');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','100','nota de frequentia');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','101','exame final');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','8','trabalho para casa');

-------------------------------------------------------
-- table status
-------------------------------------------------------
DELETE FROM opuscollege.status where lang='pt';

--INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','1','active');
--INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','2','temporary inactive');
--INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','3','stopped without diploma');
--INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','4','graduated');
--INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','5','deceased');

INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','1','activo');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','2','tempor&aacute;rio inactivo');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','3','parado sem diploma');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','4','graduado');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','5','falecido');


-------------------------------------------------------
-- inserts on TABLE studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='pt';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','1','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','2','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','3','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','4','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','5','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','6','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','7','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','8','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','9','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','10','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','11','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','12','');


-----------------------------------------------------------
-- lookup TABLE opusPrivilege
-----------------------------------------------------------
DELETE FROM opuscollege.opusPrivilege where lang='pt';

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'pt', 'Imprimir pautas');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'pt', 'Editar plano de estudo');

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'pt', 'Editability of student data: all');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'pt', 'Editability of student data: personal data');

-----------------------------------------------------------
-- lookup TABLE progressStatus, which is the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='pt';

INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','1','Progression / Clear pass');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','2','Compensatory pass / Proceed and Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','3','To Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','4','At Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','5','To Full-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','6','Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','7','Exclude studygradetype');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','8','Exclude school');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','9','Withdrawn with permission');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('pt','10','Graduate');

-----------------------------------------------------------
-- lookup TABLE rfcStatus, which is the status of an rfc on a certain entity
-----------------------------------------------------------
DELETE FROM opuscollege.rfcStatus where lang='pt';

INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','1','Novo');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','2','Resolvido');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','3','Recusado');



