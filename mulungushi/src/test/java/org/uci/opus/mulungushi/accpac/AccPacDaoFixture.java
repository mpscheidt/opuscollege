package org.uci.opus.mulungushi.accpac;

public class AccPacDaoFixture {

    private static final String XML_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><StudentBalance><balance>%s</balance><canregister>%s</canregister><creditlimit>%s</creditlimit><name>%s</name></StudentBalance>";

    public static String xml(String balance, boolean canregister, String creditlimit, String name) {
        return String.format(XML_HEADER, balance, canregister ? "Yes" : "NO", creditlimit, name);
    }

}
