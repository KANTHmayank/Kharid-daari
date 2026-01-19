package com.ecommerce.controller;
 
import com.ecommerce.model.Product;
import com.ecommerce.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.ecommerce.model.Cart;
import com.ecommerce.model.CartItem;
import com.ecommerce.service.CartService;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CartService cartService;

    @GetMapping("/")
    public String home(Model model) {
        // Get featured products for home page
        List<Product> featuredProducts = productService.getFeaturedProducts(6);
        model.addAttribute("products", featuredProducts);
        return "home";
    }

    @GetMapping("/products")
    public String products(HttpSession session, Model model) {
        List<Product> allProducts = productService.getAllProducts();
        model.addAttribute("products", allProducts);

        Long userId = (Long) session.getAttribute("userId");
        Map<Long, Integer> cartQuantities = new HashMap<>();

        if (userId != null) {
            Cart cart = cartService.getOrCreateCart(userId);
            for (CartItem item : cart.getItems()) {
                cartQuantities.put(item.getProductId(), item.getQuantity());
            }
        }
        model.addAttribute("cartQuantities", cartQuantities);

        return "products";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }
}
