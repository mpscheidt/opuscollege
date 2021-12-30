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
-- Lookup inserts for English language
--
-- Initial author: Monique in het Veld


-------------------------------------------------------
-- table civilTitle
-------------------------------------------------------
DELETE FROM opuscollege.civilTitle where lang='en';
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','1','mr.');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','2','mrs.');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('en','3','ms.');

-------------------------------------------------------
-- table gender
-------------------------------------------------------
delete from opuscollege.gender where lang='en';

INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','1','male');
INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','2','female');

-------------------------------------------------------
-- table nationality
-------------------------------------------------------
DELETE FROM opuscollege.nationality where lang='en';
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','1','AFG', 'Afghan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','2','ALB', 'Albanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','3','ALG', 'Algerian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','4','AME', 'American (US)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','5','ANG', 'Angolan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','6','ARG', 'Argentine');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','7','AUS', 'Australian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','8','AUT', 'Austrian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','9','BAN', 'Bangladeshian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','10','BLR', 'Belarusian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','11','BEL', 'Belgian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','12','BEN', 'Beninese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','13','BOL', 'Bolivian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','14','BOS', 'Bosnian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','15','BOT', 'Botswanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','16','BRA', 'Brazilian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','17','BRI', 'British');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','18','BUL', 'Bulgarian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','19','BRK', 'Burkinese (B. Fasso)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','20','BRM', 'Burmese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','21','BRN', 'Burundese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','22','CMB', 'Cambodian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','23','CAM', 'Cameroonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','24','CAN', 'Canadian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','25','CAF', 'Central African');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','26','CHA', 'Chadian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','27','CHI', 'Chilean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','28','CHI', 'Chinese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','29','COL', 'Colombian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','30','CNB', 'Congolese (Brazaville)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','31','CNC', 'Congolese (DR Congo)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','32','CRO', 'Croatian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','33','CUB', 'Cuban');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','34','DAN', 'Danish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','35','DOM', 'Dominican Republican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','36','DUT', 'Dutch');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','37','ECU', 'Ecuadorian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','38','EGY', 'Egyptian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','39','EQU', 'Equatorial Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','40','ERI', 'Eritrean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','41','EST', 'Estonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','42','ETH', 'Ethiopian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','43','FIL', 'Fillipino');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','44','FIN', 'Finnish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','45','FRE', 'French');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','46','GAB', 'Gabonese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','47','GAM', 'Gambian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','48','GER', 'German');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','49','GHA', 'Ghanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','50','GRE', 'Greek');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','51','GUI', 'Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','52','GUY', 'Guyanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','53','HAI', 'Haitian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','54','HUN', 'Hungarian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','55','ICE', 'Icelandian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','56','IND', 'Indian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','57','IDN', 'Indonesian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','58','IRN', 'Iranian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','59','IRA', 'Iraqi');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','60','IRE', 'Irish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','61','ITA', 'Italian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','62','IVO', 'Ivory Coastan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','63','JAM', 'Jamaican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','64','JAP', 'Japanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','65','JEW', 'Jewish (Israel)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','66','JOR', 'Jordanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','67','KAZ', 'Kazakhstanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','68','KYRG', 'Kyrgyzistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','69','KEN', 'Kenian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','70','LA', 'Laotian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','71','LAT', 'Latvian (Lettish)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','72','LEB', 'Lebanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','73','LES', 'Lesothan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','74','LIB', 'Liberian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','75','LIT', 'Lituanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','76','MLW', 'Malawian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','77','MLS', 'Malasian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','78','MAL', 'Malian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','79','MAU', 'Mauritanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','80','MEX', 'Mexican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','81','MOL', 'Moldavian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','82','MON', 'Mongolian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','83','MOR', 'Morrocan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','84','NAM', 'Namibian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','85','NEP', 'Nepalese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','86','NWG', 'New Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','87','NWZ', 'New Zealandian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','88','NGA', 'Nigerian (Nigeria)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','89','NGE', 'Nigerees (Niger)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','90','NOR', 'Norvegian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','91','OMA', 'Omani');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','92','PAK', 'Pakistani');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','93','PAR', 'Paraguayan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','94','PER', 'Peruvian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','95','POL', 'Polish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','96','PRT', 'Portuguese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','97','PUE', 'PuertoRican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','98','ROM', 'Romanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','99','RUS', 'Russian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','100','RSQ', 'Rwandese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','101','SAU', 'Saudi Arabian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','102','SEN', 'Senegalese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','103','SER', 'Serbian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','104','SIE', 'Sierra Leonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','105','SIN', 'Singaporean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','106','SLO', 'Slovenian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','107','SOM', 'Somalian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','108','SAF', 'South African');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','109','ESP', 'Spanish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','110','SUD', 'Sudanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','111','SUR', 'Surinamese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','112','SYR', 'Syrian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','113','SWA', 'Swazilandean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','114','SWE', 'Swedish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','115','SWI', 'Swiss');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','116','TAJ', 'Tajikistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','117','TAN', 'Tanzanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','118','THA', 'Thai');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','119','TOG', 'Togolese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','120','TUN', 'Tunisian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','121','TUR', 'Turkish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','122','TKM', 'Turkmenistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','123','UGA', 'Ugandan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','124','UKR', 'Ukranian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','125','URU', 'Uruguayan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','126','UZB', 'Uzbek');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','127','VEN', 'Venezuelan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','128','VIE', 'Vietnamese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','129','YEM', 'Yemenite');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','130','ZAM', 'Zambian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','131','ZIM', 'Zimbabwean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('en','132','MOZ', 'Mozambican');

-------------------------------------------------------
-- table country
-------------------------------------------------------
delete from opuscollege.country where lang='en';

INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ALGERIA','DZ','DZA','012');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ANGOLA','AO','AGO','024');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ARGENTINA','AR','ARG','032');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','AUSTRALIA','AU','AUS','036');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','AUSTRIA','AT','AUT','040');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BANGLADESH','BD','BGD','050');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BELARUS','BY','BLR','112 ');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BELGIUM','BE','BEL','056');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BENIN','BJ','BEN','204');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOLIVIA','BO','BOL','068');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOSNIA HERZEGOVINA','BA','BIH','070');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BOTSWANA','BW','BWA','072');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BRAZIL','BR','BRA','076');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BULGARIA','BG','BGR','100');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BURKINA FASO','BF','BFA','854');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','BURUNDI','BI','BDI','108');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CAMEROON','CM','CMR','120');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CANADA','CA','CAN','124');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CAPE VERDE','CV','CPV','132');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CENTRAL AFRICAN REPUBLIC','CF','CAF','140');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TCHAD','TD','TCD','148');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHILE','CL','CHL','152');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHINA','CN','CHN','156');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COLOMBIA','CO','COL','170');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COMORE ISLAND','KM','COM','174');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CONGO','CG','COG','178');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COSTA RICA','CR','CRI','188');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','COSTA DO MARFIM','CI','CIV','384');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CUBA','CU','CUB','192');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CHECH REPUBLIC','CZ','CZE','203');  
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DENMARK','DK','DNK','208');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DJIBOUTI','DJ','DJI','262');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EAST TIMOR','TP','TMP','626');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ECUADOR','EC','ECU','218');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EGYPT','EG','EGY','818');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EL SALVADOR','SV','SLV','222');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','EQUITORIAL GUINEE','GQ','GNQ','226');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ERITREA','ER','ERI','232');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ETHIOPIA','ET','ETH','210');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','FINLAND','FI','FIN','246');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','FRANCE','FR','FRA','250');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GABON','GA','GAB','266');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GAMBIA','GM','GMB','270');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GERMANY','DE','DEU','276');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GHANA','GH','GHA','288');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GREECE','GR','GRC','300');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUATEMALA','GT','GTM','320');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUINEE','GN','GIN','324');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GUINEE-BISSAU','GW','GNB','624');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','HONG KONG','HK','HKG','344');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','HUNGARIA','HU','HUN','348');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','INDIA','IN','IND','356');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','INDONESIA','Id','IdN','360');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRAN','IR','IRN','364');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRAQ','IQ','IRQ','368');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','IRELAND','IE','IRL','372');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ISRAEL','IL','ISR','376');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ITALY','IT','ITA','380');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','JAMAICA','JM','JAM','388');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','JAPAN','JP','JPN','392');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','KENYA','KE','KEN','404');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NORTH COREA','KP','PRK','408');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOUTH COREA','KR','KOR','410');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','KUWAIT','KW','KWT','414');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LEBANON','LB','LBN','422');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LESOTHO','LS','LSO','426');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LIBERIA','LR','LBR','430');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LYBIA','LY','LBY','434');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','LUXEMBURG','LU','LUX','442');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MACAU','MO','MAC','446');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MADAGASCAR','MG','MDG','450');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALAWI','MW','MWI','454');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALAYSIA','MY','MYS','458');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MALI','ML','MLI','466');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MAURETANIA','MR','MRT','478');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MAURITIUS','MU','MUS','480');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MEXICO','MX','MEX','484');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MORROCOS','MA','MAR','504');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','MOZAMBIQUE','MZ','MOZ','508');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NAMIBIA','NA','NAM','516');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NETHERLANDS','NL','NLD','528');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NEW ZEALAND','NZ','NZL','554');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NIGER','NE','NER','562');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NIGERIA','NG','NGA','566');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','NORWAY','NO','NOR','578');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PAKISTAN','PK','PAK','586');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PANAMA','PA','PAN','591');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PARAGUAY','PY','PRY','600');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PERU','PE','PER','604');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PHILIPPINES','PH','PHL','608');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','POLAND','PL','POL','616');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PORTUGAL','PT','PRT','620');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','PUERRTO RICO','PR','PRI','630');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','QATAR','QA','QAT','634');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','REUNION','RE','REU','638');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RUMENIA','RO','ROM','642');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RUSSIA','RU','RUS','643');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','RWANDA','RW','RWA','646');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SANTO TOMAS AND PRINCIPE','ST','STP','678');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SAUDI ARABIA','SA','SAU','682');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SENEGAL','SN','SEN','686');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SEYCHELLES','SC','SYC','690');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SIERRA LEONE','SL','SLE','694');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SINGAPOUR','SG','SGP','702');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SLOVAKIA','SK','SVK','703');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOMALIA','SO','SOM','706');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SOUTH AFRICA','ZA','ZAF','710');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SPAIN','ES','ESP','724');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SRI LANKA','LK','LKA','144');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SUDAN','SD','SDN','736');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWAZILAND','SZ','SWZ','748');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWEDEN','SE','SWE','752');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SWITZERLAND','CH','CHE','756');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','SYRIA','SY','SYR','760');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TAIWAN','TW','TWN','158');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TANZANIA','TZ','TZA','834');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TAILANDIA','TH','THA','764');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TOGO','TG','TGO','768');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TUNISIA','TN','TUN','788');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','TURKEY','TR','TUR','792');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UGANDA','UG','UGA','800');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UKRAINE','UA','UKR','804');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UNITED ARAB EMIRATES','AE','ARE','784');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','GREAT BRITAIN','GB','GBR','826');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','UNITED STATES','US','USA','840');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','URUGUAY','UY','URY','858');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','VENEZUELA','VE','VEN','862');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','VIETNAM','VN','VNM','704');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','WESTERN SAHARA','EH','ESH','732');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','YEMEN','YE','YEM','887');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','YUGOSLAVIA','YU','YUG','891');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','DR OF CONGO','RC','RDC','180');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ZAMBIA','ZM','ZMB','894');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','ZIMBABWE','ZW','ZWE','716');

-------------------------------------------------------
-- table civilStatus
-------------------------------------------------------
DELETE FROM opuscollege.civilStatus where lang='en';

INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','1','married');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','2','single');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','3','widow');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','4','divorced');

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
DELETE FROM opuscollege.identificationType where lang='en';

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','1','BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','2','Coupon Stub of BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','3','passport');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','4','drivers license');

-------------------------------------------------------
-- table language
-------------------------------------------------------
delete from opuscollege.language where lang='en';

insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'chi', 'Chinese', 'zh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'dut', 'Dutch', 'nl');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'eng', 'English', 'en');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'fre', 'French', 'fr');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ger', 'German', 'de');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ita', 'Italian', 'it');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'jpn', 'Japonese', 'ja');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'por', 'Portuguese', 'pt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'rus', 'Russian', 'ru');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'spa', 'Spanish', 'es');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'zul', 'Zulu', 'zu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cha', 'Changana', 'ca'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cho', 'Chope', 'co');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'bit', 'Bitonga', 'bt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cit', 'Chitsua', 'ci'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'ron', 'Ronga', 'ro');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'sen', 'Sena', 'se');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nda', 'Ndau', 'nd');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nhu', 'Nhungue', 'nh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'tev', 'Teve', 'tv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'coa', 'Chona', 'cn');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nde', 'Ndevele', 'nv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'nja', 'Nhandja', 'nj');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'chu', 'Chuabo', 'cb');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'lom', 'Lomué', 'lm');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mac', 'Macua', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'cot', 'Coti', 'ci');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'jaw', 'Jawa', 'jw');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mac', 'Macondi', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'met', 'Metó', 'mt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'mua', 'Muaní', 'mu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('en', 'swa', 'Swahili', 'sw');


-------------------------------------------------------
-- table masteringLevel
-------------------------------------------------------
DELETE FROM opuscollege.masteringLevel where lang='en';
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','1','fluent');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','2','basic');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('en','3','poor');

-------------------------------------------------------
-- table appointmentType
-------------------------------------------------------
DELETE FROM opuscollege.appointmentType where lang='en';
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','1','tenured');
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','2','associate');

-------------------------------------------------------
-- table staffType
-------------------------------------------------------
DELETE from opuscollege.staffType where lang='en';

INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','1','Academic');
INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','2','Non-academic');

-------------------------------------------------------
-- table unitArea
-------------------------------------------------------
DELETE from opuscollege.unitArea where lang='en';

INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('en','1','Academic');
INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('en','2','Administrative');

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType where lang='en';

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','Faculty');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','7','Institute');

-------------------------------------------------------
-- table academicField
-------------------------------------------------------
DELETE from opuscollege.academicField where lang='en';

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
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','19','Earth Sciences - Soil');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','20','Earth Sciences - Water');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','21','Economy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','22','Educational Sciences / Pedagogy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','23','Engineering - Construction');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','24','Engineering - Electronic');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','25','Engineering - Industrial');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','26','Engineering - Mechanical');
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
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','38','ICT - Computer Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('en','39','ICT - Telecommunications Technology');
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

-------------------------------------------------------
-- table function
-------------------------------------------------------
DELETE FROM opuscollege.function where lang='en';

INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','1','Chief Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','2','Associate Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','3','Assistant Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','4','Researcher');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','5','Assistant');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','6','Assistant-stagiaire');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','7','Monitor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','8','Director');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','9','Sub Director of Education');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','10','Sub Director of Research');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','11','Dean of Faculty');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','12','Head of Department');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','13','Head of Group');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','14','Head of Subject');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','15','Head of Section');

-------------------------------------------------------
-- table functionLevel
-------------------------------------------------------
DELETE FROM opuscollege.functionLevel where lang='en';
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','1','management');
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','2','non-management');

-------------------------------------------------------
-- table educationType
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.educationType where lang='en';

INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','-1','Elementary');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','0','Basic');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','1','Secondary school');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','3','Higher education');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','4','Bachelor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','5','Licenciate');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','6','Diploma');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','7','Master');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','8','Doctor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','9','Post graduate');

-------------------------------------------------------
-- table levelOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.levelOfEducation where lang='en';
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','1','No education');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','2','1.-7. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','3','8.-10. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','4','11.-12. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('en','5','Everything above');

-------------------------------------------------------
-- table fieldOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.fieldOfEducation where lang='en';
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','1','general');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','2','agricultural');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','3','technical');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('en','4','pedagogical');

-------------------------------------------------------
-- table profession
-------------------------------------------------------
DELETE FROM opuscollege.profession where lang='en';
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','1','accountant');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','2','academic staff (professor)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','3','academic staff (assistant)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','4','artist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','5','baker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','6','bank director');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','7','bank employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','8','buss driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','9','butcher');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','10','civil servant');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','11','cook');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','12','company clerk');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','13','company manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','14','craftsman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','15','dentist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','16','electrician');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','17','engineer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','18','farmer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','19','fisherman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','20','furniture maker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','21','garage manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','22','gardener');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','23','hairdresser');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','24','herdsman (cow, sheep, etc..)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','25','hotel manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','26','hotel employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','27','housewife');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','28','ICT specialist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','29','interpreter');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','30','journalist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','31','lawyer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','32','manual labourer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','33','market vendor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','34','mechanic');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','35','medical doctor (general practicioner)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','36','medical doctor (specialist)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','37','musician');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','38','nurse (medical, incl. midwife)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','39','(house-)painter');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','40','postman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','41','psychologist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','42','restaurant manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','43','restaurant employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','44','school director');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','45','salesman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','46','shop owner');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','47','shop employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','48','seamstress');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','49','secretary');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','50','shoemaker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','51','(black)smith');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','52','teacher primary school');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','53','teacher secondary school');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','54','train conductor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','55','train engine driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','56','tailor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','57','taxi driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','58','waiter/waitress');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('en','59','weaver');

-------------------------------------------------------
-- table studyForm
-------------------------------------------------------
DELETE FROM opuscollege.studyForm where lang='en';
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','1','regular learning');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','2','parallel programme');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','3','distant learning');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('en','4','various forms');

-------------------------------------------------------
-- table studyTime
-------------------------------------------------------
DELETE FROM opuscollege.studyTime where lang='en';

INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','D','Daytime');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','E','Evening');

-------------------------------------------------------
-- table targetGroup
-------------------------------------------------------
DELETE FROM opuscollege.targetGroup where lang='en';
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','1','all students');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','2','students from study');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','3','all international students');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('en','4','all national students');

-------------------------------------------------------
-- table contractType
-------------------------------------------------------
DELETE FROM opuscollege.contractType where lang='en';

INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','1','full');
INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('en','2','partial');

-------------------------------------------------------
-- table contractDuration
-------------------------------------------------------
DELETE FROM opuscollege.contractDuration where lang='en';
INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('en','1','permanent');
INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('en','2','temporary');

-------------------------------------------------------
-- table bloodType
-------------------------------------------------------
DELETE FROM opuscollege.bloodType where lang='en';

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','5','unknown');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','13','0-Neg');

-------------------------------------------------------
-- table addressType
-------------------------------------------------------
DELETE FROM opuscollege.addressType where lang='en';
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','1','home');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','2','formal communication address student');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','3','financial guardian');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','4','formal communication address study');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','5','formal communication address organizational unit');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','6','formal communication address work');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('en','7','parents');

-------------------------------------------------------
-- table relationType
-------------------------------------------------------
DELETE FROM opuscollege.relationType where lang='en';
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','1','brother');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','2','sister');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','3','uncle');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('en','4','aunt');

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
DELETE FROM opuscollege.studyType where lang='en';

INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','1','lecture');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','2','workshop');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','3','experiment');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','4','self study');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','5','paper');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','6','e-learning');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','7','group work');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','8','individual assistance by teacher');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','9','literature');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','10','lab/practical');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','11','project');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','12','seminar');

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-- NOTE: used in calculations, can not be altered !!
-- NOTE: 'diploma - other than maths and science' and 
--       'diploma - maths and science' 
--       moved to Zambia specific lookups
--       and 'licenciate' moved to mozambique lookups
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='en';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','SEC','secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BSC','bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LIC','licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MSC','master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','PHD','doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BA','bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MA','master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DA','diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DSC','diploma maths and science','Dpl.M.Sc.');

-------------------------------------------------------
-- table endGradeType (for calculations on all levels)
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.endGradeType where lang='en';

-- EN
-- fixed values
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CA','continuous assessment');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SE','sessional examination');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SR','subject result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PC','project course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','AR','attachment result');

-- flexible values, all on level of cardinaltimeunit, thesis and studyplan
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CTU','cardinal time unit endgrade');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','TR','thesis result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BSC','bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BA','bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MSC','master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MA','master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DA','diploma other than maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DSC','diploma maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DIST-DEGR','degree programme (distant education)');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DIST','distant education');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PHD','doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','LIC','licentiate');

-------------------------------------------------------
-- table frequency
-------------------------------------------------------
DELETE FROM opuscollege.frequency where lang='en';

INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','1','1');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','2','1,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','3','2');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','4','2,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','5','3');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','6','3,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','7','4');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','8','4,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','9','5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','10','5,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','11','6');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','12','6,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','13','7');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','14','7,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','15','8');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','16','8,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','17','9');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','18','9,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('en','19','10');

-------------------------------------------------------
-- table blockType
-------------------------------------------------------
DELETE FROM opuscollege.blockType where lang='en';
INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('en','1','thematic');
INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('en','2','study year');

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
DELETE FROM opuscollege.rigidityType where lang='en';
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','1','compulsory');
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','3','elective');

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
DELETE FROM opuscollege.timeUnit where lang='en';

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

-------------------------------------------------------
-- table subjectImportance
-------------------------------------------------------
DELETE FROM opuscollege.subjectImportance where lang='en';
INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('en','1','major');
INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('en','2','minor');

-------------------------------------------------------
-- table examType
-------------------------------------------------------
DELETE FROM opuscollege.examType where lang='en';
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','1','multiple event');
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','2','single event');

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
DELETE FROM opuscollege.examinationType where lang='en';

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','2','written');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','3','paper');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','4','lab/practical');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','5','thesis');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','6','case study');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','7','presentation');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','100','combined tests');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','101','sessional examination');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','102','continuous assessment');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','8','homework');

-----------------------------------------------------------
-- inserts on TABLE status, which is the status of Student
-----------------------------------------------------------
-------------------------------------------------------
-- table status
-------------------------------------------------------
DELETE FROM opuscollege.status where lang='en';

INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','1','active');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','2','temporary inactive');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','3','excluded');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','4','suspended');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','5','expelled');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','6','deceased');

-------------------------------------------------------
-- inserts on TABLE studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='en';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','1','start initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','2','waiting for approval of admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','3','rejected admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','4','approved admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','5','start continued registration');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','6','waiting for approval of registration');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','7','rejected registration');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','8','approved registration (waiting for payment)');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','9','actively registered');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','10','temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','11','graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','12','withdrawn');


-----------------------------------------------------------
-- lookup TABLE opusPrivilege
-----------------------------------------------------------
DELETE FROM opuscollege.opusPrivilege where lang='en';

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'en', 'Print result slip');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'en', 'Alter study plan');

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'en', 'Editability of student data: all');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'en', 'Editability of student data: personal data');

-----------------------------------------------------------
-- lookup TABLE progressStatus, which is the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='en';

INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','1','Progression / Clear pass');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','2','Compensatory pass / Proceed and Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','3','To Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','4','At Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','5','To Full-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','6','Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','7','Exclude studygradetype');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','8','Exclude school');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','9','Withdrawn with permission');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','10','Graduate');

-----------------------------------------------------------
-- lookup TABLE rfcStatus, which is the status of an rfc on a certain entity
-----------------------------------------------------------
DELETE FROM opuscollege.rfcStatus where lang='en';

INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','1','New');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','2','Resolved');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','3','Refused');

