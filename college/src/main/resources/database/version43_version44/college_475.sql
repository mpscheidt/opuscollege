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

-- 
-- Author: Helder Jossias
-- Date: 2017-04-19

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.75, writeWhen = now() WHERE lower(module) = 'college';

-------------------------------------------------------
-- tabledependency
-------------------------------------------------------

UPDATE opuscollege.role SET roledescription = 'Organization Unit' WHERE role = 'admin-D' AND lang = 'en';
UPDATE opuscollege.role SET roledescription = 'Unidade Orgânica' WHERE role = 'admin-D' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Organization Unit 2nd level' WHERE role = 'admin-E' AND lang = 'en';
UPDATE opuscollege.role SET roledescription = 'Unidade Orgânica do 2º Nível' WHERE role = 'admin-E' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Delegação' WHERE role = 'admin-B' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Registo Acadêmico' WHERE role = 'admin-C' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'System Administrator' WHERE role = 'admin' AND lang = 'en';
UPDATE opuscollege.role SET roledescription = 'Administrador do Sistema' WHERE role = 'admin' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Docente' WHERE role = 'teacher' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Estudante' WHERE role = 'student' AND lang = 'pt';
UPDATE opuscollege.role SET roledescription = 'Visitante' WHERE role = 'guest' AND lang = 'pt';

