package org.uci.opus.college.fixture.lookup;

import org.uci.opus.college.domain.Lookup5;

public abstract class ProvinceFixture {

    public static final String DE = "de";
    public static final String EN = "en";

    public static final String AT = "AT";
    public static final int AT_GEONAMEID = 2782113;

    public static final String STYRIA_CODE = "st";
    public static final String STYRIA_DESCDRIPTION_DE = "Steiermark";
    public static final String STYRIA_DESCDRIPTION_EN = "Styria";
    public static final int STYRIA_GEONAMEID = 2764581;

    public static final String TYROL_CODE = "ty";
    public static final String TYROL_DESCDRIPTION_DE = "Tirol";
    public static final String TYROL_DESCDRIPTION_EN = "Tyrol";
    public static final int TYROL_GEONAMEID = 2763586;

    public static Lookup5 styriaDe() {
        return styria(DE, STYRIA_DESCDRIPTION_DE);
    }

    public static Lookup5 styriaEn() {
        return styria(EN, STYRIA_DESCDRIPTION_EN);
    }

    public static Lookup5 styria(String lang, String description) {
        return new Lookup5(lang, STYRIA_CODE, description, AT, STYRIA_GEONAMEID);
    }

    public static Lookup5 tyrolDe() {
        return tyrol(DE, TYROL_DESCDRIPTION_DE);
    }

    public static Lookup5 tyrolEn() {
        return tyrol(EN, TYROL_DESCDRIPTION_EN);
    }

    public static Lookup5 tyrol(String lang, String description) {
        return new Lookup5(lang, TYROL_CODE, description, AT, TYROL_GEONAMEID);
    }

}
