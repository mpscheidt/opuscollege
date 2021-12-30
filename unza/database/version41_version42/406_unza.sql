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
 * The Original Code is Opus-College unza module code.
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
-- Author: Janneke Nooitgedagt
-- Date: 2013-02-13
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'unza';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('unza','A','Y',4.06);

-------------------------------------------------------
-- inserts in table exclusion
-------------------------------------------------------

INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2044', '2046');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2046', '2044');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2150', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2151', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2152', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2155', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2156', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2158', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2158', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2158', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2158', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2160', '2167');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2150');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2151');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2152');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2155');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2158');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('2167', '2160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3150', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3153', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3153', '3156');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3153', '3160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3153', 'G403');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3153', 'G404');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3154', '3153');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3154', '3156');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3154', '3160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3154', 'G403');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3154', 'G404');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3156', '3153');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3156', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3156', '3160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3156', 'G403');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3156', 'G404');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3160', '3153');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3160', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3160', '3156');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3160', 'G403');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('3160', 'G404');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5037', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5054', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5054', '7000');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5054', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5054', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5070', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5070', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5070', '6065');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5070', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5070', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', '6065');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5090', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5096', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', '5054');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', '5070');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', '7000');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5124', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5054');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5070');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', '7000');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('5129', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('6040', '6044');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('6044', '6040');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('6065', '5070');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('6065', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('6065', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7000', '5054');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7000', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7000', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7000', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7000', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7040', '7045');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7045', '7040');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7100', '7102');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7100', '7110');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7100', 'G306');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7102', '7100');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7102', '7110');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7110', '7100');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('7110', '7102');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', '5054');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', '5070');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', '7000');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G203', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G205', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G206', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G206', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G206', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G206', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G206', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', '6065');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G207', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G209', 'G301');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5037');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5054');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5070');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5090');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5096');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5124');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '5129');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', '7000');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', 'G203');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', 'G206');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', 'G207');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G301', 'G209');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G306', '7100');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G403', '3153');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G403', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G403', '3156');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G403', '3160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G403', 'G404');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G404', '3153');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G404', '3154');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G404', '3156');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G404', '3160');
INSERT INTO opuscollege.exclusion(subject1, subject2) VALUES ('G404', 'G403');



