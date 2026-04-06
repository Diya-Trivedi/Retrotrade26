package Retrotrade.service;

import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import Retrotrade.entity.UserEntity;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {

    @Autowired
    private JavaMailSender javaMailSender; // Make it private

    @Autowired
    private ResourceLoader resourceLoader;

    public void sendWelcomeMail(UserEntity user) {
        
        System.out.println("📧 Attempting to send welcome email to: " + user.getEmail());
        
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            // Load template
            Resource resource = resourceLoader.getResource("classpath:templates/welcome-email.html");
            
            String html;
            if (resource.exists()) {
                html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
                html = html.replace("${name}", user.getFirstName())
                          .replace("${email}", user.getEmail())
                          .replace("${loginUrl}", "http://localhost:9999/login")
                          .replace("${companyName}", "Retrotrade");
            } else {
                // Fallback HTML if template not found
                html = String.format("""
                    <!DOCTYPE html>
                    <html>
                    <head><meta charset="UTF-8">
                    <style>body{font-family:Arial,sans-serif;}</style></head>
                    <body style="background:linear-gradient(135deg,#667eea 0%%,#764ba2 100%%);padding:40px;">
                    <div style="max-width:600px;margin:0 auto;background:white;border-radius:15px;padding:30px;">
                    <h2 style="color:#333;">Hello %s,</h2>
                    <p style="color:#666;">Thank you for joining Retrotrade!</p>
                    <p style="color:#666;">Your email: %s</p>
                    <a href="%s" style="display:inline-block;background:linear-gradient(135deg,#667eea 0%%,#764ba2 100%%);
                    color:white;padding:12px 30px;border-radius:25px;text-decoration:none;">Login to Your Account</a>
                    </div></body></html>
                    """, user.getFirstName(), user.getEmail(), "http://localhost:9999/login");
            }

            helper.setFrom("trivedidiya65@gmail.com");
            helper.setTo(user.getEmail());
            helper.setSubject("🎉 Welcome to Retrotrade!");
            helper.setText(html, true);

            javaMailSender.send(message);
            System.out.println("✅ Welcome email sent successfully to: " + user.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Failed to send welcome email to: " + user.getEmail());
            e.printStackTrace();
        }
    }

    public void sendOtpMail(String toEmail, String otp) {
        
        System.out.println("📧 Attempting to send OTP email to: " + toEmail);
        
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            String html = String.format("""
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8">
                <style>
                    body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); padding: 40px; }
                    .container { max-width: 400px; margin: 0 auto; background: white; border-radius: 15px; padding: 30px; }
                    .otp-box { background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); color: white; font-size: 32px; 
                              font-weight: bold; text-align: center; padding: 20px; border-radius: 10px; margin: 20px 0; }
                </style>
                </head>
                <body>
                <div class="container">
                    <h2 style="color:#333;">Password Reset OTP</h2>
                    <p>Your OTP for password reset is:</p>
                    <div class="otp-box">%s</div>
                    <p style="color:#666;font-size:14px;">This OTP is valid for 10 minutes. Do not share it with anyone.</p>
                </div>
                </body>
                </html>
                """, otp);

            helper.setFrom("trivedidiya65@gmail.com");
            helper.setTo(toEmail);
            helper.setSubject("🔐 Password Reset OTP - Retrotrade");
            helper.setText(html, true);

            javaMailSender.send(message);
            System.out.println("✅ OTP email sent successfully to: " + toEmail);

        } catch (Exception e) {
            System.err.println("❌ Failed to send OTP email to: " + toEmail);
            e.printStackTrace();
        }
    }
}