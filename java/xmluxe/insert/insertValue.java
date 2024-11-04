// Mario Fantini, David J. Eck, w3resource.
package filepackage;
import java.io.*;
public class insertValue {
	public static void main(String[] args) throws IOException{
		InputStream istream;		
		int c;
		final int EOF = -1;
		istream = System.in;
		FileWriter outFile =  new FileWriter("/tmp/xmluxe-insertValue");	
		BufferedWriter bWriter = new BufferedWriter(outFile);
		System.out.println("Type value of the Key – Press Enter Ctrl+d to end");
		while ((c = istream.read()) != EOF)
			bWriter.write(c);	
		bWriter.close();
	}
}
