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

CREATE TABLE opuscollege.subjectresultcomment
(
  id serial NOT NULL,
  sort integer NOT NULL DEFAULT 0,
  commentkey character varying,
  active boolean NOT NULL DEFAULT true,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT subjectresultcomment_pkey PRIMARY KEY (id)
);

-- passSubjectThreshold: examination result threshold below which the subject fails
--     This is to avoid high combined tests result (e.g. 20) with low final exam result (5),
--     which still would generate a subject result higher than 10. 
--     But final exam lower than 8 is not allowed to pass subject.
-- failSubjectResultCommentId: If set and examination fails, upon subject result creation
--     create a negative subject result with the subject result comment set to this value
ALTER TABLE opuscollege.examinationtype ADD COLUMN passSubjectThreshold character varying;
ALTER TABLE opuscollege.examinationtype ADD COLUMN failSubjectResultCommentId integer references opuscollege.subjectresultcomment;
ALTER TABLE opuscollege.examinationtype ADD COLUMN dependsOnPassedExaminationTypeCode character varying;
ALTER TABLE opuscollege.examinationresultcomment ADD COLUMN failsubjectblock boolean NOT NULL DEFAULT false;
ALTER TABLE opuscollege.testresultcomment ADD COLUMN failsubjectblock boolean NOT NULL DEFAULT false;

--DROP TABLE IF EXISTS opuscollege.examinationattempttype;
CREATE TABLE opuscollege.examinationattempttype
(
  id serial NOT NULL,
  sort integer NOT NULL DEFAULT 0,
  examinationtypecode character varying,
  commentkey character varying,
  defaultattemptnumber integer,
  active boolean NOT NULL DEFAULT true,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT examinationattempttype_pkey PRIMARY KEY (id)
);
--ALTER TABLE opuscollege.examinationresultcomment OWNER TO postgres;
--GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examinationresultcomment TO postgres;

