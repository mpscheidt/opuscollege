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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('ucm','A','Y',3.01);

-------------------------------------------------------
-- change schema definitions
-- required format: <running number> <2 digits for branch code>
--                  branch code shall be constant for all ids generated at branch
-- example: 101 = number 1 for branch 1
--          201 = number 2 for branch 1
--          135 = number 1 for branch 35
--          235 = number 2 for branch 35
-------------------------------------------------------

-- drop function opuscollege.rename_col_obsolete_to_active();

-- drop function opuscollege.rename_col_obsolete_to_active();

CREATE FUNCTION opuscollege.prepare_sequences_for_symmetricds() RETURNS integer AS $PROC$
DECLARE
    sequence RECORD;
    curid integer;
    curid2 integer;
    start integer;
BEGIN
--    PERFORM cs_log('Preparing sequences for node ??');

    FOR sequence IN select * 
        from information_schema.sequences
        where sequence_schema = 'opuscollege'
        LOOP

    EXECUTE $$SELECT nextval('opuscollege.$$ || sequence.sequence_name || $$')$$ INTO curid;
    EXECUTE $$SELECT nextval('opuscollege.$$ || sequence.sequence_name || $$')$$ INTO curid2;
    
    -- check if this sequence has been converted already
    if ((curid2 - curid) >= 100) then continue; end if;

    -- calculate new sequence start value
    start := curid * 100 + 0;

    EXECUTE 'alter sequence opuscollege.' || sequence.sequence_name || ' increment by 100';
    EXECUTE $$select setval('opuscollege.$$ || sequence.sequence_name || $$', $$ || start || $$, false)$$;

    END LOOP;

  --  PERFORM cs_log('Done refreshing materialized views.');
    RETURN 1;
END;
$PROC$ LANGUAGE plpgsql;

select opuscollege.prepare_sequences_for_symmetricds();

-- drop helper function
DROP FUNCTION opuscollege.prepare_sequences_for_symmetricds();
