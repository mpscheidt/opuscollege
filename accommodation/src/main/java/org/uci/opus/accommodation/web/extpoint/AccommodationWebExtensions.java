package org.uci.opus.accommodation.web.extpoint;

import java.lang.reflect.Field;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;

public class AccommodationWebExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(AccommodationWebExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private Collection<AccommodationSubMenu> accommodationSubMenus;


    public Collection<AccommodationSubMenu> getAccommodationSubMenus() {
        return accommodationSubMenus;
    }

    @Autowired(required=false)
    public void setAccommodationSubMenus(Collection<AccommodationSubMenu> accommodationSubMenus) {
        this.accommodationSubMenus = accommodationSubMenus;
        extensionPointUtil.logExtensions(log, AccommodationSubMenu.class, accommodationSubMenus);
    }

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }
    
}
