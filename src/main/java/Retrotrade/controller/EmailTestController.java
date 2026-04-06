package Retrotrade.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import Retrotrade.entity.UserEntity;
import Retrotrade.service.MailerService;

@Controller
public class EmailTestController {
    
    @Autowired
    private JavaMailSender javaMailSender;
    
    @Autowired
    private MailerService mailerService;
    
    @GetMapping("/test-email-simple")
    @ResponseBody
    public String testSimpleEmail() {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("trivedidiya65@gmail.com");
            message.setTo("trivedidiya65@gmail.com"); // Send to yourself for testing
            message.setSubject("Test Email from Retrotrade");
            message.setText("This is a simple test email from Retrotrade application.");
            
            javaMailSender.send(message);
            return "✅ Simple test email sent successfully! Check your inbox.";
        } catch (Exception e) {
            e.printStackTrace();
            return "❌ Error: " + e.getMessage();
        }
    }
    
    @GetMapping("/test-welcome-email")
    @ResponseBody
    public String testWelcomeEmail() {
        try {
            UserEntity testUser = new UserEntity();
            testUser.setFirstName("Test");
            testUser.setLastName("User");
            testUser.setEmail("trivedidiya65@gmail.com"); // Send to yourself
            testUser.setContactNum("1234567890");
            
            mailerService.sendWelcomeMail(testUser);
            return "✅ Welcome test email sent! Check your inbox.";
        } catch (Exception e) {
            e.printStackTrace();
            return "❌ Error: " + e.getMessage();
        }
    }
}