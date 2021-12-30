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
-- FUNCTION crawl_tree(integer, integer)
-------------------------------------------------------

-- create helper function which installs plpgsql
CREATE OR REPLACE FUNCTION opuscollege.create_plpgsql_language ()        
	RETURNS TEXT  
	AS $$            
		CREATE LANGUAGE plpgsql;            
		SELECT 'language plpgsql created'::TEXT;        
	$$
LANGUAGE 'sql';

-- check if plpgsql already exists
SELECT CASE WHEN              
	(SELECT true::BOOLEAN                 
	 FROM pg_language                
     WHERE lanname='plpgsql')  
-- if it does, do nothing
THEN              
	null  
-- if it doesn't, install
ELSE              
	(SELECT opuscollege.create_plpgsql_language())            
END;
-- drop helper function
DROP FUNCTION opuscollege.create_plpgsql_language ();

CREATE OR REPLACE FUNCTION opuscollege.crawl_tree(integer, integer)
  RETURNS SETOF opuscollege.node_relationships_n_level AS
$BODY$DECLARE
temp RECORD;
child RECORD;
BEGIN
  SELECT INTO temp *, $2 AS level FROM opuscollege.organizationalunit WHERE
id = $1;

  IF FOUND THEN
    RETURN NEXT temp;
      FOR child IN SELECT id FROM opuscollege.organizationalunit WHERE
parentorganizationalunitid = $1 ORDER BY unitlevel LOOP
        FOR temp IN SELECT * FROM opuscollege.crawl_tree(child.id, $2 +
1) LOOP
            RETURN NEXT temp;
        END LOOP;
      END LOOP;
   END IF;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION opuscollege.crawl_tree(integer, integer) OWNER TO postgres;
