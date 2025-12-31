package com.ecommerce.controller;

import com.ecommerce.model.Product;
import com.ecommerce.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @GetMapping("/")
    public String home(Model model) {
        // Get featured products for home page
        List<Product> featuredProducts = productService.getFeaturedProducts(6);
        model.addAttribute("products", featuredProducts);
        return "home";
    }

    @GetMapping("/products")
    public String products(Model model) {
        List<Product> allProducts = productService.getAllProducts();
        model.addAttribute("products", allProducts);
        return "products";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }
}
