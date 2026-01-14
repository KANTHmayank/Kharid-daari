package com.ecommerce.controller;

import com.ecommerce.model.Cart;
import com.ecommerce.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    private Long getUserId(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            throw new RuntimeException("User not logged in");
        }
        return userId;
    }

    @PostMapping("/add")
    @ResponseBody
    public String addToCart(@RequestParam("productId") Long productId,
                          @RequestParam("quantity") Integer quantity,
                          HttpSession session) {
        try {
            Long userId = getUserId(session);
            cartService.addToCart(userId, productId, quantity);
            int itemCount = cartService.getCartItemCount(userId);
            
            return "{\"success\": true, \"message\": \"Added to cart\", \"itemCount\": " + itemCount + "}";
        } catch (RuntimeException e) {
            return "{\"success\": false, \"message\": \"" + e.getMessage() + "\"}";
        } catch (Exception e) {
            return "{\"success\": false, \"message\": \"Error adding to cart. Please login first.\"}";
        }
    }

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        try {
            Long userId = getUserId(session);
            Cart cart = cartService.getOrCreateCart(userId);
            model.addAttribute("cart", cart);
            session.setAttribute("cart", cart); // Update session cart
        } catch (Exception e) {
            model.addAttribute("error", "Please login to view your cart");
            return "redirect:/login";
        }
        return "cart";
    }

    @PostMapping("/remove")
    public String removeFromCart(@RequestParam("productId") Long productId, HttpSession session) {
        try {
            Long userId = getUserId(session);
            cartService.removeFromCart(userId, productId);
        } catch (Exception e) {
            // Handle error
        }
        return "redirect:/cart";
    }

    @PostMapping("/update")
    public String updateQuantity(@RequestParam("productId") Long productId,
                                @RequestParam("quantity") Integer quantity,
                                HttpSession session) {
        try {
            Long userId = getUserId(session);
            cartService.updateQuantity(userId, productId, quantity);
        } catch (Exception e) {
            // Handle error
        }
        return "redirect:/cart";
    }

    @PostMapping("/clear")
    public String clearCart(HttpSession session) {
        try {
            Long userId = getUserId(session);
            cartService.clearCart(userId);
        } catch (Exception e) {
            // Handle error
        }
        return "redirect:/cart";
    }
}
