/*******************************************************************************
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
 * The Original Code is Opus-College mulungushi module code.
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
 ******************************************************************************/
package org.uci.opus.mulungushi.dbconversion;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Note: Add the following to the "Run configuration... / classpath":
 *   /opus/src/main/webapp/WEB-INF/classes 
 * 
 * @author markus
 *
 */
public class StartDbConversion {

    public static void main(String[] params) throws Exception {
        ApplicationContext context =
            new ClassPathXmlApplicationContext(new String[] {
                 //"org/uci/opus/college/application.xml",
                 "org/uci/opus/college/applicationContext.xml"
                  ,"org/uci/opus/college/applicationContext-data.xml"
                  , "org/uci/opus/college/applicationContext-service.xml"
                  , "org/uci/opus/college/applicationContext-util.xml"
            	  ,"org/uci/opus/mulungushi/applicationContext.xml"
                  ,"org/uci/opus/mulungushi/mulungushi-beans.xml"
//                  ,"org/uci/opus/accommodation/applicationContext.xml"
//                  ,"org/uci/opus/report/applicationContext.xml"
//                  ,"org/uci/opus/scholarship/applicationContext.xml"
            		});
        
        DbConversion dbConversion = (DbConversion) context.getBean("dbConversion");
        dbConversion.doMigration();
    }
    
}
