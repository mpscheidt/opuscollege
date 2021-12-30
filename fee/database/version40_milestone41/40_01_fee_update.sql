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
-- Date:   2012-10-08
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',4.01);

-------------------------------------------------------
-- table OpusPrivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEE_PAYMENTS','en','Y','Allow the execution of payments payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEE_PAYMENTS','en','Y','Allow edition of payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEE_PAYMENTS','en','Y','Allow removal of payments');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEE_PAYMENTS','en','Y','Read fee payments');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEE_PAYMENTS','pt','Y','Permite pagar propinas');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEE_PAYMENTS','pt','Y','Permite actualizar o pagamento de propinas');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEE_PAYMENTS','pt','Y','Permite remover pagamento de propinas');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEE_PAYMENTS','pt','Y','Permite visualizar o pagamento de propinas');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------

--Remove duplicated entries
DELETE FROM "opuscollege".OpusRole_Privilege
	    WHERE id NOT IN(
        	SELECT MAX(dup.id) FROM opuscollege.OpusRole_Privilege AS dup
			GROUP BY dup.role, dup.privilegeCode
		);

--ensure there will be no more duplicated entries		
CREATE UNIQUE INDEX uq_opusroleprivilege_roleprivilegecode ON "opuscollege".OpusRole_Privilege (lower(role), lower(privilegeCode));

--admin has (virtually) every privilege
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_FEE_PAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_FEE_PAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_FEE_PAYMENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_FEE_PAYMENTS');
