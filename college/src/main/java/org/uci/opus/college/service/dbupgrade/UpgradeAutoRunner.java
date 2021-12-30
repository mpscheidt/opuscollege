package org.uci.opus.college.service.dbupgrade;

import java.util.List;

import javax.servlet.ServletContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.stereotype.Service;
import org.uci.opus.util.dbupgrade.DbUpgradeModel;

/**
 * This is a "service" bean, which at application context startup determines the DB upgrades that shall be run and executes them in a single
 * transaction by calling {@link DbUpgradeManager#runDbUpgrades(List)}.
 * 
 * @author Markus Pscheidt
 */
@Service
public class UpgradeAutoRunner implements ApplicationListener<ApplicationEvent> {

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Autowired
    private DbUpgradeManagerInterface dbUpgradeManager;

    @Autowired
    private DbUpgradeModelFactory dbUpgradeModelFactory;

    @Autowired
    ServletContext servletContext;

    private DbUpgradeException upgradeException;

    private DbUpgradeModel dbUpgradeModel;

    @Override
    public void onApplicationEvent(ApplicationEvent event) {

        // only upgrade database once after root application context has been refreshed
        if (isStartupOfRootApplicationContext(event)) {
            upgradeDatabase();
        }
    }

    /**
     * Check if the root application context has been refreshed. We are not interested in the web application context (whose parent is the
     * root application context).
     */
    private boolean isStartupOfRootApplicationContext(ApplicationEvent event) {
        return event instanceof ContextRefreshedEvent && ((AbstractApplicationContext) event.getSource()).getParent() == null;
    }

    private void upgradeDatabase() {
        logger.info("Looking for available database upgrades");

        dbUpgradeModel = dbUpgradeModelFactory.newDbUpgradeModel();

        try {
            dbUpgradeManager.runDbUpgrades(dbUpgradeModel);
        } catch (DbUpgradeException e) {
            upgradeException = e;
            servletContext.setAttribute("upgradeException", e);
            logger.error("Database upgrades could not be executed", e);
        }
    }

    public Exception getUpgradeException() {
        return upgradeException;
    }

}
