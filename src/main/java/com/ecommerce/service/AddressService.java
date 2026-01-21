package com.ecommerce.service;

import com.ecommerce.model.Address;
import com.ecommerce.repository.AddressRepository;
import com.ecommerce.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AddressService {

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Address> getUserAddresses(Long userId) {
        return addressRepository.findByUserId(userId);
    }

    public Address getAddressById(Long id) {
        return addressRepository.findById(id);
    }

    public Address getDefaultAddress(Long userId) {
        return addressRepository.findDefaultByUserId(userId);
    }

    public Long addAddress(Address address) {
        // Validate required fields
        if (address.getLine1() == null || address.getLine1().trim().isEmpty()) {
            throw new RuntimeException("Address Line 1 is required");
        }
        if (address.getCity() == null || address.getCity().trim().isEmpty()) {
            throw new RuntimeException("City is required");
        }
        if (address.getCountry() == null || address.getCountry().trim().isEmpty()) {
            throw new RuntimeException("Country is required");
        }

        // If this is set as default, clear other defaults first
        if (address.isDefault()) {
            addressRepository.clearDefaultForUser(address.getUserId());
        }

        Long addressId = addressRepository.create(address);
        userRepository.updateTimestamp(address.getUserId());
        return addressId;
    }

    public void updateAddress(Address address) {
        // Validate the address belongs to the user
        Address existing = addressRepository.findById(address.getId());
        if (existing == null) {
            throw new RuntimeException("Address not found");
        }
        if (!existing.getUserId().equals(address.getUserId())) {
            throw new RuntimeException("Unauthorized to update this address");
        }

        // If setting as default, clear other defaults first
        if (address.isDefault() && !existing.isDefault()) {
            addressRepository.clearDefaultForUser(address.getUserId());
        }

        addressRepository.update(address);
        userRepository.updateTimestamp(address.getUserId());
    }

    public void deleteAddress(Long addressId, Long userId) {
        Address address = addressRepository.findById(addressId);
        if (address == null) {
            throw new RuntimeException("Address not found");
        }
        if (!address.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized to delete this address");
        }

        addressRepository.delete(addressId);
        userRepository.updateTimestamp(userId);
    }

    public void setDefaultAddress(Long addressId, Long userId) {
        Address address = addressRepository.findById(addressId);
        if (address == null) {
            throw new RuntimeException("Address not found");
        }
        if (!address.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized to modify this address");
        }

        addressRepository.setAsDefault(addressId, userId);
        userRepository.updateTimestamp(userId);
    }
}
