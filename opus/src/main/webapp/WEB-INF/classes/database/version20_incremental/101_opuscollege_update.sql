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

ALTER TABLE opuscollege.appVersions DROP column coreDb;
ALTER TABLE opuscollege.appVersions DROP column coreWar;
ALTER TABLE opuscollege.appVersions DROP column reportsJar;
ALTER TABLE opuscollege.appVersions ADD column scholarshipDb numeric(5,2) NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.appVersions ADD column coreDb numeric(5,2) NOT NULL DEFAULT 1.00;

INSERT INTO opuscollege.appVersions (coreDb) VALUES(1.01);

-------------------------------------------------------
-- table gender
-------------------------------------------------------

delete from opuscollege.gender;

INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','1','male');
INSERT INTO opuscollege.gender (lang,code,description) VALUES ('en','2','female');

INSERT INTO opuscollege.gender (lang,code,description) VALUES ('pt','1','masculino');
INSERT INTO opuscollege.gender (lang,code,description) VALUES ('pt','2','feminino');

-------------------------------------------------------
-- table country
-------------------------------------------------------

delete from opuscollege.country;

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
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('en','CAPO VERDE','CV','CPV','132');
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

INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARGELIA','DZ','DZA','012');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ANGOLA','AO','AGO','024');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARGENTINA','AR','ARG','032');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','AUSTRALIA','AU','AUS','036');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','AUSTRIA','AT','AUT','040');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BANGLADESH','BD','BGD','050');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BIOLORUSSIA','BY','BLR','112 ');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BÉLGICA','BE','BEL','056');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BENIN','BJ','BEN','204');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOLIVIA','BO','BOL','068');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOSNIA HERZEGOVINA','BA','BIH','070');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BOTSWANA','BW','BWA','072');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BRASIL','BR','BRA','076');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BULGARIA','BG','BGR','100');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BURKINA FASO','BF','BFA','854');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','BURUNDI','BI','BDI','108');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CAMARÕES','CM','CMR','120');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CANADA','CA','CAN','124');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CABO VERDE','CV','CPV','132');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','REPÚBLICA CENTRO AFRICANA','CF','CAF','140');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHADE','TD','TCD','148');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHILE','CL','CHL','152');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CHINA','CN','CHN','156');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COLOMBIA','CO','COL','170');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHAS COMORES','KM','COM','174');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CONGO','CG','COG','178');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COSTA RICA','CR','CRI','188');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','COSTA DO MARFIM','CI','CIV','384');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','CUBA','CU','CUB','192');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','REPÚBLICA CHECA','CZ','CZE','203');  
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','DINAMARCA','DK','DNK','208');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','DJIBOUTI','DJ','DJI','262');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','TIMOR LESTE','TP','TMP','626');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EQUADOR','EC','ECU','218');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EGIPTO','EG','EGY','818');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','EL SALVADOR','SV','SLV','222');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUINÉ EQUATORIAL','GQ','GNQ','226');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ERITREA','ER','ERI','232');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ETIOPIA','ET','ETH','210');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FINLANDIA','FI','FIN','246');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FRANCA','FR','FRA','250');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GABAÕ','GA','GAB','266');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GAMBIA','GM','GMB','270');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ALEMANHA','DE','DEU','276');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GHANA','GH','GHA','288');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GRECIA','GR','GRC','300');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUATEMALA','GT','GTM','320');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUINÉ CONACRI','GN','GIN','324');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','GUINÉ-BISSAU','GW','GNB','624');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HONG KONG','HK','HKG','344');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HUNGRIA','HU','HUN','348');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','INDIA','IN','IND','356');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','INDONÉSIA','Id','IdN','360');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRAÕ (ISLAMIC REPUBLIC OF)','IR','IRN','364');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRAQUE','IQ','IRQ','368');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','IRLANDA','IE','IRL','372');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ISRAEL','IL','ISR','376');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ITALIA','IT','ITA','380');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','JAMAICA','JM','JAM','388');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','JAPAÕ','JP','JPN','392');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KENYA','KE','KEN','404');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KOREA DO NORTE','KP','PRK','408');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KOREA DO SUL','KR','KOR','410');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','KUWAIT','KW','KWT','414');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LÍBANO','LB','LBN','422');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LESOTHO','LS','LSO','426');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LIBÉRIA','LR','LBR','430');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LIBIA','LY','LBY','434');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','LUXEMBURGO','LU','LUX','442');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MACAU','MO','MAC','446');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MADAGASCAR','MG','MDG','450');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALAWI','MW','MWI','454');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALASIA','MY','MYS','458');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MALI','ML','MLI','466');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MAURITANIA','MR','MRT','478');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHA DAS MAURICIAS','MU','MUS','480');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MÉXICO','MX','MEX','484');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MORROCOS','MA','MAR','504');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','MOCAMBIQUE','MZ','MOZ','508');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NAMIBIA','NA','NAM','516');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','HOLANDA','NL','NLD','528');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NOVA ZELANDIA','NZ','NZL','554');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NIGER','NE','NER','562');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NIGERIA','NG','NGA','566');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','NOROEGA','NO','NOR','578');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PAQUISTAÕ','PK','PAK','586');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PANAMÁ','PA','PAN','591');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PARAGUAI','PY','PRY','600');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PERÚ','PE','PER','604');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','FILIPINAS','PH','PHL','608');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','POLÓNIA','PL','POL','616');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PORTUGAL','PT','PRT','620');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','PORTO RICO','PR','PRI','630');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','QATAR','QA','QAT','634');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ILHA DE REUNIAÕ','RE','REU','638');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ROMENIA','RO','ROM','642');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','RUSSIA','RU','RUS','643');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','RUANDA','RW','RWA','646');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SAO TOMÉ E PRINCIPE','ST','STP','678');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ARABIA SAUDITA','SA','SAU','682');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SENEGAL','SN','SEN','686');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SEYCHELLES','SC','SYC','690');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SERRA LEOA','SL','SLE','694');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SINGAPURA','SG','SGP','702');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ESLOVAQUIA','SK','SVK','703');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SOMALIA','SO','SOM','706');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ÁFRICA DO SUL','ZA','ZAF','710');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','ESPANHA','ES','ESP','724');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SRI LANKA','LK','LKA','144');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SUDAO','SD','SDN','736');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SWAZILANDIA','SZ','SWZ','748');
INSERT INTO opuscollege.country (lang,description,short2,short3,code) VALUES('pt','SUÉCIA','SE','SWE','752');
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
-- table language
-------------------------------------------------------

delete from opuscollege.language;

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

insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'chi', 'Chinês', 'zh');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'dut', 'Holandês', 'nl');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'eng', 'Inglês', 'en');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'fre', 'Francês', 'fr');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'ger', 'Alemão', 'de');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'ita', 'Italiano', 'it');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'jpn', 'Japonês', 'ja');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'por', 'Português', 'pt');
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
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'lom', 'Lomué', 'lm');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mac', 'Macua', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'cot', 'Coti', 'ci');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'jaw', 'Jawa', 'jw');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mac', 'Macondi', 'mc');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'met', 'Metó', 'mt');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'mua', 'Muaní', 'mu');
insert into opuscollege.language(lang, code, description, descriptionShort) values ('pt', 'swa', 'Swahili', 'sw');

-------------------------------------------------------
-- table appointmentType 
-------------------------------------------------------

delete from opuscollege.appointmentType;

INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','1','tenured');
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('en','2','temporary');

INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('pt','1','tempo indeterminado');
INSERT INTO opuscollege.appointmentType (lang,code,description) VALUES ('pt','2','temporário');

-------------------------------------------------------
-- table role
-------------------------------------------------------

UPDATE opuscollege.role SET roleDescription = 'administrador central avaliação institucional' WHERE lang = 'pt' AND role = 'admin-C';
UPDATE opuscollege.role SET roleDescription = 'administrador central avaliação das delegações' WHERE lang = 'pt' AND role = 'admin-B';

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------

UPDATE opuscollege.study SET 
    studyDescription = 'Biomatemática'
    WHERE studyDescription = 'Biomatem&aacute;tica';

UPDATE opuscollege.study SET 
    studyDescription = 'Biologia Médica'
    WHERE studyDescription = 'Biologia M&eacute;dica';

UPDATE opuscollege.study SET 
    studyDescription = 'Química Médica'
    WHERE studyDescription = 'Qu&iacute;mica M&eacute;dica';

-------------------------------------------------------
-- TABLE expellationType (new)
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.expellationTypeSeq CASCADE;
CREATE SEQUENCE opuscollege.expellationTypeSeq;
ALTER TABLE opuscollege.expellationTypeSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.expellationType CASCADE;

CREATE TABLE opuscollege.expellationType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.expellationTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.expellationType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.expellationType TO postgres;

INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('en','1','Falsification of certificates');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('en','2','Academic fraude');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('en','3','Disobedience');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('en','4','Other motives');

INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('pt','1','Certificado falso');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('pt','2','Fraude académica');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('pt','3','Indisciplina');
INSERT INTO opuscollege.expellationType (lang,code,description) VALUES ('pt','4','Outros motivos');

-------------------------------------------------------
-- TABLE student
-------------------------------------------------------
ALTER TABLE opuscollege.student drop column expellationForFalseCertificates;
ALTER TABLE opuscollege.student add column expellationEndDate DATE;
ALTER TABLE opuscollege.student add column expellationTypeCode VARCHAR;
ALTER TABLE opuscollege.student add column previousInstitutionDiplomaPhotographRemarks VARCHAR;


-------------------------------------------------------
-- table staffType
-------------------------------------------------------
DELETE from opuscollege.staffType;

INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','1','Academic');
INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('en','2','Non-academic');

INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('pt','1','Corpo docente');
INSERT INTO opuscollege.staffType (lang,code,description) VALUES ('pt','2','CTA (corpo técnico/adm.)');


-------------------------------------------------------
-- table functionLevel
-------------------------------------------------------
DELETE from opuscollege.functionLevel;

INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','1','management');
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('en','2','non-management');

INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('pt','1','administração');
INSERT INTO opuscollege.functionLevel (lang,code,description) VALUES ('pt','2','não administracão');

-------------------------------------------------------
-- table educationType
-------------------------------------------------------
DELETE FROM opuscollege.educationType;

INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','1','Elementary');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','2','Basic');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','3','Secondary school');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','4','Bachelor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','5','Licenciate');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','6','Diploma');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','7','Master');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','8','Doctor');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('en','9','Post graduate');

INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','1','Elementar');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','2','Básico');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','3','Médio');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','4','Bacharel');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','5','Licenciado');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','6','Diploma');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','7','Mestre');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','8','Doutorado');
INSERT INTO opuscollege.educationType (lang,code,description) VALUES ('pt','9','Pós graduação');

-------------------------------------------------------
-- table frequency
-------------------------------------------------------
DELETE FROM opuscollege.frequency;

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
-- table examType
-------------------------------------------------------
DELETE FROM opuscollege.examType;
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','1','multiple event');
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('en','2','single event');

INSERT INTO opuscollege.examType (lang,code,description) VALUES ('pt','1','uncia forma');
INSERT INTO opuscollege.examType (lang,code,description) VALUES ('pt','2','varias formas');

-------------------------------------------------------
-- table studyTime
-------------------------------------------------------
DELETE FROM opuscollege.studyTime;
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','1','daytime');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','2','evening');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('en','3','daytime&evening');

INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','1','diurno');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','2','nocturno');
INSERT INTO opuscollege.studyTime (lang,code,description) VALUES ('pt','3','diurno&nocturno');

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
DELETE FROM opuscollege.rigidityType;
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','1','compulsory');
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('en','3','optional');

INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('pt','1','compulsório');
INSERT INTO opuscollege.rigidityType (lang,code,description) VALUES ('pt','3','opcional');

-------------------------------------------------------
-- studyYear
-------------------------------------------------------

ALTER TABLE opuscollege.studyYear ALTER COLUMN coursestructurevalidfromyear DROP NOT NULL;
ALTER TABLE opuscollege.studyYear ALTER COLUMN coursestructurevalidthroughyear DROP NOT NULL;

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType;

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','2','secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','3','bachelor','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','4','licentiate','Lic.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','5','master','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','6','doctor','Ph.D.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','2','ensino secundária','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','3','bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','4','licenciatura','Lic.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','5','mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','6','Ph.D.','Ph.D.');

-------------------------------------------------------
-- table status
-------------------------------------------------------

DELETE FROM opuscollege.status;

INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','1','active');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','2','temporary inactive');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','3','stopped without diploma');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','4','graduated');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','5','deceased');

INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','1','activo');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','2','temporário inactivo');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','3','parado sem diploma');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','4','graduado');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','5','falecido');


-- 25/1/2008

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
DELETE FROM opuscollege.identificationType;

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','1','BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','2','Coupon Stub of BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','3','passport');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','4','drivers license');

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','1','BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','2','Talão de BI');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','3','Passaporte');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('pt','4','DIRE');

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType;

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','Faculty');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','1','Faculdade');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','2','Departamento');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','3','Repartição');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','4','Secção');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','5','Direcção');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','6','Secretaría');

-------------------------------------------------------
-- table function
-------------------------------------------------------
DELETE FROM opuscollege.function;

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
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','13','Head of Vakgroep??');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','14','Head of Subject');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','15','Head of Section');

INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','1','Professor Catedrático');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','2','Professor Associado');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','3','Professor Auxiliar');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','4','Investigador');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','5','Assistente');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','6','Assistente-Estagiário');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','7','Monitor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','8','Director');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','9','Director Adjunto para Docência');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','10','Director Adjunto para Investigaçao');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','11','Director de faculdade');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','12','Chefe de Departamento');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','13','Chefe de Repartição');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','14','Director de Curso');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('pt','15','Chefe de Secção');

-------------------------------------------------------
-- table studyType
-------------------------------------------------------

DELETE FROM opuscollege.studyType;

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

INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','1','aula');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','2','workshop');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','3','experimentação');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','4','estudo individual');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','5','trabalho escrito');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','6','e-Learning');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','7','trabalho de grupo');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','8','assistência individual pelo professor');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','9','literatura');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','10','laboratório/práctica');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','11','projecto');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('pt','12','seminário');

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------

DELETE FROM opuscollege.examinationType;

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','2','written');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','3','paper');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','4','lab/practical');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','5','thesis');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','6','case study');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','7','presentation');

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','2','escrito');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','3','trabalho escrito');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','4','laboratório/practica');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','5','tese');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','6','caso de estudo');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','7','apresentação');

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------

DELETE FROM opuscollege.timeUnit;

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','1','semester 1');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','2','semester 2');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('en','3','yearly');

INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','1','I semestre');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','2','II semestre');
INSERT INTO opuscollege.timeUnit (lang,code,description) VALUES ('pt','3','anual');

-------------------------------------------------------
-- table civilStatus
-------------------------------------------------------
DELETE FROM opuscollege.civilStatus;

INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','1','married');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','2','single');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','3','widow');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('en','4','divorced');

INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','1','casado/casada');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','2','solteiro/solteira');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','3','viúvo/viúva');
INSERT INTO opuscollege.civilStatus (lang,code,description) VALUES ('pt','4','divorciado/divorciada');


 