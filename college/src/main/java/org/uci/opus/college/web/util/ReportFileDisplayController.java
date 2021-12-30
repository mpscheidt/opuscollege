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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.college.web.util;

import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.util.ServletUtil;


/**
 * @author smacumbe
 *Feb 13, 2009
 */


@Controller
@RequestMapping(value="/college/report/filedisplay.view")
public class ReportFileDisplayController {

    @Autowired private ReportPropertyMapper reportPropertyMapper;

    private static Logger log = LoggerFactory.getLogger(ReportFileDisplayController.class);

    @RequestMapping(method=RequestMethod.GET)
    public void doFileDisplay(final HttpServletRequest request, 
            final HttpServletResponse response) throws IOException {

        int propertyId = ServletUtil.getParamSetAttrAsInt(request, "propertyId", 0);

        ReportProperty property = reportPropertyMapper.findOne(propertyId);
        byte[] file = null;

        if (property != null) {
            response.setContentType(property.getType());
            response.setHeader("Content-Disposition", "inline;filename=" + property.getName());
            file = property.getFile();
        }

        if (file != null) {

            response.setStatus(HttpServletResponse.SC_OK);
            ServletOutputStream out = response.getOutputStream();
            out.write(file);
            out.flush();
            out.close();
        }
    }

}
