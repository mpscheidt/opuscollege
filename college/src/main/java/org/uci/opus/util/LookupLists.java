package org.uci.opus.util;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.LookupManagerInterface;

@Component
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class LookupLists extends HashMap<String, List<? extends Lookup>> {

    private static final long serialVersionUID = 1L;
    private static Logger log = LoggerFactory.getLogger(LookupLists.class);

    private String lang;

    @Autowired
    private LookupManagerInterface lookupManager;

    public LookupLists(String lang) {
        this.lang = lang;
    }

    @Override
    public List<? extends Lookup> get(Object key) {
        String tablename = (String) key;

        List<? extends Lookup> lookups = super.get(tablename);
        if (lookups == null) {
            lookups = getAll(tablename, this.lang);
            put(tablename, lookups);
        }
        return lookups;
    }

    private <T extends Lookup> List<T> getAll(String tablename, String language) {
        log.info("Fetching lookups from database: " + tablename);
        List<T> list = lookupManager.findAllRows(language, tablename);
        return Collections.unmodifiableList(list);
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

}
