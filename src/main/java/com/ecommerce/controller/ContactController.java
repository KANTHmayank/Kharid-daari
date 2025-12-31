package com.ecommerce.controller;

import com.ecommerce.model.ContactMessage;
import com.ecommerce.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ContactController {

    @Autowired
    private ContactService contactService;

    @GetMapping("/contact")
    public String contactPage() {
        return "contact";
    }

    @PostMapping("/contact")
    public String submitContact(@RequestParam String name,
                               @RequestParam String email,
                               @RequestParam String message,
                               Model model) {
        try {
            ContactMessage contactMessage = new ContactMessage(name, email, message);
            contactService.saveMessage(contactMessage);
            
            model.addAttribute("success", "Thank you for contacting us! We'll get back to you soon.");
            return "contact";
        } catch (Exception e) {
            model.addAttribute("error", "An error occurred. Please try again.");
            return "contact";
        }
    }
}
