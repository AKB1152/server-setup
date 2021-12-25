import java.util.Scanner;
import java.io.File;
import java.io.PrintStream;

public class serverconf {
	
	// ip port file
	public static void main (String[] args) {
		String cfg = "<VirtualHost *:$port>\n\tDocumentRoot \"/var/www/nextcloud\"\n\tServerName $ip\n\n\tErrorLog ${APACHE_LOG_DIR}/nextcloud.error\n\tCustomLog ${APACHE_LOG_DIR}/nextcloud.access combined\n\n\t<Directory /var/www/nextcloud/>\n\t\tRequire all granted\n\t\tOptions FollowSymlinks MultiViews\n\t\tAllowOverride All\n\n\t\t<IfModule mod_dav.c>\n\t\t\tDav off\n\t\t</IfModule>\n\n\t\tSetEnv HOME /var/www/nextcloud\n\t\tSetEnv HTTP_HOME /var/www/nextcloud\n\t\tSatisfy Any\n\t</Directory>\n</VirtualHost>";
		cfg = cfg.replace ("$ip", args[0]).replace("$port", args[1]);
		
		if (!new File (args[2]).exists())
			new File(args[2]).createNewFile();
		PrintStream ps = new PrintStream (new File (args[2]), "utf-8"));
		ps.close();
		return; 
	}
}
