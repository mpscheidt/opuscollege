package org.uci.opus.college.domain;

import org.uci.opus.admin.domain.LookupTable;

public class LookupFactory {
    
    /**
     * Create a GeonameLookup instance that has a parent, that is, any GeonameLookup except a country.
     */
    public static GeonameLookup newGeonameInstance(String tablename, String language, String code, String description, String parentCode, int geonameId) {

        switch (tablename) {
        case LookupTable.PROVINCE:
            return new Lookup5(language, code, description, parentCode, geonameId);
        case LookupTable.DISTRICT:
            return new Lookup2(language, code, description, parentCode, geonameId);
        case LookupTable.ADMINISTRATIVEPOST:
            return new Lookup4(language, code, description, parentCode, geonameId);
        }

        return null;
    }

}
