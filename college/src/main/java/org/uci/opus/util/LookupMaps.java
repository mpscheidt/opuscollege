package org.uci.opus.util;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class LookupMaps extends HashMap<String, CodeToLookupMap> {

    private static final long serialVersionUID = 1L;
    private static Logger log = LoggerFactory.getLogger(LookupLists.class);

    private LookupLists lookupLists;

    public LookupMaps(LookupLists lookupLists) {
        this.lookupLists = lookupLists;
    }

    @Override
    public CodeToLookupMap get(Object key) {
        String tablename = (String) key;

        CodeToLookupMap codeToLookupMap = super.get(tablename);
        if (codeToLookupMap == null) {
            log.info("Creating CodeToLookup map for: " + tablename);
            codeToLookupMap = new CodeToLookupMap(lookupLists.get(tablename));
            put(tablename, codeToLookupMap);
        }
        return codeToLookupMap;
    }
    
}
