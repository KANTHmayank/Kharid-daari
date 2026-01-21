package com.ecommerce.controller;

import com.ecommerce.model.Address;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Order;
import com.ecommerce.service.AddressService;
import com.ecommerce.service.CartService;
import com.ecommerce.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @Autowired
    private CartService cartService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private OrderService orderService;

    private Long getUserId(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            throw new RuntimeException("User not logged in");
        }
        return userId;
    }

    @GetMapping
    public String startCheckout(HttpSession session) {
        try {
            Long userId = getUserId(session);
            Cart cart = cartService.getOrCreateCart(userId);
            if (cart == null || cart.getItems().isEmpty()) {
                 return "redirect:/cart";
            }
            return "redirect:/checkout/shipping";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @GetMapping("/shipping")
    public String showShippingPage(HttpSession session, Model model) {
        try {
            Long userId = getUserId(session);
            List<Address> addresses = addressService.getUserAddresses(userId);
            model.addAttribute("addresses", addresses);
            
            Long selectedAddressId = (Long) session.getAttribute("checkoutAddressId");
            if (selectedAddressId != null) {
                model.addAttribute("selectedAddressId", selectedAddressId);
            }
            
            return "checkout-shipping";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/shipping")
    public String processShipping(@RequestParam("addressId") Long addressId, HttpSession session) {
        session.setAttribute("checkoutAddressId", addressId);
        return "redirect:/checkout/billing";
    }

    @GetMapping("/billing")
    public String showBillingPage(HttpSession session, Model model) {
        try {
            Long userId = getUserId(session);
            Cart cart = cartService.getOrCreateCart(userId);
            model.addAttribute("cart", cart);

            // Fetch addresses for billing selection
            List<Address> addresses = addressService.getUserAddresses(userId);
            model.addAttribute("addresses", addresses);
            
            @SuppressWarnings("unchecked")
            Map<String, String> billingInfo = (Map<String, String>) session.getAttribute("checkoutBillingInfo");
            if (billingInfo != null) {
                model.addAttribute("billingInfo", billingInfo);
            }
            
            Long billingAddressId = (Long) session.getAttribute("checkoutBillingAddressId");
            if (billingAddressId != null) {
                model.addAttribute("selectedBillingAddressId", billingAddressId);
            }

            Boolean sameAsShipping = (Boolean) session.getAttribute("sameAsShipping");
            model.addAttribute("sameAsShipping", sameAsShipping != null ? sameAsShipping : true); // Default to true
            
            return "checkout-billing";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/billing")
    public String processBilling(@RequestParam("cardNumber") String cardNumber,
                               @RequestParam("cardName") String cardName,
                               @RequestParam("expiryDate") String expiryDate,
                               @RequestParam("cvv") String cvv,
                               @RequestParam(value = "sameAsShipping", required = false) boolean sameAsShipping,
                               @RequestParam(value = "addressId", required = false) Long addressId,
                               @RequestParam(value = "navigation", required = false, defaultValue = "next") String navigation,
                               HttpSession session) {
        Map<String, String> billingInfo = new HashMap<>();
        billingInfo.put("cardNumber", cardNumber);
        billingInfo.put("cardName", cardName);
        billingInfo.put("expiryDate", expiryDate);
        billingInfo.put("cvv", cvv);
        session.setAttribute("checkoutBillingInfo", billingInfo);
        
        session.setAttribute("sameAsShipping", sameAsShipping);
        
        if (sameAsShipping) {
            Long shippingAddressId = (Long) session.getAttribute("checkoutAddressId");
            session.setAttribute("checkoutBillingAddressId", shippingAddressId);
        } else if (addressId != null) {
            session.setAttribute("checkoutBillingAddressId", addressId);
        }

        if ("back".equals(navigation)) {
             return "redirect:/checkout/shipping";
        }
        
        return "redirect:/checkout/review";
    }

    @GetMapping("/review")
    public String showReviewPage(HttpSession session, Model model) {
        try {
            Long userId = getUserId(session);
            Long addressId = (Long) session.getAttribute("checkoutAddressId");
            if (addressId == null) {
                return "redirect:/checkout/shipping";
            }

            Cart cart = cartService.getOrCreateCart(userId);
            Address address = addressService.getAddressById(addressId);
            
            // Get billing address
            Long billingAddressId = (Long) session.getAttribute("checkoutBillingAddressId");
            if (billingAddressId != null) {
                Address billingAddress = addressService.getAddressById(billingAddressId);
                model.addAttribute("billingAddress", billingAddress);
            }
            
            model.addAttribute("cart", cart);
            model.addAttribute("shippingAddress", address);
            
            return "checkout-review";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @GetMapping("/payment")
    public String showPaymentPage(HttpSession session, Model model) {
        try {
            Long userId = getUserId(session);
            Long addressId = (Long) session.getAttribute("checkoutAddressId");
            if (addressId == null) {
                return "redirect:/checkout/shipping";
            }

            @SuppressWarnings("unchecked")
            Map<String, String> billingInfo = (Map<String, String>) session.getAttribute("checkoutBillingInfo");
            if (billingInfo == null) {
                return "redirect:/checkout/billing";
            }

            Cart cart = cartService.getOrCreateCart(userId);
            model.addAttribute("cart", cart);
            model.addAttribute("billingInfo", billingInfo);
            
            return "checkout-payment";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/place-order")
    public String placeOrder(@RequestParam(value = "paymentMethod", required = false, defaultValue = "card") String paymentMethod,
                           HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Long userId = getUserId(session);
            Long addressId = (Long) session.getAttribute("checkoutAddressId");
            Long billingAddressId = (Long) session.getAttribute("checkoutBillingAddressId");
            
            if (addressId == null) {
                return "redirect:/checkout/shipping";
            }
            
            // Default billing to shipping if not set (fallback)
            if (billingAddressId == null) {
                billingAddressId = addressId;
            }

            Order order = orderService.placeOrder(userId, addressId, billingAddressId);
            
            // Clear checkout session attributes
            session.removeAttribute("checkoutAddressId");
            session.removeAttribute("checkoutBillingAddressId");
            session.removeAttribute("checkoutBillingInfo");
            session.removeAttribute("sameAsShipping");
            session.removeAttribute("cart"); 
            
            redirectAttributes.addFlashAttribute("message", "Order placed successfully! Order ID: " + order.getId() + " (Payment Method: " + paymentMethod.toUpperCase() + ")");
            return "redirect:/orders";
        } catch (Exception e) {
             redirectAttributes.addFlashAttribute("error", "Error placing order: " + e.getMessage());
             return "redirect:/checkout/payment";
        }
    }
}
