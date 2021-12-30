package org.uci.opus.college.service.extpoint;

import java.util.List;

import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;

public interface DBUpgradeListener {

    void dbUpgradesExecuted(List<DbUpgradeCommandInterface> upgrades);
    
}
