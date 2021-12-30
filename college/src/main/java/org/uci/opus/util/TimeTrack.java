package org.uci.opus.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class to measure performance
 * 
 * @author Markus Pscheidt
 *
 */
public class TimeTrack {
	
	private Logger log = LoggerFactory.getLogger(getClass());

	private String description;
	private long begin, last;
	
	public TimeTrack(String description) {
		this.description = description;
		this.last = this.begin = System.currentTimeMillis();

		log.info(this.description + ": starting timer measurement");
	}

	public void measure(String measureDescription) {
		long now = System.currentTimeMillis();
		log(measureDescription, last, now);
		last = now;
	}

	public void end() {
		last = System.currentTimeMillis();
		log("total", begin, last);
	}

	public void end(String measureDescription) {
		this.measure(measureDescription);
		this.end();
	}

	private void log(String measureDescription, long t1, long t2) {

		log.info(this.description + " - " + measureDescription + ": " + (t2 - t1) + " ms");
	}

}
