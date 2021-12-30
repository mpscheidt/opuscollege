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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'unza';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('unza','A','Y',3.18);


-------------------------------------------------------
-- table financialRequest
-------------------------------------------------------
ALTER TABLE opuscollege.financialRequest ADD COLUMN writeWhen TIMESTAMP NOT NULL DEFAULT now();

-------------------------------------------------------
-- table financialRequest_hist
-------------------------------------------------------
CREATE TABLE audit.financialRequest_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
    writewho character varying NOT NULL,
    id INTEGER NOT NULL,
    requestId VARCHAR,
    requestTypeId integer DEFAULT 0,
    financialRequestId VARCHAR,
    statusCode INTEGER NOT NULL,
    timestampReceived timestamp without time zone,
    requestVersion VARCHAR,
    requestString VARCHAR,
    timestampModified timestamp without time zone,
    errorCode INTEGER NOT NULL,
    processedToFinanceTransaction character(1) NOT NULL DEFAULT 'N'::bpchar,
    errorReportedToFinancialSystem character(1) NOT NULL DEFAULT 'N'::bpchar,
    PRIMARY KEY(id)
);
ALTER TABLE audit.financialRequest_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.financialRequest_hist TO postgres;

-------------------------------------------------------
-- tables audit schema -> no primary key
-------------------------------------------------------
alter TABLE audit.financialRequest_hist DROP CONSTRAINT financialrequest_hist_pkey;

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfStudentBalancesGeneration','Y');
    
-------------------------------------------------------
-- table mailConfig
-------------------------------------------------------

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_admission', 'en', 'Your request for admission has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.', 'academicoffice@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_admission', 'en_ZM', 'Your request for admission has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.','academicoffice@unza.zm');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_admission', 'en', 'Your request for admission has been set to status waiting-for-selection.','Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.', 'academicoffice@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_admission', 'en_ZM', 'Your request for admission has been set to status waiting-for-selection.','Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.','academicoffice@unza.zm');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_registration', 'en', 'Your request for continued registration has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.', 'registry@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_registration', 'en_ZM', 'Your request for continued registration has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.','registry@unza.zm');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_registration', 'en', 'Your request for continued registration has been set to status waiting-for-selection.','Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.', 'registry@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_registration', 'en_ZM', 'Your request for continued registration has been set to status waiting-for-selection.','Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.','registry@unza.zm');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforapproval_registration', 'en', 'Your request for continued registration has been set to status waiting-for-approval.','Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.', 'registry@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforapproval_registration', 'en_ZM', 'Your request for continued registration has been set to status waiting-for-approval.','Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.','registry@unza.zm');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('requestforchange_registration', 'en', 'Your request for continued registration has been set to status request-for-change.','Your request for continued registration has been set to status request-for-change.<br />Your request for change has been received by the corresponding officer at the university.', 'registry@unza.zm');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('requestforchange_registration', 'en_ZM', 'Your request for continued registration has been set to status request-for-change.','Your request for continued registration has been set to status request-for-change.<br />Your request for change has been received by the corresponding officer at the university.','registry@unza.zm');
