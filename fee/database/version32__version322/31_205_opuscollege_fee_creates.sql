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

-- Opus College (c) UNZA - Katuta G.C. Kaunda - September 2011
--
-- KERNEL opuscollege / MODULE fee
-- 

DROP SEQUENCE IF EXISTS opuscollege.fee_feeType_seq CASCADE;
DROP TABLE IF EXISTS opuscollege.fee_feeTypes;

CREATE SEQUENCE opuscollege.fee_feeType_seq;
ALTER TABLE opuscollege.fee_feeType_seq OWNER TO postgres;

-------------------------------------------------------
-- table fee_feeType
-------------------------------------------------------
CREATE TABLE opuscollege.fee_feeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_feeType_seq'),
    feeTypeCode VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    
    --
    PRIMARY KEY(id),
    UNIQUE(feeTypeCode)
);
ALTER TABLE opuscollege.fee_feeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.fee_feeType TO postgres;
