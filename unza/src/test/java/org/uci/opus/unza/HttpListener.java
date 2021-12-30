/*******************************************************************************
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
 * The Original Code is Opus-College unza module code.
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
 ******************************************************************************/
package org.uci.opus.unza;
import java.net.*;   
import java.io.*;   
public class HttpListener {

	  private static int port=80, maxConnections=0;
	  // Listen for incoming connections and handle them
	  public static void main(String[] args) {
	    int i=0;

	    try{
	      ServerSocket listener = new ServerSocket(port);
	      Socket server;

	      while((i++ < maxConnections) || (maxConnections == 0)){
	        doComms connection;

	        server = listener.accept();
	        doComms conn_c= new doComms(server);
	        Thread t = new Thread(conn_c);
	        t.start();
	      }
	    } catch (IOException ioe) {
	      System.out.println("IOException on socket listen: " + ioe);
	      ioe.printStackTrace();
	    }
	  }

	}

	class doComms implements Runnable {
	    private Socket server;
	    private String line,input;

	    doComms(Socket server) {
	      this.server=server;
	    }

	    public void run () {

	      try {
	        // Get input from the client
	        DataInputStream in = new DataInputStream (server.getInputStream());
	        PrintStream out = new PrintStream(server.getOutputStream());
	        int byteRead;
	        while ((byteRead = in.read()) != -1) {
                System.out.print((char)byteRead);
             }

	        server.close();
	      } catch (IOException ioe) {
	        System.out.println("IOException on socket listen: " + ioe);
	        ioe.printStackTrace();
	      }
	 }
}

