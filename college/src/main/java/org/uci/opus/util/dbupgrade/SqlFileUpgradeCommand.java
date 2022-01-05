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

package org.uci.opus.util.dbupgrade;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.test.jdbc.JdbcTestUtils;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.module.Module;

@SuppressWarnings("serial")
public class SqlFileUpgradeCommand implements DbUpgradeCommandInterface, Serializable {

    private static Logger logger = LoggerFactory.getLogger(SqlFileUpgradeCommand.class);
    private Resource sqlFile;
    private JdbcTemplate jdbcTemplate;
    private String order;
    private Module module;
    private double version;

    @Override
    @Transactional
    public void doDatabaseUpgrade() {

        // inspired by SimpleJdbcTestUtils.executeSqlScript()
        EncodedResource resource = new EncodedResource(sqlFile);
        long startTime = System.currentTimeMillis();
        List<String> statements = new LinkedList<>();
        logger.info(resource + " starts.");
        try {
            LineNumberReader lnr = new LineNumberReader(resource.getReader());
            String script = ScriptUtils.readScript(lnr, "--", ";");
            String delimiter = ";";
            if (!ScriptUtils.containsSqlScriptDelimiters(script, delimiter)) {
                delimiter = "\n";
            }
            ScriptUtils.splitSqlScript(script, delimiter, statements);
            for (String statement : statements) {
                jdbcTemplate.execute(statement);
            }
            if (logger.isInfoEnabled()) {
                long elapsedTime = System.currentTimeMillis() - startTime;
                logger.info(resource + " finished in " + elapsedTime + " ms.");
            }
        } catch (IOException ex) {
            throw new DataAccessResourceFailureException("Failed to open SQL script from " + resource, ex);
        }
    }

    @Override
    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("SQL file upgrade: ");
        b.append(getSqlFile());
        return b.toString();
    }

    public void setSqlFile(Resource sqlFile) {
        this.sqlFile = sqlFile;
    }

    public Resource getSqlFile() {
        return sqlFile;
    }

    public void setDataSource(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public void setModule(Module module) {
        this.module = module;
    }

    @Override
    public Module getModule() {
        return module;
    }

    public void setVersion(double version) {
        this.version = version;
    }

    @Override
    public double getVersion() {
        return version;
    }

}
