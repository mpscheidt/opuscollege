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

package org.uci.opus.college.web.extpoint;

/**
 * A convenience class that serves as a base class for web interface extension points.
 * I.e. menu items and html links.
 * 
 * @author markus
 *
 */
public abstract class HtmlLinkExtPoint {

    private String titleKey;
    private String descriptionKey;
    private String href;

    /**
     * The title, which will be used as the menu item.
     * Note: this is the I18n key that is looked up in the message file.
     * @return title string
     */
    public String getTitleKey() {
        return titleKey;
    }

    /**
     * The description, which is a bit more informative than the title.
     * It will be shown as a hint when the mouse is over the menu item.
     * Note: this is the I18n key that is looked up in the message file.
     * @return string with description key
     */
    public String getDescriptionKey() {
        return descriptionKey;
    }

    /**
     * The web URL that will be used when the menu is selected.
     * @return href string
     */
    public String getHref() {
        return href;
    }

    public void setTitleKey(String titleKey) {
        this.titleKey = titleKey;
    }

    public void setDescriptionKey(String descriptionKey) {
        this.descriptionKey = descriptionKey;
    }

    public void setHref(String href) {
        this.href = href;
    }

}
