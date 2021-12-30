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
-- Date: 2017-05-02
--

ALTER TABLE opuscollege.subjectresult ADD COLUMN subjectResultCommentId integer REFERENCES opuscollege.subjectresultcomment;
ALTER TABLE audit.subjectresult_hist ADD COLUMN subjectResultCommentId integer;

-- failSubject: If set and examination fails, upon subject result creation
--     create a negative subject result.
--     NB: failSubject is evalated only if passSubjectThreshold does not apply.
-- failSubjectResultCommentId: Only applies when failSubject is true.
--     In this case, set the subjectResultCommentId of the generated subject result to this value.
-- passSubjectThreshold: examination result threshold below which the subject fails
--     This is to avoid high "combined tests" result (e.g. 20) with low final exam result (5),
--     which still would generate a subject result higher than 10. 
--     But final exam lower than 8 is not allowed to pass subject.
-- thresholdSubjectResultCommentId: This only applies if passSubjectThreshold is defined and applies.
--     In this case, set the subjectResultCommentId of the generated subject result to this value.
--
-- recreate passSubjectThreshold because it was originally created not null and default false;
ALTER TABLE opuscollege.examinationtype DROP COLUMN IF EXISTS passSubjectThreshold;
ALTER TABLE opuscollege.examinationtype DROP COLUMN IF EXISTS failSubject;
ALTER TABLE opuscollege.examinationtype ADD COLUMN passSubjectThreshold character varying;
ALTER TABLE opuscollege.examinationtype ADD COLUMN failSubject boolean default false;
ALTER TABLE opuscollege.examinationtype ADD COLUMN thresholdSubjectResultCommentId integer references opuscollege.subjectresultcomment;

UPDATE opuscollege.lookuptable set lookuptype = 'Lookup10' where tablename = 'examinationtype';

-- examinationFailCascade mechanism is replaced by the more powerful examinationType parameters
DELETE FROM opuscollege.appConfig WHERE appConfigAttributeName = 'examinationFailCascade';

insert into opuscollege.subjectresultcomment (sort, commentkey) values 
	('10', 'subjectResultComment.excluded'),
	('20', 'subjectResultComment.below.threshold');

