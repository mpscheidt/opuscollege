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

-- Opus College (c) UCM - Stelio Alexandre September 2010
--
-- KERNEL opuscollege / MODULE college


DROP SEQUENCE IF EXISTS opuscollege.opusPrivilegeSeq CASCADE;
CREATE SEQUENCE opuscollege.opusPrivilegeSeq;
ALTER TABLE opuscollege.opusPrivilegeSeq OWNER TO postgres;

-------------------------------------------------------
-- lookup table opusPrivilege
-------------------------------------------------------
CREATE TABLE opuscollege.opusPrivilege (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.opusPrivilegeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id),
    UNIQUE(lang,code)
);
ALTER TABLE opuscollege.opusPrivilege OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.opusPrivilege TO postgres;


--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'en', 'Print result slip');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'en', 'Alter study plan');

--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'nl', 'Print result slip');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'nl', 'Alter study plan');

--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('1', 'pt', 'Imprimir pautas');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('2', 'pt', 'Editar plano de estudo');



DROP SEQUENCE IF EXISTS opuscollege.opusRole_privilegeSeq CASCADE;
CREATE SEQUENCE opuscollege.opusRole_privilegeSeq;
ALTER TABLE opuscollege.opusRole_privilegeSeq OWNER TO postgres;


-------------------------------------------------------
-- table opusRole_privilege
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.opusRole_privilegeSeq CASCADE;
CREATE SEQUENCE opuscollege.opusRole_privilegeSeq;
ALTER TABLE opuscollege.opusRole_privilegeSeq OWNER TO postgres;


CREATE TABLE opuscollege.opusRole_privilege (
   id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.opusRole_privilegeSeq'), 
   roleId INTEGER NOT NULL,
   privilegeCode VARCHAR NOT NULL,
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
   PRIMARY KEY(id),
   FOREIGN KEY (roleId) REFERENCES opuscollege.role(id),
   UNIQUE(roleId,privilegeCode)
);
ALTER TABLE opuscollege.opusRole_privilege OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.opusRole_privilege TO postgres;



---------------
--Moving preferred language from opususerrole to opususer
--
---------------

ALTER TABLE opuscollege.opususer ADD COLUMN lang CHARACTER(2) NOT NULL DEFAULT 'en';


-----
----Copy lang values from opususerrole.lang to opususer.lang
---

UPDATE opuscollege.opususer SET lang = (SELECT lang FROM opuscollege.opususerrole WHERE opususerrole.username = opususer.username);


---Drop opususerrole.lang column as it is no longer needed
ALTER TABLE opuscollege.opususerrole DROP COLUMN lang;


ALTER TABLE opuscollege.opususerrole ADD COLUMN validFrom DATE NOT NULL DEFAULT now();
ALTER TABLE opuscollege.opususerrole ADD COLUMN validThrough DATE;
ALTER TABLE opuscollege.opususerrole ADD COLUMN organizationalUnitId INT ;
ALTER TABLE opuscollege.opususerrole ADD COLUMN active CHARACTER(1) NOT NULL DEFAULT 'Y';

--a user may not have different roles for the same organizational unit
ALTER TABLE opuscollege.opususerrole ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalUnitId);

----
---Set the organizationalId role for staff users
UPDATE opuscollege.opususerrole SET organizationalUnitId = (SELECT primaryUnitOfAppointmentId FROM opuscollege.staffMember 
		INNER JOIN opuscollege.opususer ON opususer.personId = staffMember.personId
		WHERE opususerrole.username = opususer.username )

WHERE opususerrole.organizationalUnitId IS NULL ;


----
---Set the organizationalId role for student users
UPDATE opuscollege.opususerrole SET organizationalUnitId = (SELECT organizationalUnitId FROM opuscollege.study
		INNER JOIN opuscollege.student ON student.primaryStudyId = study.id
		INNER JOIN opuscollege.opususer ON opususer.personId = student.personId
WHERE opususerrole.username = opususer.username )

WHERE opususerrole.organizationalUnitId IS NULL ;


ALTER TABLE opuscollege.opususerrole ADD COLUMN institutionId INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.opususerrole ADD COLUMN branchId INTEGER NOT NULL DEFAULT 0;

ALTER TABLE opuscollege.opususerrole ALTER COLUMN organizationalUnitId SET DEFAULT 0 ;
UPDATE opuscollege.opususerrole SET organizationalUnitId=0 WHERE organizationalUnitId is null;
ALTER TABLE opuscollege.opususerrole ALTER COLUMN organizationalUnitId SET NOT NULL ;

ALTER TABLE opuscollege.opususerrole DROP CONSTRAINT user_organizationalunit_unique_constraint;
