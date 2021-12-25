import java.util.Scanner;
import java.io.File;
import java.io.PrintStream;

public class httpscfg {
	// H 
	// args ip, file
	public static void main (String[] args) {
		String config = "", tmp;
		Scanner cfgsc = new Scanner (new File(args[1]), "utf-8"); 
		int tabs = 0; 
		while (cfgsc.hasNext()) {
			tmp = cfgsc.nextLine(); 
			tabs += (tmp.matches ("\\s<^[/]"))? 1 : 0; 
			tabs -= (tmp.matches ("[\\s</]|[.*/>.*]"))? 1 : 0;
			if (tmp.contains ("ServerName")) tmp = "ServerName "+args[0];
			if (tmp.contains ("</VirtualHost>") tmp = "\teader always set Strict-Transport-Security \"max-age=31536000\"\n"+getTabs(tabs)+"</VirutalHost>";
			config += getTabs(tabs) + tmp + "\n"; 
		}
				
		PrintStream ps = new PrintStream (new File (args[1]), "utf-8");
		ps.println (config);
		ps.close();
		cfgsc.close(); 
		return; 
	}
				
	private static String getTabs (int tabs) {
		String res = ""; 
		for (int i=0; i < tabs; i++) 
			res += "\t";
		return res;
	}
				
				
}
