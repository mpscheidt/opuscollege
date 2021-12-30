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

-- Opus College (c) UCI - Markus Pscheidt
--
-- 
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.47);

-------------------------------------------------------
-- table endgrade
-------------------------------------------------------

ALTER TABLE opuscollege.endgrade ADD COLUMN academicYearId integer;

UPDATE opuscollege.endgrade set academicYearId = (select min(id) from opuscollege.academicyear);

ALTER TABLE opuscollege.endgrade ALTER COLUMN academicyearid SET NOT NULL;


-- replicate endgrade for all existing academic years

CREATE OR REPLACE FUNCTION opuscollege.replicateEndgrades()
  RETURNS integer AS
$BODY$
DECLARE
    mviews RECORD;
    endgrade RECORD;
    a_output text;
BEGIN

    FOR mviews IN select academicyear.id from opuscollege.academicyear where id <> (select min(academicyear.id) from opuscollege.academicyear) LOOP

        for endgrade IN select * from opuscollege.endgrade where academicyearid = (select min(academicyear.id) from opuscollege.academicyear) order by id loop

            a_output := $$INSERT INTO opuscollege.endgrade (code, lang, active, endgradetypecode, gradepoint, percentagemin, percentagemax, "comment", description, temporarygrade, passed, academicyearid) values (
            '$$ || endgrade.code || $$', 
            '$$ || endgrade.lang || $$', 
            '$$ || endgrade.active || $$', 
            '$$ || endgrade.endgradetypecode || $$', 
            $$ || endgrade.gradepoint || $$, 
            $$ || endgrade.percentagemin || $$, 
            $$ || endgrade.percentagemax || $$, 
            '$$ || endgrade."comment" || $$', 
            '$$ || endgrade.description || $$', 
            '$$ || endgrade.temporarygrade || $$', 
            '$$ || endgrade.passed || $$', 
            $$ || mviews.id || $$
            )$$;

            EXECUTE a_output;
    end loop;
    END LOOP;


    RETURN 1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION opuscollege.replicateEndgrades() OWNER TO postgres;

SELECT opuscollege.replicateEndgrades();

DROP function opuscollege.replicateEndgrades();

-- end of replication of endgrade for all academic years


