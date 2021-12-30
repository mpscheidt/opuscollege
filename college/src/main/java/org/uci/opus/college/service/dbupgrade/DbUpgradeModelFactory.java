package org.uci.opus.college.service.dbupgrade;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.service.AppVersionAccessor;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.util.OrderByStringComparator;
import org.uci.opus.util.dbupgrade.DbUpgradeAdviser;
import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;
import org.uci.opus.util.dbupgrade.DbUpgradeModel;

/**
 * Factory that creates a {@link DbUpgradeModel} that provides information about the available database upgrades not yet executed on the
 * current database.
 * 
 * @author Markus Pscheidt
 *
 */
@Service
public class DbUpgradeModelFactory {

    private static final Logger log = LoggerFactory.getLogger(DbUpgradeModelFactory.class);

    private List<DbUpgradeCommandInterface> dbUpgradeCommands;

    private LookupManagerInterface lookupManager;

    @Autowired
    public DbUpgradeModelFactory(List<DbUpgradeCommandInterface> dbUpgradeCommands, LookupManagerInterface lookupManager) {
        this.dbUpgradeCommands = dbUpgradeCommands;
        this.lookupManager = lookupManager;
    }

    /**
     * Create a mew {@link DbUpgradeModel}.
     * 
     * @return
     */
    public DbUpgradeModel newDbUpgradeModel() {

        Map<String, AppVersion> moduleToAppVersionMap = moduleToAppVersionMap();
        return new DbUpgradeModel(moduleToAppVersionMap, eligibleUpgrades(moduleToAppVersionMap));
    }

    /**
     * @return module name to AppVersion object
     */
    private Map<String, AppVersion> moduleToAppVersionMap() {

        Map<String, AppVersion> moduleToAppVersionMap = new HashMap<>();

        for (DbUpgradeCommandInterface upgrade : dbUpgradeCommands) {
            Module module = upgrade.getModule();
            AppVersionAccessor appVersionAccessor = module.getAppVersionAccessor();
            if (appVersionAccessor == null) {
                // default is lookupManager
                appVersionAccessor = lookupManager;
                module.setAppVersionAccessor(appVersionAccessor);
            }

            String moduleName = module.getModule();
            AppVersion appVersion = null;
            try {
                appVersion = appVersionAccessor.getAppVersion(moduleName);
            } catch (Exception e) {
                log.info("database does not exist for module: '" + moduleName + "' and will be created", e.getMessage());
            }
            moduleToAppVersionMap.put(moduleName, appVersion);
        }

        return moduleToAppVersionMap;
    }

    private List<DbUpgradeCommandInterface> eligibleUpgrades(Map<String, AppVersion> moduleToAppVersionMap) {

        List<DbUpgradeCommandInterface> allEligibleUpgrades = new ArrayList<>();

        DbUpgradeAdviser dbUpgradeAdviser = new DbUpgradeAdviser();
        for (DbUpgradeCommandInterface dbUpgradeCommand : dbUpgradeCommands) {
            Module module = dbUpgradeCommand.getModule();
            AppVersion appVersion = moduleToAppVersionMap.get(module.getModule());
            if (dbUpgradeAdviser.isEligible(dbUpgradeCommand, appVersion)) {
                allEligibleUpgrades.add(dbUpgradeCommand);
            }
        }

        // upgrades are OrderedByString. Let's sort them
        Collections.sort(allEligibleUpgrades, new OrderByStringComparator());

        return allEligibleUpgrades;
    }
}
