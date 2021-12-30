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

-- Opus College (c) UCI - Janneke Nooitgedagt
--
-- KERNEL opuscollege / MODULE -
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.27);

-------------------------------------------------------
-- table academicYear
-------------------------------------------------------
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2005') WHERE description = '2004';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2006') WHERE description = '2005';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2007') WHERE description = '2006';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2008') WHERE description = '2007';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2009') WHERE description = '2008';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2010') WHERE description = '2009';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2011') WHERE description = '2010';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2012') WHERE description = '2011';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2013') WHERE description = '2012';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2014') WHERE description = '2013';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2015') WHERE description = '2014';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2016') WHERE description = '2015';
