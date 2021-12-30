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
-- Date:   2013-04-09
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('scholarship', 'A', 'Y', 4.04);

-------------------------------------------------------
-- table sch_sponsorPayment
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsorPayment DROP COLUMN transferId;
ALTER TABLE opuscollege.sch_sponsorPayment DROP COLUMN sponsorId;
ALTER TABLE opuscollege.sch_sponsorPayment ADD COLUMN sponsorInvoiceId integer NOT NULL REFERENCES opuscollege.sch_sponsorInvoice (id);
ALTER TABLE opuscollege.sch_sponsorPayment ADD COLUMN amount numeric(10,2) NOT NULL;

DROP SEQUENCE opuscollege.sch_sponsorpaymenttransfer_seq;

-------------------------------------------------------
-- table sch_sponsorInvoice
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsorinvoice ALTER COLUMN invoiceNumber SET NOT NULL;
ALTER TABLE opuscollege.sch_sponsorinvoice ALTER COLUMN invoiceDate SET NOT NULL;
ALTER TABLE opuscollege.sch_sponsorinvoice ALTER COLUMN amount SET NOT NULL;

-------------------------------------------------------
-- table sch_scholarshipFeePercentage
-------------------------------------------------------

TRUNCATE opuscollege.sch_scholarshipFeePercentage;
CREATE SEQUENCE opuscollege.sch_scholarshipFeePercentage_transer_seq;
ALTER SEQUENCE opuscollege.sch_scholarshipFeePercentage_transer_seq OWNER TO postgres;

ALTER TABLE opuscollege.sch_scholarshipFeePercentage ADD COLUMN transferId integer;
ALTER TABLE opuscollege.sch_scholarshipFeePercentage ALTER COLUMN transferId SET NOT NULL;
ALTER TABLE opuscollege.sch_scholarshipFeePercentage ALTER COLUMN transferId SET DEFAULT nextval('opuscollege.sch_scholarshipFeePercentage_seq'::regclass);

-------------------------------------------------------
-- table sch_scholarship
-------------------------------------------------------

ALTER TABLE opuscollege.sch_scholarship DROP COLUMN academicYearId;

