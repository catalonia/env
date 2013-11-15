package com.tastesync.common;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

public class SendMail {
	private JavaMailSenderImpl mailSender;
	private ApplicationContext context;
	
	public SendMail() {
		context = new ClassPathXmlApplicationContext("/spring/beans/SrpingMail.xml");
		mailSender = (JavaMailSenderImpl) context.getBean("mailSender");
	}
	
	public void sendMail(String from, String to, String subject, String msg) {
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		try {
			MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "utf-8");
			mimeMessage.setContent(msg, "text/html");
			helper.setFrom(from);
			helper.setTo(to);
			helper.setSubject(subject);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		mailSender.send(mimeMessage);	
	}
}
