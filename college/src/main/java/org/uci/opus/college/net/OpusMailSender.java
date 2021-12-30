package org.uci.opus.college.net;

import org.springframework.mail.javamail.JavaMailSenderImpl;

/**
 * 
 * @author stelio2
 * Class with convenient methods for setting mail settings
 * This will help to minimalize the amount of code needed to set mail settings
 */
public class OpusMailSender extends JavaMailSenderImpl {

	
	private boolean tlsEnabled ;
	private boolean requiresAuthentication;
	
	public boolean isTlsEnabled() {
		return tlsEnabled;
	}
	
	public void setTlsEnabled(boolean tlsEnabled) {

		getJavaMailProperties().put("mail.smtp.starttls.enable", tlsEnabled);
		
		this.tlsEnabled = tlsEnabled;
	}
	
	public boolean isRequiresAuthentication() {
		return requiresAuthentication;
	}
	
	public void setRequiresAuthentication(boolean requiresAuthentication) {

		getJavaMailProperties().put("mail.smtp.auth", requiresAuthentication);
		
		this.requiresAuthentication = requiresAuthentication;
	}
	
	/**
	 * Convenience for method setting Google Mail settings
	 * @param userName
	 * @param password
	 */
	public void setGoogleMailSettings(String userName, String password){
		setTlsEnabled(true);
		setRequiresAuthentication(true);
		
		setHost("smtp.gmail.com");
		setPort(587);
		
		setUsername(userName);
		setPassword(password);
	}

	/**
	 * Convenience for method setting Yahoo Mail settings
	 * @param userName
	 * @param password
	 */
	public void setYahooMailSettings(String userName, String password){
		
		setTlsEnabled(true);
		setRequiresAuthentication(true);
		
		setHost("smtp.mail.yahoo.com");
		setPort(465);
		
		setUsername(userName);
		setPassword(password);
	}
	

	/**
	 * Convenience for method setting Hot Mail settings
	 * @param userName
	 * @param password
	 */
	public void setHotMailSettings(String userName, String password){
		
		setTlsEnabled(true);
		setRequiresAuthentication(true);
		
		setHost("smtp.live.com");
		setPort(587);
		
		setUsername(userName);
		setPassword(password);
	}
	
	/**
	 * Adds a property to the javamail properties
	 * @param key
	 * @param value
	 */
	public void setJavaMailProperty(String key, String value){
		
		getJavaMailProperties().put(key, value);
	}
	
}
