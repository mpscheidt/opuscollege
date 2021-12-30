package org.uci.opus.unza;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

public class SendThread extends Thread{
	private String url = "";
	public void run(){
		HttpClient httpClient = null;
		HttpGet httpGet = null;
    	httpClient = new DefaultHttpClient();
    	httpGet = new HttpGet(url);

    	try {
		HttpResponse response=	httpClient.execute(httpGet);
	
    	} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public void setUrl(String url){
		this.url = url;
	}
}
