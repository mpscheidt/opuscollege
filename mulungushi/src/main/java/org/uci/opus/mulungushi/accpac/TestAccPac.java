package org.uci.opus.mulungushi.accpac;

import org.uci.opus.mulungushi.data.AccPacDao;

// NB: Define the Dimensions data source with a BasicDataSource in applicationContext.xml
//     to run TestAccPac.

public class TestAccPac {
    
    public static void main(String[] params) {
//        ApplicationContext context =
//            new ClassPathXmlApplicationContext(new String[] {
//                 //"org/uci/opus/college/application.xml",
//                 "org/uci/opus/college/applicationContext.xml"
//                  ,"org/uci/opus/college/applicationContext-data.xml"
//                  , "org/uci/opus/college/applicationContext-service.xml"
//                  , "org/uci/opus/college/applicationContext-util.xml"
//                  ,"org/uci/opus/mulungushi/applicationContext.xml"
//                  ,"org/uci/opus/mulungushi/mulungushi-beans.xml"
//                  ,"org/uci/opus/mulungushi/applicationContext-service.xml"
////                  ,"org/uci/opus/accommodation/applicationContext.xml"
////                  ,"org/uci/opus/report/applicationContext.xml"
////                  ,"org/uci/opus/scholarship/applicationContext.xml"
//                    });
//        
////        DbConversion dbConversion = (DbConversion) context.getBean("dbConversion");
////        dbConversion.doMigration();
//        System.out.print("Hi!");
//
//        AccPacDao dimensionsDao = (AccPacDao) context.getBean("dimensionsDao");
//        dimensionsDao.testDimensionsView();
        
//        TestAccPac testDimensionsView = new TestAccPac();
//        testDimensionsView.testView();
        
        AccPacDao accPacDao = new AccPacDao();
        accPacDao.setUrl("http://41.63.17.247:8080/AccPackService/balance/{studentCode}");
        accPacDao.testAccPac("201404014");
    }

}
