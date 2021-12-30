package org.uci.opus.cbu.data;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Logger {
	public static void log(String str){
		try {
			FileWriter writer=new FileWriter(new File("/home/benjmaz/Documents/Data Conversion Log.txt"),true);
			writer.write(str);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
