package Retrotrade;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.cloudinary.Cloudinary;

@SpringBootApplication
public class RetrotradeApplication {

	public static void main(String[] args) {
		SpringApplication.run(RetrotradeApplication.class, args);
	}
	
	@Bean
	PasswordEncoder getPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	Cloudinary getCloudinary() {
		Map<String, String> config = new HashMap<>();
		config.put("cloud_name", "dmcqwwflj");
		config.put("api_key", "634484852259742");
		config.put("api_secret", "afZc44wDjkJqROBIEOP1yo6Htm4");
		return new Cloudinary(config);
	}

}
