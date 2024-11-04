// Mario Fantini, David J. Eck, w3resource.
package filepackage;
import java.io.*;
public class parsingChoice {
	public static void main(String[] args) throws IOException{
		InputStream istream;		
		int c;
		final int EOF = -1;
		istream = System.in;
		FileWriter outFile =  new FileWriter("/tmp/xmluxe-parsingChoice");	
		BufferedWriter bWriter = new BufferedWriter(outFile);
		System.out.println("You have /tmp/xmluxe-renderCss/");
		System.out.println("Express your choise");
System.out.println(" ");
System.out.println("1. view it now by chromium;");
System.out.println(" ");
System.out.println("2. copy /tmp/xmluxe-renderCss folder in the path");
System.out.println("that you'll specify interactively now;");
System.out.println(" ");
System.out.println("3. view it now by chromium, and copy /tmp/xmluxe-renderCss folder in the path");
System.out.println("that you'll specify interactively now");
System.out.println("Type choice – Press Enter Ctrl+d to end");
		while ((c = istream.read()) != EOF)
			bWriter.write(c);	
		bWriter.close();
	}
}
