package org.drule.firewah;

import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication app = new SpringApplication(Application.class);
		app.setBannerMode(Banner.Mode.OFF);
		app.setHeadless(true);
		app.run(args);
	}
	
	
	@Bean
	public Object fert() {
		
		try {
			JSch jsch = new JSch();
			Session session = jsch.getSession(USER, HOST);
			session.setPassword(PASSWD);
			session.setConfig("StrictHostKeyChecking", "no");
			session.connect(60 * 1000);
			Channel channel = session.openChannel("shell");
			Expect expect = new Expect(channel.getInputStream(),
					channel.getOutputStream());
			channel.connect();
			expect.expect("$");
			System.out.println(expect.before + expect.match);
			expect.send("ls\n");
			expect.expect("$");
			System.out.println(expect.before + expect.match);
			expect.send("exit\n");
			expect.expectEOF();
			System.out.println(expect.before);
			expect.close();
			session.disconnect();
		} catch (JSchException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
d
		
		
	}
}