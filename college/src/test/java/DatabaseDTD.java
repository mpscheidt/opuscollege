import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;

import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.dataset.xml.FlatDtdDataSet;

import util.TestDatabaseConfig;


/**
 * Create a DTD of the database.
 * 
 * @see http://dbunit.sourceforge.net/faq.html#generatedtd
 * 
 * @author markus
 *
 */
public class DatabaseDTD {

    private static final String DTD_OUTPUT_FILENAME = "src/test/java/opuscollege.dtd";

    public static void main(String[] args) throws Exception
    {
        // database connection
        Class driverClass = Class.forName("org.hsqldb.jdbcDriver");
        Connection jdbcConnection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/opusTest", "postgres", "123koffie");
        IDatabaseConnection connection = new DatabaseConnection(jdbcConnection);
        TestDatabaseConfig.setUpDatabaseConfig(connection.getConfig());
        
        // write DTD file
        FlatDtdDataSet.write(connection.createDataSet(), new FileOutputStream(DTD_OUTPUT_FILENAME));
    }

}
