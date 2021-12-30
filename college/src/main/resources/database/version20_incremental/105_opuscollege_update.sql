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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.05);

-------------------------------------------------------
-- rename all obsolete columns to active
-------------------------------------------------------

-- drop function opuscollege.rename_col_obsolete_to_active();

CREATE FUNCTION opuscollege.rename_col_obsolete_to_active() RETURNS integer AS $$
DECLARE
    mviews RECORD;
BEGIN
    --PERFORM cs_log('Refreshing materialized views...');

    FOR mviews IN select table_name from information_schema.columns where table_schema = 'opuscollege' and column_name = 'obsolete' and table_name != 'node_relationships_n_level' LOOP

        -- Now "mviews" has one record from cs_materialized_views

       -- PERFORM cs_log('Refreshing materialized view ' || quote_ident(mviews.table_name) || ' ...');
        EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' RENAME COLUMN obsolete TO active';
	EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' ALTER COLUMN active SET DEFAULT ''Y''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''J'' where active = ''N''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''N'' where active = ''Y''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''Y'' where active = ''J''';

    END LOOP;

  --  PERFORM cs_log('Done refreshing materialized views.');
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

select opuscollege.rename_col_obsolete_to_active()