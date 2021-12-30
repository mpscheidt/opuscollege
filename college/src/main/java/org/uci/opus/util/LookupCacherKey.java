package org.uci.opus.util;

import java.io.Serializable;

public class LookupCacherKey implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String CAPITALIZE = "C";
    public static final String UNCAPITALIZE = "U";

    private String lang;
    private String capitalization;

    public LookupCacherKey(String lang) {
        this.lang = lang;
    }

    public LookupCacherKey(String lang, String capitalization) {
        this.lang = lang;
        this.capitalization = capitalization;
    }
    
    // auto-generated
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((capitalization == null) ? 0 : capitalization.hashCode());
        result = prime * result + ((lang == null) ? 0 : lang.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {

        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;

        LookupCacherKey other = (LookupCacherKey) obj;

        // pattern for comparison:   ((a == b) || ((a != null) && a.equals(b)))
        boolean b = (capitalization == other.capitalization) || (capitalization != null && capitalization.equals(other.capitalization));
        b = b && ((lang == other.lang) || (lang != null && lang.equals(other.lang)));

        return b;
    }



    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getCapitalization() {
        return capitalization;
    }

    public void setCapitalization(String capitalization) {
        this.capitalization = capitalization;
    }

}
