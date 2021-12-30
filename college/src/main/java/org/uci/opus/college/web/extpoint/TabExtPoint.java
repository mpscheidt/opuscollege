package org.uci.opus.college.web.extpoint;

/**
 * Represents an extension point for tabs.
 * 
 * @author Markus Pscheidt
 *
 */
public abstract class TabExtPoint extends HtmlLinkExtPoint {

    private String contentFile;

    public String getContentFile() {
        return contentFile;
    }

    public void setContentFile(String contentFile) {
        this.contentFile = contentFile;
    }

}
