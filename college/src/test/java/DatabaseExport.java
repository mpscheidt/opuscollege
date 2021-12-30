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

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.dbunit.DatabaseUnitException;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSet;


/**
 * A convenience class to quickly export database content into
 * a flat XML file, which can be used to setup DBUnit tests.
 * 
 * The created file is called 'partial.xml'.
 * 
 * @see http://www.dbunit.org/faq.html#extract
 * 
 * @author markus
 *
 */

public class DatabaseExport {

    // Hide constructor for utility classes
    private DatabaseExport() {
    }

    public static void main(String[] args) throws ClassNotFoundException, SQLException, FileNotFoundException, IOException, DatabaseUnitException {
        // database connection
        @SuppressWarnings("unused")
        Class<?> driverClass = Class.forName("org.postgresql.Driver");
        Connection jdbcConnection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/opusCollege-ucm", "postgres", "123koffie");
        IDatabaseConnection connection = new DatabaseConnection(jdbcConnection);
        
        // We are used to specify <schema>.<tablename>, therefore need to turn on
        // the following feature, otherwise "ambiguity exception" occurs
        // see http://www.dbunit.org/properties.html#qualifiedtablenames
        DatabaseConfig config = connection.getConfig(); 
        config.setProperty("http://www.dbunit.org/features/qualifiedTableNames", true);
        

        // partial database export
        QueryDataSet partialDataSet = new QueryDataSet(connection);
        String tableName = "opuscollege.reportproperty";
        partialDataSet.addTable(tableName, 
                "select " + tableName + ".* from " + tableName
            );
        FlatXmlDataSet.write(partialDataSet, new FileOutputStream("partial.xml"));

    }
}
