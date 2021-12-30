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

------------------------------------------------------------
-- Function: opuscollege.remove_diacritics(p_string varchar)
------------------------------------------------------------

-- DROP FUNCTION opuscollege.remove_diacritics(p_string varchar);

CREATE OR REPLACE FUNCTION opuscollege.remove_diacritics(p_string varchar)
  RETURNS "varchar" AS
$BODY$
DECLARE
  v_string varchar(1000);

BEGIN
  v_string := lower( p_string );

  v_string := replace( v_string, 'à', 'a');
  v_string := replace( v_string, 'á', 'a');
  v_string := replace( v_string, 'â', 'a');
  v_string := replace( v_string, 'ã', 'a');
  v_string := replace( v_string, 'ä', 'a');
  v_string := replace( v_string, 'å', 'a');
  v_string := replace( v_string, 'æ', 'a');

  v_string := replace( v_string, 'ç', 'c');

  v_string := replace( v_string, 'è', 'e');
  v_string := replace( v_string, 'é', 'e');
  v_string := replace( v_string, 'ê', 'e');
  v_string := replace( v_string, 'ë', 'e');

  v_string := replace( v_string, 'ì', 'i');
  v_string := replace( v_string, 'í', 'i');
  v_string := replace( v_string, 'î', 'i');
  v_string := replace( v_string, 'ï', 'i');

  v_string := replace( v_string, 'ñ', 'n');

  v_string := replace( v_string, 'ò', 'o');
  v_string := replace( v_string, 'ó', 'o');
  v_string := replace( v_string, 'ô', 'o');
  v_string := replace( v_string, 'õ', 'o');
  v_string := replace( v_string, 'ö', 'o');
  v_string := replace( v_string, 'ø', 'o');

  v_string := replace( v_string, 'ù', 'u');
  v_string := replace( v_string, 'ú', 'u');
  v_string := replace( v_string, 'û', 'u');
  v_string := replace( v_string, 'ü', 'u');

  v_string := replace( v_string, 'ý', 'y');
  v_string := replace( v_string, 'ÿ', 'y');

  return v_string;

EXCEPTION
  when others then
     return p_string;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION opuscollege.remove_diacritics(varchar) OWNER TO postgres;
