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

-- 
-- Author: Markus Pscheidt
-- Date:   2017-05-03
-- 

-- insert values for final exam (examinationtype.code = 101)
-- special case is the "improvement of an (already positive) result"
delete from opuscollege.examinationattempttype;
insert into opuscollege.examinationattempttype
	(sort, examinationtypecode, commentkey, defaultattemptnumber) values
	(10, '101', 'general.attemptnr.1', 1),
	(20, '101', 'general.attemptnr.2', 2),
	(30, '101', 'general.attemptnr.3', 3),
	(40, '101', 'general.attemptnr.4', 4),
	(90, '101', 'general.attemptnr.improveresult', null);

update opuscollege.examinationtype
set passSubjectThreshold = '8'
,	thresholdSubjectResultCommentId = (
	select id from opuscollege.subjectResultComment where commentKey = 'subjectResultComment.below.threshold'
)
where code = '101';

update opuscollege.examinationtype
set failSubject = true
,	failSubjectResultCommentId = (
	select id from opuscollege.subjectResultComment where commentKey = 'subjectResultComment.excluded'
)
where code = '100';

-- CED: does not have the rules to fail a subject when NF result is low or final exam result is low
-- therefore, for CED create dedicated examinationtypes for NF and final exam with codes 200 and 201 (instead of 100 and 101) 
insert into opuscollege.examinationtype (code, lang, description) values
  ('200', 'en', 'Combined tests (CED)'),
  ('200', 'pt', 'Nota de frequentia (CED)'),
  ('201', 'en', 'Final examination (CED)'),
  ('201', 'pt', 'Exame final (CED)');

-- at CED assign these examination types
update opuscollege.examination set examinationtypecode = '200'
where examinationtypecode = '100'
and exists (
  select 1 from opuscollege.branch
  inner join opuscollege.organizationalunit on organizationalunit.branchId = branch.id
  inner join opuscollege.study on study.organizationalunitid = organizationalunit.id
  inner join opuscollege.subject on subject.primarystudyid = study.id and examination.subjectId = subject.id
  where branch.branchdescription like 'CED%'
);

update opuscollege.examination set examinationtypecode = '201'
where examinationtypecode = '101'
and exists (
  select 1 from opuscollege.branch
  inner join opuscollege.organizationalunit on organizationalunit.branchId = branch.id
  inner join opuscollege.study on study.organizationalunitid = organizationalunit.id
  inner join opuscollege.subject on subject.primarystudyid = study.id and examination.subjectId = subject.id
  where branch.branchdescription like 'CED%'
);
