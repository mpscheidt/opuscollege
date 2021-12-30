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
-- SCHOLARSHIP opusCollege / MODULE zambia
--
-- Initial author: Monique in het Veld

-------------------------------------------------------
-- table civilTitle
-------------------------------------------------------
DELETE FROM opuscollege.civilTitle where lang='nl';
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('nl','1','mr.');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('nl','2','mrs.');
INSERT INTO opuscollege.civilTitle (lang,code,description) VALUES ('nl','3','ms.');

-------------------------------------------------------
-- table gender
-------------------------------------------------------
delete from opuscollege.gender where lang='nl';

INSERT INTO opuscollege.gender (lang,code,description) VALUES ('nl','1','male');
INSERT INTO opuscollege.gender (lang,code,description) VALUES ('nl','2','female');

-------------------------------------------------------
-- table nationality
-------------------------------------------------------
DELETE FROM opuscollege.nationality where lang='nl';
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','1','AFG', 'Afghan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','2','ALB', 'Albanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','3','ALG', 'Algerian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','4','AME', 'American (US)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','5','ANG', 'Angolan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','6','ARG', 'Argentine');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','7','AUS', 'Australian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','8','AUT', 'Austrian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','9','BAN', 'Bangladeshian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','10','BLR', 'Belarusian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','11','BEL', 'Belgian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','12','BEN', 'Beninese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','13','BOL', 'Bolivian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','14','BOS', 'Bosnian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','15','BOT', 'Botswanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','16','BRA', 'Brazilian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','17','BRI', 'British');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','18','BUL', 'Bulgarian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','19','BRK', 'Burkinese (B. Fasso)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','20','BRM', 'Burmese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','21','BRN', 'Burundese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','22','CMB', 'Cambodian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','23','CAM', 'Cameroonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','24','CAN', 'Canadian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','25','CAF', 'Central African');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','26','CHA', 'Chadian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','27','CHI', 'Chilean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','28','CHI', 'Chinese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','29','COL', 'Colombian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','30','CNB', 'Congolese (Brazaville)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','31','CNC', 'Congolese (DR Congo)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','32','CRO', 'Croatian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','33','CUB', 'Cuban');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','34','DAN', 'Danish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','35','DOM', 'Dominican Republican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','36','DUT', 'Dutch');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','37','ECU', 'Ecuadorian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','38','EGY', 'Egyptian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','39','EQU', 'Equatorial Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','40','ERI', 'Eritrean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','41','EST', 'Estonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','42','ETH', 'Ethiopian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','43','FIL', 'Fillipino');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','44','FIN', 'Finnish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','45','FRE', 'French');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','46','GAB', 'Gabonese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','47','GAM', 'Gambian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','48','GER', 'German');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','49','GHA', 'Ghanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','50','GRE', 'Greek');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','51','GUI', 'Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','52','GUY', 'Guyanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','53','HAI', 'Haitian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','54','HUN', 'Hungarian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','55','ICE', 'Icelandian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','56','IND', 'Indian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','57','IDN', 'Indonesian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','58','IRN', 'Iranian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','59','IRA', 'Iraqi');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','60','IRE', 'Irish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','61','ITA', 'Italian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','62','IVO', 'Ivory Coastan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','63','JAM', 'Jamaican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','64','JAP', 'Japanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','65','JEW', 'Jewish (Israel)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','66','JOR', 'Jordanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','67','KAZ', 'Kazakhstanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','68','KYRG', 'Kyrgyzistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','69','KEN', 'Kenian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','70','LA', 'Laotian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','71','LAT', 'Latvian (Lettish)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','72','LEB', 'Lebanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','73','LES', 'Lesothan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','74','LIB', 'Liberian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','75','LIT', 'Lituanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','76','MLW', 'Malawian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','77','MLS', 'Malasian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','78','MAL', 'Malian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','79','MAU', 'Mauritanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','80','MEX', 'Mexican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','81','MOL', 'Moldavian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','82','MON', 'Mongolian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','83','MOR', 'Morrocan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','84','NAM', 'Namibian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','85','NEP', 'Nepalese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','86','NWG', 'New Guinean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','87','NWZ', 'New Zealandian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','88','NGA', 'Nigerian (Nigeria)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','89','NGE', 'Nigerees (Niger)');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','90','NOR', 'Norvegian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','91','OMA', 'Omani');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','92','PAK', 'Pakistani');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','93','PAR', 'Paraguayan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','94','PER', 'Peruvian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','95','POL', 'Polish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','96','PRT', 'Portuguese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','97','PUE', 'PuertoRican');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','98','ROM', 'Romanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','99','RUS', 'Russian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','100','RSQ', 'Rwandese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','101','SAU', 'Saudi Arabian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','102','SEN', 'Senegalese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','103','SER', 'Serbian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','104','SIE', 'Sierra Leonian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','105','SIN', 'Singaporean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','106','SLO', 'Slovenian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','107','SOM', 'Somalian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','108','SAF', 'South African');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','109','ESP', 'Spanish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','110','SUD', 'Sudanese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','111','SUR', 'Surinamese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','112','SYR', 'Syrian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','113','SWA', 'Swazilandean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','114','SWE', 'Swedish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','115','SWI', 'Swiss');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','116','TAJ', 'Tajikistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','117','TAN', 'Tanzanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','118','THA', 'Thai');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','119','TOG', 'Togolese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','120','TUN', 'Tunisian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','121','TUR', 'Turkish');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','122','TKM', 'Turkmenistanian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','123','UGA', 'Ugandan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','124','UKR', 'Ukranian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','125','URU', 'Uruguayan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','126','UZB', 'Uzbek');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','127','VEN', 'Venezuelan');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','128','VIE', 'Vietnamese');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','129','YEM', 'Yemenite');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','130','ZAM', 'Zambian');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','131','ZIM', 'Zimbabwean');
INSERT INTO opuscollege.nationality (lang,code,descriptionShort,description) VALUES ('nl','132','MOZ', 'Mozambican');

-------------------------------------------------------
-- table country
-------------------------------------------------------
delete from opuscollege.country where lang='nl';

INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ALGERIA','DZ','DZA','012');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ANGOLA','AO','AGO','024');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ARGENTINA','AR','ARG','032');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','AUSTRALIA','AU','AUS','036');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','AUSTRIA','AT','AUT','040');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BANGLADESH','BD','BGD','050');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BELARUS','BY','BLR','112 ');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BELGIUM','BE','BEL','056');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BENIN','BJ','BEN','204');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BOLIVIA','BO','BOL','068');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BOSNIA HERZEGOVINA','BA','BIH','070');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BOTSWANA','BW','BWA','072');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BRAZIL','BR','BRA','076');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BULGARIA','BG','BGR','100');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BURKINA FASO','BF','BFA','854');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','BURUNDI','BI','BDI','108');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CAMEROON','CM','CMR','120');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CANADA','CA','CAN','124');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CABO VERDE','CV','CPV','132');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CENTRAL AFRICAN REPUBLIC','CF','CAF','140');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TCHAD','TD','TCD','148');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CHILE','CL','CHL','152');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CHINA','CN','CHN','156');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','COLOMBIA','CO','COL','170');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','COMORE ISLAND','KM','COM','174');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CONGO','CG','COG','178');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','COSTA RICA','CR','CRI','188');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','COSTA DO MARFIM','CI','CIV','384');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CUBA','CU','CUB','192');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','CHECH REPUBLIC','CZ','CZE','203');  
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','DENMARK','DK','DNK','208');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','DJIBOUTI','DJ','DJI','262');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','EAST TIMOR','TP','TMP','626');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ECUADOR','EC','ECU','218');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','EGYPT','EG','EGY','818');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','EL SALVADOR','SV','SLV','222');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','EQUITORIAL GUINEE','GQ','GNQ','226');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ERITREA','ER','ERI','232');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ETHIOPIA','ET','ETH','210');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','FINLAND','FI','FIN','246');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','FRANCE','FR','FRA','250');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GABON','GA','GAB','266');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GAMBIA','GM','GMB','270');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GERMANY','DE','DEU','276');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GHANA','GH','GHA','288');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GREECE','GR','GRC','300');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GUATEMALA','GT','GTM','320');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GUINEE','GN','GIN','324');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GUINEE-BISSAU','GW','GNB','624');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','HONG KONG','HK','HKG','344');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','HUNGARIA','HU','HUN','348');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','INDIA','IN','IND','356');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','INDONESIA','Id','IdN','360');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','IRAN','IR','IRN','364');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','IRAQ','IQ','IRQ','368');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','IRELAND','IE','IRL','372');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ISRAEL','IL','ISR','376');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ITALY','IT','ITA','380');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','JAMAICA','JM','JAM','388');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','JAPAN','JP','JPN','392');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','KENYA','KE','KEN','404');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NORTH COREA','KP','PRK','408');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SOUTH COREA','KR','KOR','410');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','KUWAIT','KW','KWT','414');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','LEBANON','LB','LBN','422');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','LESOTHO','LS','LSO','426');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','LIBERIA','LR','LBR','430');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','LYBIA','LY','LBY','434');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','LUXEMBURG','LU','LUX','442');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MACAU','MO','MAC','446');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MADAGASCAR','MG','MDG','450');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MALAWI','MW','MWI','454');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MALAYSIA','MY','MYS','458');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MALI','ML','MLI','466');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MAURETANIA','MR','MRT','478');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MAURITIUS','MU','MUS','480');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MEXICO','MX','MEX','484');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MORROCOS','MA','MAR','504');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','MOZAMBIQUE','MZ','MOZ','508');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NAMIBIA','NA','NAM','516');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NETHERLANDS','NL','NLD','528');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NEW ZEALAND','NZ','NZL','554');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NIGER','NE','NER','562');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NIGERIA','NG','NGA','566');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','NORWAY','NO','NOR','578');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PAKISTAN','PK','PAK','586');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PANAMA','PA','PAN','591');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PARAGUAY','PY','PRY','600');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PERU','PE','PER','604');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PHILIPPINES','PH','PHL','608');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','POLAND','PL','POL','616');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PORTUGAL','PT','PRT','620');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','PUERRTO RICO','PR','PRI','630');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','QATAR','QA','QAT','634');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','REUNION','RE','REU','638');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','RUMENIA','RO','ROM','642');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','RUSSIA','RU','RUS','643');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','RWANDA','RW','RWA','646');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SANTO TOMAS AND PRINCIPE','ST','STP','678');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SAUDI ARABIA','SA','SAU','682');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SENEGAL','SN','SEN','686');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SEYCHELLES','SC','SYC','690');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SIERRA LEONE','SL','SLE','694');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SINGAPOUR','SG','SGP','702');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SLOVAKIA','SK','SVK','703');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SOMALIA','SO','SOM','706');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SOUTH AFRICA','ZA','ZAF','710');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SPAIN','ES','ESP','724');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SRI LANKA','LK','LKA','144');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SUDAN','SD','SDN','736');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SWAZILAND','SZ','SWZ','748');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SWEDEN','SE','SWE','752');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SWITZERLAND','CH','CHE','756');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','SYRIA','SY','SYR','760');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TAIWAN','TW','TWN','158');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TANZANIA','TZ','TZA','834');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TAILANDIA','TH','THA','764');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TOGO','TG','TGO','768');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TUNISIA','TN','TUN','788');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','TURKEY','TR','TUR','792');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','UGANDA','UG','UGA','800');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','UKRAINE','UA','UKR','804');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','UNITED ARAB EMIRATES','AE','ARE','784');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','GREAT BRITAIN','GB','GBR','826');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','UNITED STATES','US','USA','840');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','URUGUAY','UY','URY','858');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','VENEZUELA','VE','VEN','862');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','VIETNAM','VN','VNM','704');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','WESTERN SAHARA','EH','ESH','732');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','YEMEN','YE','YEM','887');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','YUGOSLAVIA','YU','YUG','891');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','DR OF CONGO','RC','RDC','180');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ZAMBIA','ZM','ZMB','894');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('nl','ZIMBABWE','ZW','ZWE','716');

-------------------------------------------------------
-- table province
-------------------------------------------------------
DELETE FROM opuscollege.province where lang='nl';
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','01','Central','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','02','Copperbelt','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','03','Eastern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','04','Luapula','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','05','Lusaka','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','06','Northern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','07','North-Western','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','08','Southern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('nl','09','Western','894');

-------------------------------------------------------
-- table district
-------------------------------------------------------
DELETE FROM opuscollege.district where lang='nl';
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-01','Chibombo','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-02','Kabwe','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-03','Kapiri Mposhi','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-04','Mkushi','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-05','Mumbwa','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','01-06','Serenje','01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-01','Chililabombwe','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-02','Chingola','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-03','Kalulushi','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-04','Kitwe','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-05','Luanshya','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-06','Lufwanyama','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-07','Masaiti','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-08','Mpongwe','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-09','Mufulira','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','02-10','Ndola ','02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-01','Chadiza','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-02','Chama','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-03','Chipata','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-04','Katete','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-05','Lundazi','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-06','Mambwe','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-07','Nyimba','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','03-08','Petauke','03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-01','Chiengi','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-02','Kawambwa','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-03','Mansa','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-04','Milenge','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-05','Mwense','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-06','Nchelenge','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','04-07','Samfya','04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','05-01','Chongwe','05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','05-02','Kafue','05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','05-03','Luangwa','05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','05-04','Lusaka','05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-01','Chilubi','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-02','Chinsali','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-03','Isoka','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-04','Kaputa','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-05','Kasama District','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-06','Luwingu','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-07','Mbala','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-08','Mpika','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-09','Mporokoso','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-10','Mpulungu','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','06-11','Mungwi','06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-01','Chavuma','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-02','Kabompo','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-03','Kasempa','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-04','Mufumbwe','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-05','Mwinilunga','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-06','Solwezi','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','07-07','Zambezi','07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-01','Choma','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-02','Gwembe','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-03','Itezhi-Tezhi','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-04','Kalomo','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-05','Kazungula','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-06','Livingstone','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-07','Mazabuka','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-08','Monze','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-09','Namwala','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-10','Siavonga','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','08-11','Sinazongwe','08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-01','Kalabo','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-02','Kaoma','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-03','Lukulu','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-04','Mongu','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-05','Senanga','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-06','Sesheke','09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('nl','09-07','Shangombo','09');

-------------------------------------------------------
-- table administrativePost
-------------------------------------------------------
DELETE FROM opuscollege.administrativePost where lang='nl';
--INSERT INTO opuscollege.administrativePost (lang,code,description,districtCode) VALUES('nl','01-001','Ancuabe','01-01');

-------------------------------------------------------
-- table civilStatus
-------------------------------------------------------
DELETE FROM opuscollege.civilStatus where lang='nl';

INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('nl','1','married');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('nl','2','single');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('nl','3','widow');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('nl','4','divorced');

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
DELETE FROM opuscollege.identificationType where lang='nl';

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('nl','1','BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('nl','2','Coupon Stub of BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('nl','3','passport');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('nl','4','drivers license');

-------------------------------------------------------
-- table language
-------------------------------------------------------
delete from opuscollege.language where lang='nl';

insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'chi', 'Chinese', 'zh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'dut', 'Dutch', 'nl');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'eng', 'English', 'nl');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'fre', 'French', 'fr');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'ger', 'German', 'de');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'ita', 'Italian', 'it');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'jpn', 'Japonese', 'ja');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'por', 'Portuguese', 'pt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'rus', 'Russian', 'ru');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'spa', 'Spanish', 'es');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'zul', 'Zulu', 'zu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'cha', 'Changana', 'ca'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'cho', 'Chope', 'co');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'bit', 'Bitonga', 'bt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'cit', 'Chitsua', 'ci'); 
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'ron', 'Ronga', 'ro');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'sen', 'Sena', 'se');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'nda', 'Ndau', 'nd');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'nhu', 'Nhungue', 'nh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'tev', 'Teve', 'tv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'coa', 'Chona', 'cn');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'nde', 'Ndevele', 'nv');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'nja', 'Nhandja', 'nj');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'chu', 'Chuabo', 'cb');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'lom', 'Lomué', 'lm');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'mac', 'Macua', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'cot', 'Coti', 'ci');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'jaw', 'Jawa', 'jw');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'mac', 'Macondi', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'met', 'Metó', 'mt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'mua', 'Muaní', 'mu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('nl', 'swa', 'Swahili', 'sw');


-------------------------------------------------------
-- table masteringLevel
-------------------------------------------------------
DELETE FROM opuscollege.masteringLevel where lang='nl';
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('nl','1','fluent');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('nl','2','basic');
INSERT INTO opuscollege.masteringLevel (lang,code,description) VALUES ('nl','3','poor');

-------------------------------------------------------
-- table appointmentType
-------------------------------------------------------
DELETE FROM opuscollege.appointmentType where lang='nl';
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('nl','1','tenured');
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('nl','2','associate');

-------------------------------------------------------
-- table staffType
-------------------------------------------------------
DELETE from opuscollege.staffType where lang='nl';

INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('nl','1','Academic');
INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('nl','2','Non-academic');

-------------------------------------------------------
-- table unitArea
-------------------------------------------------------
DELETE from opuscollege.unitArea where lang='nl';

INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('nl','1','Academic');
INSERT INTO opuscollege.unitArea (lang,code,description) VALUES ('nl','2','Administrative');

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType where lang='nl';

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','1','Faculty');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','6','Secretariat');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('nl','7','Institute');

-------------------------------------------------------
-- table academicField
-------------------------------------------------------
DELETE from opuscollege.academicField where lang='nl';

INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','1','Agronomy / Agricultural Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','2','Anthropology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','3','Archeology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','4','Arts and Letters');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','5','Astronomy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','6','Biochemistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','7','Bioethics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','8','Biology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','9','Biotechnology (incl. genetic modification)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','10','Business Administration / Management Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','11','Chemistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','12','Climatology / Climate Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','13','Communication Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','14','Computer Science');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','15','Criminology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','16','Demography (incl. Migration)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','17','Dentistry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','18','Development Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','19','Earth Sciences - Soil');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','20','Earth Sciences - Water');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','21','Economy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','22','Educational Sciences / Pedagogy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','23','Engineering - Construction');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','24','Engineering - Electronic');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','25','Engineering - Industrial');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','26','Engineering - Mechanical');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','28','Environmental Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','29','Ethics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','30','Ethnography');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','31','Food Sciences / Food technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','32','Gender Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','33','Geography');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','34','Geology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','35','History');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','36','ICT - Information Systems');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','37','ICT - Software development');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','38','ICT - Computer Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','39','ICT - Telecommunications Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','40','Informatics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','41','International studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','42','Journalism');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','43','Languages - Arabic');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','44','Languages - Chinese');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','45','Languages - English');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','46','Languages - French');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','47','Languages - German');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','48','Languages - Portuguese');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','49','Languages - Russian');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','50','Languages - Spanish');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','51','Law');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','52','Linguistics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','53','Literature');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','54','Mathematics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','55','Mechanics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','56','Medicine - Anatomy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','57','Medicine - Cardiology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','58','Medicine - Ear, Nose, Throat');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','59','Medicine - Endocrinology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','60','Medicine - General Practice (GP)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','61','Medicine - Geriatrics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','62','Medicine - Gynaecology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','63','Medicine - Immunology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','64','Medicine - Internal specialisms');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','65','Medicine - Locomotor Apparatus (motion diseases)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','66','Medicine - Oncology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','67','Medicine - Ophthalmology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','68','Medicine - Paediatrics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','69','Medicine - Psychiatry');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','70','Medicine - Tropical Medicine');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','71','Medicine - Urology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','72','Microbiology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','73','Nanotechnology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','74','Nuclear Technology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','75','Pharmacy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','76','Philosophy');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','77','Physics');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','78','Political Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','79','Psychology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','80','Religious Studies');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','81','Sciences (natural)');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','82','Social Sciences');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','83','Sociology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','84','Theology');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','85','Medicine');
INSERT INTO opuscollege.academicField (lang,code,description) VALUES ('nl','86','Technology');

-------------------------------------------------------
-- table function
-------------------------------------------------------
DELETE FROM opuscollege.function where lang='nl';

INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','1','Chief Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','2','Associate Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','3','Assistant Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','4','Researcher');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','5','Assistant');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','6','Assistant-stagiaire');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','7','Monitor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','8','Director');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','9','Sub Director of Education');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','10','Sub Director of Research');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','11','Dean of Faculty');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','12','Head of Department');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','13','Head of Vakgroep');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','14','Head of Subject');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('nl','15','Head of Section');

-------------------------------------------------------
-- table functionLevel
-------------------------------------------------------
DELETE FROM opuscollege.functionLevel where lang='nl';
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('nl','1','management');
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('nl','2','non-management');

-------------------------------------------------------
-- table educationType
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.educationType where lang='nl';

INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','-1','Elementary');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','0','Basic');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','1','Secondary school');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','3','Higher education');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','4','Bachelor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','5','Licenciate');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','6','Diploma');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','7','Master');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','8','Doctor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('nl','9','Post graduate');

-------------------------------------------------------
-- table levelOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.levelOfEducation where lang='nl';
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('nl','1','No education');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('nl','2','1.-7. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('nl','3','8.-10. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('nl','4','11.-12. class');
INSERT INTO opuscollege.levelOfEducation (lang,code,description) VALUES ('nl','5','Everything above');

-------------------------------------------------------
-- table fieldOfEducation
-------------------------------------------------------
DELETE FROM opuscollege.fieldOfEducation where lang='nl';
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('nl','1','general');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('nl','2','agricultural');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('nl','3','technical');
INSERT INTO opuscollege.fieldOfEducation (lang,code,description) VALUES ('nl','4','pedagogical');

-------------------------------------------------------
-- table profession
-------------------------------------------------------
DELETE FROM opuscollege.profession where lang='nl';
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','1','accountant');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','2','academic staff (professor)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','3','academic staff (assistant)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','4','artist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','5','baker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','6','bank director');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','7','bank employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','8','buss driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','9','butcher');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','10','civil servant');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','11','cook');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','12','company clerk');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','13','company manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','14','craftsman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','15','dentist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','16','electrician');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','17','engineer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','18','farmer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','19','fisherman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','20','furniture maker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','21','garage manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','22','gardener');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','23','hairdresser');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','24','herdsman (cow, sheep, etc..)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','25','hotel manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','26','hotel employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','27','housewife');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','28','ICT specialist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','29','interpreter');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','30','journalist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','31','lawyer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','32','manual labourer');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','33','market vendor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','34','mechanic');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','35','medical doctor (general practicioner)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','36','medical doctor (specialist)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','37','musician');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','38','nurse (medical, incl. midwife)');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','39','(house-)painter');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','40','postman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','41','psychologist');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','42','restaurant manager');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','43','restaurant employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','44','school director');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','45','salesman');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','46','shop owner');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','47','shop employee');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','48','seamstress');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','49','secretary');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','50','shoemaker');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','51','(black)smith');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','52','teacher primary school');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','53','teacher secondary school');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','54','train conductor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','55','train engine driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','56','tailor');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','57','taxi driver');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','58','waiter/waitress');
INSERT INTO opuscollege.profession (lang,code,description) VALUES ('nl','59','weaver');

-------------------------------------------------------
-- table studyForm
-------------------------------------------------------
DELETE FROM opuscollege.studyForm where lang='nl';
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('nl','1','regular learning');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('nl','2','parallel programme');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('nl','3','distant learning');
INSERT INTO opuscollege.studyForm (lang,code,description) VALUES ('nl','4','various forms');

-------------------------------------------------------
-- table studyTime
-------------------------------------------------------
DELETE FROM opuscollege.studyTime where lang='nl';

INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('nl','D','Daytime');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('nl','E','Evening');

-------------------------------------------------------
-- table targetGroup
-------------------------------------------------------
DELETE FROM opuscollege.targetGroup where lang='nl';
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('nl','1','all students');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('nl','2','students from study');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('nl','3','all international students');
INSERT INTO opuscollege.targetGroup (lang,code,description) VALUES ('nl','4','all national students');

-------------------------------------------------------
-- table contractType
-------------------------------------------------------
DELETE FROM opuscollege.contractType where lang='nl';

INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('nl','1','full');
INSERT INTO opuscollege.contractType (lang,code,description) VALUES ('nl','2','partial');

-------------------------------------------------------
-- table contractDuration
-------------------------------------------------------
DELETE FROM opuscollege.contractDuration where lang='nl';
INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('nl','1','permanent');
INSERT INTO opuscollege.contractDuration (lang,code,description) VALUES ('nl','2','temporary');

-------------------------------------------------------
-- table bloodType
-------------------------------------------------------
DELETE FROM opuscollege.bloodType where lang='nl';

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','5','unknown');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('nl','13','0-Neg');

-------------------------------------------------------
-- table addressType
-------------------------------------------------------
DELETE FROM opuscollege.addressType where lang='nl';
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','1','home');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','2','formal communication address student');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','3','financial guardian');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','4','formal communication address study');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','5','formal communication address organizational unit');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','6','formal communication address work');
INSERT INTO opuscollege.addressType (lang,code,description) VALUES ('nl','7','parents');

-------------------------------------------------------
-- table relationType
-------------------------------------------------------
DELETE FROM opuscollege.relationType where lang='nl';
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('nl','1','brother');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('nl','2','sister');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('nl','3','uncle');
INSERT INTO opuscollege.relationType (lang,code,description) VALUES ('nl','4','aunt');

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
DELETE FROM opuscollege.studyType where lang='nl';

INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','1','lecture');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','2','workshop');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','3','experiment');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','4','self study');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','5','paper');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','6','e-learning');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','7','group work');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','8','individual assistance by teacher');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','9','literature');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','10','lab/practical');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','11','project');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('nl','12','seminar');

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='nl';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','SEC','secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BSC','bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','LIC','licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MSC','master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','PHD','doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BA','bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MA','master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DA','diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DSC','diploma maths and science','Dpl.M.Sc.');

-------------------------------------------------------
-- table endGradeType (for calculations on all levels)
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.endGradeType where lang='nl';

-- fixed values
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','CA','continuous assessment');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','SE','sessional examination');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','SR','subject result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','PC','project course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','AR','attachment result');

-- flexible values, all on level of cardinaltimeunit, thesis and studyplan
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','CTU','cardinal time unit endgrade');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','TR','thesis result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','BSC','bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','BA','bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','MSC','master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','MA','master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','DA','diploma other than maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','DSC','diploma maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','DIST-DEGR','degree programme (distant education)');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','DIST','distant education');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','PHD','doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('nl','LIC','licentiate');



-------------------------------------------------------
-- table frequency
-------------------------------------------------------
DELETE FROM opuscollege.frequency where lang='nl';

INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','1','1');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','2','1,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','3','2');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','4','2,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','5','3');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','6','3,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','7','4');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','8','4,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','9','5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','10','5,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','11','6');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','12','6,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','13','7');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','14','7,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','15','8');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','16','8,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','17','9');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','18','9,5');
INSERT INTO opuscollege.frequency (lang,code,description) VALUES ('nl','19','10');

-------------------------------------------------------
-- table blockType
-------------------------------------------------------
DELETE FROM opuscollege.blockType where lang='nl';
INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('nl','1','thematic');
INSERT INTO opuscollege.blockType (lang,code,description) VALUES ('nl','2','study year');

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
DELETE FROM opuscollege.rigidityType where lang='nl';
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('nl','1','verplicht');
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('nl','3','vrije keuze');

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
DELETE FROM opuscollege.timeUnit where lang='nl';

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','1','semester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','2','semester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','3','trimester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','4','trimester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','5','trimester 3');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','6','semester 1 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','7','semester 1 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','8','semester 2 - block 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','9','semester 2 - block 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('nl','10','yearly');

-------------------------------------------------------
-- table subjectImportance
-------------------------------------------------------
DELETE FROM opuscollege.subjectImportance where lang='nl';
INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('nl','1','major');
INSERT INTO opuscollege.subjectImportance (lang,code,description) VALUES ('nl','2','minor');

-------------------------------------------------------
-- table examType
-------------------------------------------------------
DELETE FROM opuscollege.examType where lang='nl';
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('nl','1','multiple event');
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('nl','2','single event');

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
DELETE FROM opuscollege.examinationType where lang='nl';

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','2','written');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','3','paper');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','4','lab/practical');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','5','thesis');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','6','case study');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','7','presentation');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','100','combined tests');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','101','sessional examination');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','102','continuous assessment');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('nl','8','homework');


-----------------------------------------------------------
-- inserts on TABLE status, which is the status of Student
-----------------------------------------------------------
DELETE FROM opuscollege.status where lang='nl';

INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','1','actief');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','2','tijdelijk inactief');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','3','uitgesloten');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','4','geschorst');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','5','verwijderd');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','6','overleden');

-------------------------------------------------------
-- inserts on TABLE studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='nl';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','1','begin initiële toelating');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','2','wacht op goedkeuring toelating');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','3','toelating afgekeurd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','4','toelating goedgekeurd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','5','begin voortzetting registratie');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','6','wacht op goedkeuring registratie');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','7','registratie afgekeurd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','8','registratie goedgekeurd (wacht op betaling)');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','9','actief geregistreerd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','10','tijdelijk inactief');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','11','afgestudeerd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','12','teruggetrokken');

-----------------------------------------------------------
-- lookup TABLE opusPrivilege
-----------------------------------------------------------
DELETE FROM opuscollege.opusPrivilege where lang='nl';

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'nl', 'Print result slip');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'nl', 'Alter study plan');

INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'nl', 'Editability of student data: all');
INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'nl', 'Editability of student data: personal data');

-----------------------------------------------------------
-- lookup TABLE progressStatus, which is the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='nl';

INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','1','Progression / Clear pass');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','2','Compensatory pass / Proceed and Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','3','To Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','4','At Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','5','To Full-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','6','Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','7','Exclude studygradetype');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','8','Exclude school');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','9','Withdrawn with permission');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('nl','10','Graduate');

-----------------------------------------------------------
-- lookup TABLE rfcStatus, which is the status of an rfc on a certain entity
-----------------------------------------------------------
DELETE FROM opuscollege.rfcStatus where lang='nl';

INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('nl','1','Nieuw');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('nl','2','Opgelost');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('nl','3','Geweigerd');


