package org.uci.opus.unza;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.log4j.Logger;

public class BankRequestsSender {
	   private static Logger log = Logger.getLogger(BankRequestsSender.class);
	/**
	 * @param args
	 */
   SendThread thread = null;	   
   public static void main(String[] args) {
/*
//		String postUrl = "http://localhost:8080/opus/PostTran?RequestId=ECJ62ICW1&Key=NzIzMGJhYzJiZWU5MDZmZGQ0OTY0YTMwZTQ0M2FmYTdmNmVhNjRjYQ==&StudentID=00000215&NRC=199720/31/1&Date=2012-04-19%2009:19:40&Amount=1240000&TranID=ECJ62ICL9&Name=0831010000000019:INNOCENT_MAKASA&Type=0&Phone=N";
//		String queryUrl = "http://localhost:8080/opus/QueryStatus?RequestId=EEOGQGV67&Key=YzAzNzUyYzc5YTM2YzM3NmVlMDE4NTkyZWJhMDQ0NWFhNDU2MDQ2ZA==&TranID=ECJ62ICL9";
		String reverseUrl = "http://localhost:8080/opus/ReverseTransaction?RequestId=EERWIXRR6&Key=NjZkZDU4MjFjZmYwMWJiMWQxN2ZjZjY3Zjc2MjQzNzU3MjNlZDA2ZA==&StudentID=00000215&NRC=199720/31/1&Date=2012-04-19%2010:20:30&Amount=1240000&TranID=ECJ62ICL9";
		HttpClient httpClient = null;
*/

// testcase 1:
          String postUrl = "http://localhost:8080/opus/PostTran?RequestId=ECJ62ICW1&Key=NzIzMGJhYzJiZWU5MDZmZGQ0OTY0YTMwZTQ0M2FmYTdmNmVhNjRjYQ==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2009:19:40&Amount=1240000&TranID=ECJ62ICL8&Name=0831010000000019:INNOCENT_MAKASA&Type=0&Phone=N";
		  String queryUrl = "http://localhost:8080/opus/QueryStatus?RequestId=EEOGQGV67&Key=YzAzNzUyYzc5YTM2YzM3NmVlMDE4NTkyZWJhMDQ0NWFhNDU2MDQ2ZA==&TranID=ECJ62ICL8";
		  String reverseUrl = "http://localhost:8080/opus/ReverseTransaction?RequestId=EERWIXRR6&Key=NjZkZDU4MjFjZmYwMWJiMWQxN2ZjZjY3Zjc2MjQzNzU3MjNlZDA2ZA==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2010:20:30&Amount=1240000&TranID=ECJ62ICL8";
// testcase 2:
//	   	String postUrl ="http://localhost:8080/opus/PostTran?RequestId=ECJ62ICW1&Key=NzIzMGJhYzJiZWU5MDZmZGQ0OTY0YTMwZTQ0M2FmYTdmNmVhNjRjYQ==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2009:19:40&Amount=1240000&TranID=ECJ62ICL7&Name=0831010000000019:INNOCENT_MAKASA&Type=0&Phone=N";
//        String queryUrl = "http://localhost:8080/opus/QueryStatus?RequestId=EEOGQGV67&Key=YzAzNzUyYzc5YTM2YzM3NmVlMDE4NTkyZWJhMDQ0NWFhNDU2MDQ2ZA==&TranID=ECJ62ICL9";
//        String reverseUrl = "http://localhost:8080/opus/ReverseTransaction?RequestId=EERWIXRR6&Key=NjZkZDU4MjFjZmYwMWJiMWQxN2ZjZjY3Zjc2MjQzNzU3MjNlZDA2ZA==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2010:20:30&Amount=1240000&TranID=ECJ62ICL7";
//testcase3
//        String postUrl ="http://localhost:8080/opus/PostTran?RequestId=ECJ62ICL7&Key=Njg1ZWQwMmNkMWVkNWEwMGQ1NjgwODMxZjQzNDUwYmNhYTE1OGU3Yw==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2009:19:40&Amount=1240000&TranID=ECJ62ICL7&Name=0831010000000019:INNOCENT_MAKASA&Type=0&Phone=N";
//        String queryUrl = "http://localhost:8080/opus/QueryStatus?RequestId=ECJ62ICL7&Key=Njg1ZWQwMmNkMWVkNWEwMGQ1NjgwODMxZjQzNDUwYmNhYTE1OGU3Yw==&TranID=ECJ62ICL7";
//        String reverseUrl = "http://localhost:8080/opus/ReverseTransaction?RequestId=ECJ62ICL7&Key=Njg1ZWQwMmNkMWVkNWEwMGQ1NjgwODMxZjQzNDUwYmNhYTE1OGU3Yw==&StudentID=11000135&NRC=199720/31/1&Date=2012-04-19%2010:20:30&Amount=1240000&TranID=ECJ62ICL7";
        HttpClient httpClient = null;

		HttpGet httpGet = null;
		SendThread thread = null;
		for(int i=0;i <1;i++){
	    	try{
/*		    	System.out.println("starting sending query"+i);
	    		thread = new SendThread();
	    		thread.setUrl(queryUrl);
	    		thread.start();
		    	System.out.println("finished sending query"+i);	    		
	    		try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
*/		    	System.out.println("starting sending post"+i);
	    		thread = new SendThread();
	    		thread.setUrl(postUrl);
	    		thread.start();
		    	System.out.println("finished sending post"+i);	    		
	    		try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
/*		    	System.out.println("starting sending reverse"+i);
	    		thread = new SendThread();
	    		thread.setUrl(reverseUrl);
	    		thread.start();
		    	System.out.println("finished sending reverse"+i);	    		
	    		try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}						
*/	    	}
	    	catch(Exception c){
	    		log.error(c.getMessage());
	    	}

		}

	}

}
