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
 * The Original Code is Opus-College scholarship module code.
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
-- Author: Markus Pscheidt
-- Date:   2013-04-17
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.06 WHERE lower(module) = 'scholarship';

-------------------------------------------------------
-- table sch_sponsorPayment
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsorPayment ADD COLUMN receiptNumber CHARACTER VARYING NOT NULL UNIQUE;

-------------------------------------------------------
-- table sch_sponsorPayment_hist
-------------------------------------------------------

CREATE TABLE audit.sch_sponsorPayment_hist
(
  operation character(1) NOT NULL,
  id integer NOT NULL ,
  sponsorInvoiceId integer NOT NULL,
  paymentreceiveddate character varying NOT NULL,
  amount character varying NOT NULL ,
  receiptNumber character varying NOT NULL,
  writewho character varying NOT NULL ,
  writewhen timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE audit.sch_scholarshipFeePercentage_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.sch_scholarshipFeePercentage_hist TO postgres;


-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORPAYMENTS','en','Y','Create sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORPAYMENTS','nl','Y','Create sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORPAYMENTS','pt','Y','Create sponsor payments');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORPAYMENTS','en','Y','Read sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORPAYMENTS','pt','Y','Read sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORPAYMENTS','nl','Y','Read sponsor payments');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORPAYMENTS','en','Y','Update sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORPAYMENTS','pt','Y','Update sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORPAYMENTS','nl','Y','Update sponsor payments');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORPAYMENTS','en','Y','Delete sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORPAYMENTS','pt','Y','Delete sponsor payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORPAYMENTS','nl','Y','Delete sponsor payments');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_SPONSORPAYMENTS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','CREATE_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','UPDATE_SPONSORPAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','DELETE_SPONSORPAYMENTS');

