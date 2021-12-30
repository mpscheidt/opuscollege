package org.uci.opus.cbu.dimensions;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.uci.opus.cbu.data.DimensionsDao;

// NB: Define the Dimensions data source with a BasicDataSource in applicationContext.xml
//     to run TestDimensionsView.

public class TestDimensionsView {
    
    public static void main(String[] params) {
        ApplicationContext context =
            new ClassPathXmlApplicationContext(new String[] {
                 //"org/uci/opus/college/application.xml",
                 "org/uci/opus/college/applicationContext.xml"
                  ,"org/uci/opus/college/applicationContext-data.xml"
                  , "org/uci/opus/college/applicationContext-service.xml"
                  , "org/uci/opus/college/applicationContext-util.xml"
                  ,"org/uci/opus/cbu/applicationContext.xml"
                  ,"org/uci/opus/cbu/cbu-beans.xml"
                  ,"org/uci/opus/cbu/applicationContext-service.xml"
//                  ,"org/uci/opus/accommodation/applicationContext.xml"
//                  ,"org/uci/opus/report/applicationContext.xml"
//                  ,"org/uci/opus/scholarship/applicationContext.xml"
                    });
        
//        DbConversion dbConversion = (DbConversion) context.getBean("dbConversion");
//        dbConversion.doMigration();
        System.out.print("Hi!");

        DimensionsDao dimensionsDao = (DimensionsDao) context.getBean("dimensionsDao");
        dimensionsDao.testDimensionsView();
        
//        TestDimensionsView testDimensionsView = new TestDimensionsView();
//        testDimensionsView.testView();
    }

}
