/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.util;

import java.util.Comparator;
import java.util.Locale;

import org.springframework.context.MessageSource;
import org.uci.opus.admin.domain.LookupTable;

public class LookupTableAlphabeticComparator 
		implements Comparator<LookupTable> {

	private MessageSource messageSource;
	private Locale locale;
	public LookupTableAlphabeticComparator(MessageSource messageSource,
			Locale locale) {
		this.messageSource = messageSource;
		this.locale = locale;
	}
    public int compare(LookupTable lt1, LookupTable lt2) {

        // Avoid exception when message cannot be translated: return the key if no translation available
        String key1 = "jsp.lookuptable." + lt1.getTableName() + ".label2";
        String s1 = messageSource.getMessage(key1, null, key1, locale);
        
        String key2 = "jsp.lookuptable." + lt2.getTableName() + ".label2";
        String s2 = messageSource.getMessage(key2, null, key2, locale);

        return s1.compareToIgnoreCase(s2);
    }

}

