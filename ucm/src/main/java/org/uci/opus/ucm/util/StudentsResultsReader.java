package org.uci.opus.ucm.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.uci.opus.ucm.domain.StudentResult;


public interface StudentsResultsReader {

	/**
	 * Reads results from a given stream
	 * @param stream
	 * @return
	 * @throws IOException 
	 */
	List<StudentResult> getResults(InputStream stream) throws IOException;

}
