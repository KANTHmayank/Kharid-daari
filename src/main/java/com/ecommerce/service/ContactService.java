package com.ecommerce.service;

import com.ecommerce.model.ContactMessage;
import com.ecommerce.repository.ContactMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ContactService {

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    public ContactMessage saveMessage(ContactMessage message) {
        return contactMessageRepository.save(message);
    }
}
