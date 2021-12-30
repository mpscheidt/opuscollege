package org.uci.opus.college.fixture.lookup;

import org.uci.opus.college.domain.Lookup3;

public abstract class CountryFixture {

    public static final String DE = "de";
    public static final String EN = "en";

    public static final String AT = "AT";
    public static final String AT_DESCDRIPTION_DE = "Oesterreich";
    public static final String AT_DESCDRIPTION_EN = "Austria";
    public static final int AT_GEONAMEID = 2782113;

    public static final String MZ = "MZ";
    public static final String MZ_DESCDRIPTION_DE = "Mosambik";
    public static final String MZ_DESCDRIPTION_EN = "Mozambique";
    public static final int MZ_GEONAMEID = 1036973;

    public static final Lookup3 atDe() {
        return at(DE, AT_DESCDRIPTION_DE);
    }

    public static final Lookup3 atEn() {
        return at(EN, AT_DESCDRIPTION_EN);
    }
    
    public static final Lookup3 at(String lang, String description) {
        return new Lookup3(lang, AT, description, AT, AT_GEONAMEID);
    }

    public static final Lookup3 mzDe() {
        return mz(DE, MZ_DESCDRIPTION_DE);
    }

    public static final Lookup3 mzEn() {
        return mz(EN, MZ_DESCDRIPTION_EN);
    }
    
    public static final Lookup3 mz(String lang, String description) {
        return new Lookup3(lang, MZ, description, MZ, MZ_GEONAMEID);
    }

}
