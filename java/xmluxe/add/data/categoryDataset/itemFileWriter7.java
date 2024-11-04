// Mario Fantini, David J. Eck, w3resource.
import java.io.*;
public class itemFileWriter7 {
	public static void main(String[] args) throws IOException{
		InputStream istream;		
		int c;
		final int EOF = -1;
		istream = System.in;
		FileWriter outFile =  new FileWriter("/tmp/xmluxe-elementItem");	
		BufferedWriter bWriter = new BufferedWriter(outFile);
		System.out.println("There are not Item elements. Type Item element 'title' – Press Enter Ctrl+d to end");
		
		while ((c = istream.read()) != EOF)
			bWriter.write(c);	
		bWriter.close();
	}
}
