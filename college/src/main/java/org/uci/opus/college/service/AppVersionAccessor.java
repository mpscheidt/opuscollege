package org.uci.opus.college.service;

import java.util.List;

import org.uci.opus.college.domain.AppVersion;

/**
 * Implement once per data source to abstract access to the app versions.
 * 
 * @author Markus Pscheidt
 *
 */
public interface AppVersionAccessor {

    /**
     * Find the current module versions.
     * 
     * @return AppVersion coreModule
     */
    List<AppVersion> getAppVersions();

    /**
     * Find the version information about a particular module.
     * 
     * @return AppVersion
     */
    AppVersion getAppVersion(String module);

    /**
     * if automatic writing of appversion is desired, this method shall be implemented. Otherwise implement empty.
     * 
     * @param appVersion
     */
    void add(AppVersion appVersion);

    /**
     * if automatic writing of appversion is desired, this method shall be implemented. Otherwise implement empty.
     * 
     * @param appVersion
     */
    void update(AppVersion appVersion);

}