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
-- Date:   2013-04-10
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('scholarship', 'A', 'Y', 4.05);

-------------------------------------------------------
-- table sch_sponsorInvoice
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsorinvoice DROP COLUMN sponsorId;
ALTER TABLE opuscollege.sch_sponsorinvoice ADD COLUMN scholarshipId integer NOT NULL REFERENCES opuscollege.sch_scholarship (id);
ALTER TABLE opuscollege.sch_sponsorinvoice ADD COLUMN cleared boolean NOT NULL DEFAULT FALSE;
ALTER TABLE opuscollege.sch_sponsorinvoice ALTER COLUMN invoiceNumber TYPE CHARACTER VARYING;
ALTER TABLE opuscollege.sch_sponsorinvoice ADD CONSTRAINT invoiceNumber_uq UNIQUE (invoiceNumber);

-------------------------------------------------------
-- table sch_sponsorInvoice_hist
-------------------------------------------------------

CREATE TABLE audit.sch_sponsorInvoice_hist
(
  operation character(1) NOT NULL,
  id integer NOT NULL ,
  scholarshipId integer NOT NULL,
  invoiceNumber character varying NOT NULL,
  invoiceDate DATE NOT NULL,
  amount numeric(10,2) NOT NULL,
  cleared boolean NOT NULL,
  active character(1) NOT NULL,
  writewho character varying NOT NULL ,
  writewhen timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE audit.sch_sponsorInvoice_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.sch_sponsorInvoice_hist TO postgres;


-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORINVOICES','en','Y','Create sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORINVOICES','nl','Y','Create sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SPONSORINVOICES','pt','Y','Create sponsor invoices');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORINVOICES','en','Y','Read sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORINVOICES','pt','Y','Read sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SPONSORINVOICES','nl','Y','Read sponsor invoices');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORINVOICES','en','Y','Update sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORINVOICES','pt','Y','Update sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SPONSORINVOICES','nl','Y','Update sponsor invoices');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORINVOICES','en','Y','Delete sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORINVOICES','pt','Y','Delete sponsor invoices');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SPONSORINVOICES','nl','Y','Delete sponsor invoices');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_SPONSORINVOICES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','CREATE_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','UPDATE_SPONSORINVOICES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','DELETE_SPONSORINVOICES');

-------------------------------------------------------
-- table sch_scholarshipapplication
-------------------------------------------------------

ALTER TABLE opuscollege.sch_scholarshipapplication DROP CONSTRAINT fk_scholarshiptypeyeargrantedid;
ALTER TABLE opuscollege.sch_scholarshipapplication DROP CONSTRAINT fk_scholarshiptypeyearappliedforid;
