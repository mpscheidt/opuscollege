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
-- Author: Markus Pscheidt
-- Date:   2015-06-01
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.44, writeWhen = now() WHERE lower(module) = 'college';

-- Field 'markDecimal' in addition to the (rounded) mark value.
-- The markDecimal allows for example to find the best three students in a program/year
ALTER TABLE opuscollege.studyPlanResult ADD COLUMN markDecimal numeric(5,2);

ALTER TABLE audit.studyPlanResult_hist ADD COLUMN markDecimal numeric(5,2);

-------------------------------------------------------

CREATE TABLE opuscollege.testResultComment
(
  id serial PRIMARY KEY,
  sort integer NOT NULL DEFAULT 0,
  commentkey character varying,
  failSubject boolean NOT NULL DEFAULT false,
  failTimeUnit boolean NOT NULL DEFAULT false,
  active boolean NOT NULL DEFAULT true,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now()
);

CREATE TABLE opuscollege.examinationResultComment
(
  id serial PRIMARY KEY,
  sort integer NOT NULL DEFAULT 0,
  commentkey character varying,
  failSubject boolean NOT NULL DEFAULT false,
  failTimeUnit boolean NOT NULL DEFAULT false,
  active boolean NOT NULL DEFAULT true,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE opuscollege.testResult ADD COLUMN testResultCommentId integer REFERENCES opuscollege.testResultComment (id);
ALTER TABLE opuscollege.examinationResult ADD COLUMN examinationResultCommentId integer REFERENCES opuscollege.examinationResultComment (id);

ALTER TABLE audit.testResult_hist ADD COLUMN testResultCommentId integer;
ALTER TABLE audit.examinationResult_hist ADD COLUMN examinationResultCommentId integer;

-- table and columns called gradecomment were created at UCM, but not written any data to the columns yet
-- these columns gradecomment are replaced by the nonExisting... tables and references
ALTER TABLE opuscollege.testResult DROP COLUMN IF EXISTS gradecomment; 
ALTER TABLE opuscollege.examinationResult DROP COLUMN IF EXISTS gradecomment;
ALTER TABLE opuscollege.subjectResult DROP COLUMN IF EXISTS gradecomment;
DROP TABLE IF EXISTS opuscollege.gradecomment;

-- Difference between fraud on test level and examination level in failing time unit or not
insert into opuscollege.testResultComment (sort, commentkey, failSubject, failTimeUnit) values (40, 'testResultComment.fraud', true, false);
insert into opuscollege.testResultComment (sort, commentkey, failSubject, failTimeUnit) values (30, 'testResultComment.absentNoPermission', false, false);
insert into opuscollege.testResultComment (sort, commentkey, failSubject, failTimeUnit) values (20, 'testResultComment.absentWithIllness', false, false);
insert into opuscollege.testResultComment (sort, commentkey, failSubject, failTimeUnit) values (10, 'testResultComment.deferred', false, false);

insert into opuscollege.examinationResultComment (sort, commentkey, failSubject, failTimeUnit) values (40, 'examinationResultComment.fraud', true, true);
insert into opuscollege.examinationResultComment (sort, commentkey, failSubject, failTimeUnit) values (30, 'examinationResultComment.absentNoPermission', true, false);
insert into opuscollege.examinationResultComment (sort, commentkey, failSubject, failTimeUnit) values (20, 'examinationResultComment.absentWithIllness', false, false);
insert into opuscollege.examinationResultComment (sort, commentkey, failSubject, failTimeUnit) values (10, 'examinationResultComment.deferred', false, false);

