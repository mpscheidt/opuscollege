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
 * The Original Code is Opus-College mozambique module code.
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

-- Introduce a "MZ-" prefix to all province, district and
-- administrative post lookups and the corresponding
-- references in other tables (person, address, etc.)
--
-- This script can be run more than once without wreaking havoc.
-- This script can be run at any time - no dependencies on other scripts.
--

-- 1. Update provinces

-- update person.provinceofbirthcode
update opuscollege.person
set provinceofbirthcode='MZ-' || provinceofbirthcode
from opuscollege.province
where provinceofbirthcode = province.code
and SUBSTR (provinceofbirthcode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update person.provinceoforigincode
update opuscollege.person
set provinceoforigincode='MZ-' || provinceoforigincode
from opuscollege.province
where provinceoforigincode = province.code
and SUBSTR (provinceoforigincode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update address.provincecode
update opuscollege.address
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update district.provincecode
update opuscollege.district
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update institution.provincecode
update opuscollege.institution
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update the province.code
update opuscollege.province
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and province.countrycode = '508';


-- 2. Update districts

-- update person.districtofbirthcode
update opuscollege.person
set districtofbirthcode='MZ-' || districtofbirthcode
from opuscollege.district,
opuscollege.province
where districtofbirthcode = district.code
and SUBSTR (districtofbirthcode, 1, 3) <> 'MZ-'
and district.provincecode = province.code and province.lang = 'pt'
and province.countrycode = '508';

-- update person.districtoforigincode
update opuscollege.person
set districtoforigincode='MZ-' || districtoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtoforigincode = district.code
)
and SUBSTR (districtoforigincode, 1, 3) <> 'MZ-';

-- update address.districtcode
update opuscollege.address
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update administrativepost.districtcode
update opuscollege.administrativepost
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update district.code
update opuscollege.district
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
where district.provincecode = province.code and province.countrycode = '508'
);

-- 3. Update administrative posts

-- update address.administrativepostcode
update opuscollege.address
set administrativepostcode='MZ-' || administrativepostcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostcode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostcode, 1, 3) <> 'MZ-';

-- update person.administrativepostoforigincode
update opuscollege.person
set administrativepostoforigincode='MZ-' || administrativepostoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostoforigincode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostoforigincode, 1, 3) <> 'MZ-';

-- update administrativepost.code
update opuscollege.administrativepost
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
where district.provincecode = province.code and province.countrycode = '508'
);
