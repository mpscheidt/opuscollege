/*
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
 */

package org.uci.opus.util.dbupgrade;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.service.AppVersionAccessor;
import org.uci.opus.util.OrderByStringComparator;

/**
 * This class stores a set of database upgrades for each module.
 * 
 * @author markus
 *
 */
public class DbUpgradeModel {

    private static Logger log = LoggerFactory.getLogger(DbUpgradeModel.class);

    private int[] selected;
    private List<DbUpgradeCommandInterface> allEligibleUpgrades;
    private Map<String, AppVersion> moduleToAppVersionMap;

    public DbUpgradeModel(Map<String, AppVersion> moduleToAppVersionMap, List<DbUpgradeCommandInterface> allEligibleUpgrades) {
        this.moduleToAppVersionMap = moduleToAppVersionMap;
        this.allEligibleUpgrades = allEligibleUpgrades;
    }

    public int[] getSelected() {
        return selected;
    }

    public void setSelected(int[] selected) {
        this.selected = selected;
    }

    // public List<DbUpgradeCommandInterface> extractSelectedUpgrades() {
    // List<DbUpgradeCommandInterface> selUpgrades = new ArrayList<>();
    //
    // if (selected != null) {
    // Arrays.sort(selected); // make sure that the indexes are sorted
    // for (int index : selected) {
    // DbUpgradeCommandInterface dbUpgradeCommand = allEligibleUpgrades.get(index);
    // selUpgrades.add(dbUpgradeCommand);
    // }
    // }
    //
    // return selUpgrades;
    // }

    public List<DbUpgradeCommandInterface> getAllEligibleUpgrades() {
        return allEligibleUpgrades;
    }

    /**
     * Find the eligible upgrade with the highest version number for the given module.
     * 
     * @param module
     * @return
     */
    private DbUpgradeCommandInterface findLatestUpgrade(String module) {
        DbUpgradeCommandInterface latestUpgrade = null;

        Optional<DbUpgradeCommandInterface> optional = allEligibleUpgrades.stream().filter(upgrade -> upgrade.getModule().getModule().equals(module))
                .max(new OrderByStringComparator());

        latestUpgrade = optional.isPresent() ? optional.get() : null;

        return latestUpgrade;
    }

    public void writeAppVersions() {

        for (String module : moduleToAppVersionMap.keySet()) {
            AppVersion appVersion = moduleToAppVersionMap.get(module);
            if (appVersion == null) {
                appVersion = new AppVersion(module);
            }
            DbUpgradeCommandInterface upgrade = findLatestUpgrade(appVersion.getModule());
            if (upgrade != null) {
                appVersion.setDbVersion(upgrade.getVersion());

                AppVersionAccessor appVersionAccessor = upgrade.getModule().getAppVersionAccessor();
                if (appVersion.getId() == 0) {
                    appVersionAccessor.add(appVersion);
                } else {
                    appVersionAccessor.update(appVersion);
                }
            }

        }
    }

    // /**
    // * The worker method that performs the upgrade of the dbVersion field.
    // * @return the list of {@link AppVersion} with a modified dbVersion field.
    // */
    // public List<AppVersion> upgradeAppVersions(Iterable<AppVersion> appVersions) {
    // List<AppVersion> upgradedAppVersions = new ArrayList<>();
    // for (AppVersion appVersion : appVersions) {
    // DbUpgradeCommandInterface upgrade = findLatestUpgrade(appVersion.getModule());
    // if (upgrade != null) {
    // appVersion.setDbVersion(upgrade.getVersion());
    // upgradedAppVersions.add(appVersion);
    // }
    // }
    // return upgradedAppVersions;
    // }

    // /**
    // * Creates new {@link AppVersion} objects if none exists yet for any module in
    // * the <code>modules</code> list and adds them to the <code>appVersions</code> list.
    // */
    // public void addMissingAppVersions() {
    //
    // for (Module module : modules) {
    // if (!CollectionUtils.exists(appVersions, new BeanPropertyValueEqualsPredicate("module", module.getModule()))) {
    // AppVersion appVersion = new AppVersion(module.getModule());
    // appVersions.add(appVersion);
    // log.info("Adding appversion to database: " + appVersion);
    // }
    // }
    // }

}
