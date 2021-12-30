package org.uci.opus.mulungushi.dbconversion;

public class DbConvUtil {

	/**
	 * If the given string s has any 0 characters,
	 *   i.e.:  "\u0000"
	 *   or another way to express:  Character.toString(0)
	 *   or another way to express:  "" + (char) 0
	 * then replace such occurrences with the given replacement string.
	 * 
	 * The 0 characters make problems when writing into the Postgres database.
	 * 
	 * @param s
	 * @param replacement for example "" or " "
	 * @return
	 */
	public static String replaceUnicode0(String s, String replacement) {
		return s == null ? null : s.replaceAll("\u0000", replacement);
	}
	
	/**
	 * Calls {@link #replaceUnicode0(String, String)} with a default replacement of space.
	 * @param s
	 * @return
	 */
	public static String replaceUnicode0(String s) {
		return replaceUnicode0(s, " ");
	}

}
