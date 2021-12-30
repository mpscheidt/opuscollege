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
 * The Original Code is Opus-College fee module code.
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
 * ***** END LICENSE BLOCK *****/

-- 
-- Author: Stelio Macumbe
-- Date:   2012-07-16
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',3.19);

-------------------------------------------------------
-- table fee_FeeDeadLine
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.fee_feeDeadlineSeq CASCADE;
CREATE SEQUENCE opuscollege.fee_feeDeadlineSeq;

ALTER TABLE opuscollege.fee_feeDeadlineSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.fee_FeeDeadline CASCADE;

CREATE TABLE opuscollege.fee_FeeDeadline (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_feeDeadlineSeq'), 
    feeId INT NOT NULL REFERENCES opuscollege.fee_fee(id) ON UPDATE CASCADE,
    deadline DATE NOT NULL ,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-fees',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);

ALTER TABLE opuscollege.fee_FeeDeadline OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fee_FeeDeadline TO postgres;

---copy existing deadlines to new table
INSERT INTO opuscollege.fee_feedeadline(feeid, deadline)
SELECT id, deadline FROM opuscollege.fee_fee;

ALTER TABLE opuscollege.fee_feedeadline ADD CONSTRAINT fee_feedeadline_unique_fee_deadline UNIQUE(feeId, deadline);

--remove deadline column
ALTER TABLE opuscollege.fee_fee DROP COLUMN deadline;

DROP TABLE IF EXISTS audit.fee_FeeDeadline_hist CASCADE;

-------------------------------------------------------
-- table audit.fee_FeeDeadline_hist
-------------------------------------------------------

CREATE TABLE audit.fee_FeeDeadline_hist (
    operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),    
    id INTEGER , 
    feeId INT ,
    deadline DATE,
    active CHAR(1) ,
    writeWho VARCHAR,
    writeWhen TIMESTAMP NOT NULL DEFAULT now()
);

ALTER TABLE audit.fee_FeeDeadline_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.fee_FeeDeadline_hist TO postgres;


