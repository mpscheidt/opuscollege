package org.uci.opus.util;

public abstract class CompareUtil {

    /**
     * Compare two Strings. Null parameters are treated as empty strings.
     * 
     * @param s1
     * @param s2
     * @return
     */
    public static int compare(String s1, String s2) {
        if (s1 == null) {
            s1 = "";
        }
        if (s2 == null) {
            s2 = "";
        }
        
        return s1.compareTo(s2);
    }

}
