package com.ecommerce.controller;

import com.ecommerce.model.Address;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Order;
import com.ecommerce.model.User;
import com.ecommerce.service.AddressService;
import com.ecommerce.service.CartService;
import com.ecommerce.service.OrderService;
import com.ecommerce.service.UserService;
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

    @Autowired
    private UserService userService;

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
            
            // Fetch user's registered phone number
            User user = userService.findById(userId);
            String userPhone = user.getPhone();
            
            // Use phone from session if available, otherwise use user's registered phone
            String primaryMobile = (String) session.getAttribute("primaryMobile");
            if (primaryMobile == null && userPhone != null) {
                primaryMobile = userPhone;
            }
            
            String alternateMobile = (String) session.getAttribute("alternateMobile");
            String alternateContactName = (String) session.getAttribute("alternateContactName");
            
            if (primaryMobile != null) {
                model.addAttribute("primaryMobile", primaryMobile);
            }
            if (alternateMobile != null) {
                model.addAttribute("alternateMobile", alternateMobile);
            }
            if (alternateContactName != null) {
                model.addAttribute("alternateContactName", alternateContactName);
            }
            
            return "checkout-shipping";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/shipping")
    public String processShipping(@RequestParam("addressId") Long addressId,
                                 @RequestParam("primaryMobile") String primaryMobile,
                                 @RequestParam(value = "alternateMobile", required = false) String alternateMobile,
                                 @RequestParam(value = "alternateContactName", required = false) String alternateContactName,
                                 HttpSession session) {
        session.setAttribute("checkoutAddressId", addressId);
        session.setAttribute("primaryMobile", primaryMobile);
        
        if (alternateMobile != null && !alternateMobile.trim().isEmpty()) {
            session.setAttribute("alternateMobile", alternateMobile);
            session.setAttribute("alternateContactName", alternateContactName);
        } else {
            session.removeAttribute("alternateMobile");
            session.removeAttribute("alternateContactName");
        }
        
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
    public String processBilling(@RequestParam(value = "sameAsShipping", required = false) boolean sameAsShipping,
                               @RequestParam(value = "addressId", required = false) Long addressId,
                               @RequestParam(value = "gstNumber", required = false) String gstNumber,
                               @RequestParam(value = "companyName", required = false) String companyName,
                               @RequestParam(value = "invoiceEmail", required = false) String invoiceEmail,
                               @RequestParam(value = "navigation", required = false, defaultValue = "next") String navigation,
                               HttpSession session) {
        
        Map<String, String> billingInfo = new HashMap<>();
        
        // Save GST and company info if provided
        if (gstNumber != null && !gstNumber.trim().isEmpty()) {
            billingInfo.put("gstNumber", gstNumber.trim());
        }
        if (companyName != null && !companyName.trim().isEmpty()) {
            billingInfo.put("companyName", companyName.trim());
        }
        if (invoiceEmail != null && !invoiceEmail.trim().isEmpty()) {
            billingInfo.put("invoiceEmail", invoiceEmail.trim());
        }
        
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
        
        return "redirect:/checkout/payment";
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
                billingInfo = new HashMap<>();
            }

            Cart cart = cartService.getOrCreateCart(userId);
            model.addAttribute("cart", cart);
            model.addAttribute("billingInfo", billingInfo);
            
            return "checkout-payment";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @GetMapping("/order-success")
    public String showOrderSuccess(HttpSession session, Model model) {
        // Retrieve order details from session
        Long orderId = (Long) session.getAttribute("lastOrderId");
        String paymentMethod = (String) session.getAttribute("lastPaymentMethod");
        
        if (orderId != null) {
            model.addAttribute("orderId", orderId);
        }
        if (paymentMethod != null) {
            model.addAttribute("paymentMethod", paymentMethod);
        }
        
        // Clear session attributes after displaying
        session.removeAttribute("lastOrderId");
        session.removeAttribute("lastPaymentMethod");
        
        return "order-success";
    }

    @PostMapping("/place-order")
    public String placeOrder(@RequestParam(value = "paymentMethod", required = false, defaultValue = "card") String paymentMethod,
                           @RequestParam(value = "cardNumber", required = false) String cardNumber,
                           @RequestParam(value = "cardName", required = false) String cardName,
                           @RequestParam(value = "expiryDate", required = false) String expiryDate,
                           @RequestParam(value = "cvv", required = false) String cvv,
                           @RequestParam(value = "upiId", required = false) String upiId,
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

            // Store payment details in session
            @SuppressWarnings("unchecked")
            Map<String, String> billingInfo = (Map<String, String>) session.getAttribute("checkoutBillingInfo");
            if (billingInfo == null) {
                billingInfo = new HashMap<>();
            }
            
            // Add payment method specific details
            billingInfo.put("paymentMethod", paymentMethod);
            if ("card".equals(paymentMethod) && cardNumber != null) {
                billingInfo.put("cardNumber", cardNumber);
                billingInfo.put("cardName", cardName);
                billingInfo.put("expiryDate", expiryDate);
                billingInfo.put("cvv", cvv);
            } else if ("upi".equals(paymentMethod) && upiId != null && !upiId.trim().isEmpty()) {
                billingInfo.put("upiId", upiId);
            }
            
            session.setAttribute("checkoutBillingInfo", billingInfo);

            // Update address with recipient details if ordering for someone else
            String alternateMobile = (String) session.getAttribute("alternateMobile");
            String alternateContactName = (String) session.getAttribute("alternateContactName");
            String primaryMobile = (String) session.getAttribute("primaryMobile");
            
            // Update shipping address with recipient details
            Address shippingAddress = addressService.getAddressById(addressId);
            if (shippingAddress != null) {
                if (alternateMobile != null && !alternateMobile.trim().isEmpty()) {
                    // Ordering for someone else
                    shippingAddress.setRecipientName(alternateContactName);
                    shippingAddress.setRecipientPhone(alternateMobile);
                } else {
                    // Ordering for self - use user's name and primary mobile
                    User user = userService.findById(userId);
                    shippingAddress.setRecipientName(user.getName());
                    shippingAddress.setRecipientPhone(primaryMobile);
                }
                addressService.updateAddress(shippingAddress);
            }

            Order order = orderService.placeOrder(userId, addressId, billingAddressId, billingInfo);
            
            // Store order details for success page
            String paymentMethodDisplay = paymentMethod.equals("card") ? "Card" : 
                                         paymentMethod.equals("upi") ? "UPI" : 
                                         "Cash on Delivery";
            session.setAttribute("lastOrderId", order.getId());
            session.setAttribute("lastPaymentMethod", paymentMethodDisplay);
            
            // Clear checkout session attributes
            session.removeAttribute("checkoutAddressId");
            session.removeAttribute("checkoutBillingAddressId");
            session.removeAttribute("checkoutBillingInfo");
            session.removeAttribute("sameAsShipping");
            session.removeAttribute("primaryMobile");
            session.removeAttribute("alternateMobile");
            session.removeAttribute("alternateContactName");
            session.removeAttribute("cart"); 
            
            return "redirect:/checkout/order-success";
        } catch (Exception e) {
             redirectAttributes.addFlashAttribute("error", "Error placing order: " + e.getMessage());
             return "redirect:/checkout/payment";
        }
    }
}
