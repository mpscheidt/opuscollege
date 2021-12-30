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
 * The Original Code is Opus-College ucm module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'ucm';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('ucm','A','Y',3.03);

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'smtpServerAdress','smtp.ucm.ac.mz');

    INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'smtpBulkServerAdress','smtp.ucm.ac.mz');

    -------------------------------------------------------
-- table mailConfig
-------------------------------------------------------
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('rejected_admission', 'en', 'Your request for admission has been denied','Unfortunately your request for admission has been denied.<br />Please contact the dean of the school or the academic office for more information.', 'academicoffice@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('rejected_admission', 'pt', 'Your request for admission has been denied','Unfortunately your request for admission has been denied.<br />Please contact the dean of the school or the academic office for more information.','academicoffice@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('approved_admission', 'en', 'Your request for admission has been granted','Your request for admission has been granted.<br />Please contact the dean of the school or the academic office for more information on how to proceed.', 'academicoffice@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('approved_admission', 'pt', 'Your request for admission has been granted','Your request for admission has been granted.<br />Please contact the dean of the school or the academic office for more information on how to proceed.','academicoffice@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('rejected_registration', 'en', 'Your request for registration has been denied','Unfortunately your request for registration has been denied.<br />Please contact the dean of the school for more information.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('rejected_registration', 'pt', 'Your request for registration has been denied','Unfortunately your request for registration has been denied.<br />Please contact the dean of the school for more information.','registry@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('actively_registered', 'en', 'Your request for registration has been granted','Your request for registration has been granted.<br />Please contact the dean of the school for more information on how to proceed.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('actively_registered', 'pt', 'Your request for registration has been granted','Your request for registration has been granted.<br />Please contact the dean of the school for more information on how to proceed.','registry@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('customize_programme', 'en', 'Your request for registration is in customize programme phase','Your request for registration is in customize programme phase.<br />Please login to the unza website and review the courses you are subscribed to.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('customize_programme', 'pt', 'Your request for registration is in customize programme phase','Your request for registration is in customize programme phase.<br />Please login to the unza website and review the courses you are subscribed to.','registry@ucm.ac.mz');
