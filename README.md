# Kharid-daari E-Commerce Platform

A full-featured e-commerce web application built with **Spring MVC**, **JSP**, and **MySQL**. Kharid-daari (खरीद-दारी) means "shopping" in Hindi, reflecting the platform's purpose as a comprehensive online shopping solution.

---

## 📋 Table of Contents
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Application URLs](#-application-urls)
- [Checkout Flow](#-checkout-flow)
- [Security](#-security)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Spring Annotations Overview](#-spring-annotations-overview)
- [Database & JDBC Driver](#-database--jdbc-driver)
- [Enhanced Security Details](#-enhanced-security-details)
- [Application Architecture Flow](#-application-architecture-flow)
- [Future Scope](#-future-scope)

---

## 🚀 Features

**Implemented** ✅

### User Authentication & Profile Management
- **User Registration** with comprehensive validation
  - Email validation (proper domain format, no special char start)
  - Name validation (first & last name, capital letter start, 2-50 chars)
  - Phone validation (exactly 10 digits)
  - **Date of Birth** field for user profile enrichment
  - Password strength requirements (8+ chars, uppercase, lowercase, digit, special char)
  - Real-time password confirmation matching with visual feedback
- **User Login/Logout** with session management
- **BCrypt password encryption** (10 rounds)
- **User Profile Management**
  - View profile details (name, email, phone, date of birth, member since)
  - Edit profile (update first name, last name, email, phone)
  - Change password with current password verification
  - Recovery email management
  - Address management (add, edit, delete, set default)
  - Order history with detailed item information and status tracking

### Product Catalog & Shopping
- **Product Catalog** with images, prices, and stock levels
- **Advanced Product Filtering**
  - Price ranges (Under $50, $50-$100, $100-$200, Over $200)
  - Availability (All, In Stock, Out of Stock)
- **Product Sorting** (Name A-Z/Z-A, Price Low-High/High-Low, Stock High-Low)
- **Add to Cart** with quantity selection and stock validation
- **Shopping Cart Management**
  - View cart with item details and pricing
  - Update item quantities with real-time subtotal calculation
  - Remove individual items
  - Clear entire cart
  - Cart count badge in header
  - Database persistence (survives session timeout)
  - Empty cart detection with helpful messaging

### Checkout & Order Management
- **Multi-Step Checkout Process**
  - **Shipping Address Selection**: Choose from saved addresses or add new address during checkout
  - **Contact Information**: Primary mobile (auto-populated from registration), optional alternate contact
  - **Billing Address**: Use same as shipping or select different address
  - **Payment Method Selection**: Credit/Debit Card, Net Banking, UPI, Cash on Delivery
  - **Order Review**: Review all details before placing order
- **Order Placement**
  - Order creation with unique order IDs
  - Order items tracking
  - Cart clearing after successful order
  - Order confirmation page with order summary
- **Order History**
  - View all past orders
  - Order status tracking (Pending, Processing, Shipped, Delivered, Cancelled)
  - Detailed order items with product information
  - Order date and total amount display

### Additional Features
- **About Page** with company information
- **Contact Form** submission with database storage
- **Responsive Design** (mobile, tablet, desktop)
- **Home Page** with featured products (6 items)
- **Session Management** with user-friendly redirects
- **Error Handling** with informative messages

### Architecture & Design
- **UML Diagrams** for system design
  - Use Case Diagram (`01_usecase.puml`)
  - Class Diagram (`02_class.mmd`)
  - Sequence Diagrams for Add to Cart and Checkout flows
  - Entity-Relationship Diagram (`05_erd.mmd`)
- **MVC Architecture** with clear separation of concerns
- **RESTful URL patterns**
- **JDBC Template** for database operations
- **Prepared Statements** for SQL injection prevention

---

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Backend | Spring MVC | 5.3.27 |
| Language | Java | 11+ |
| Database | MySQL | 8.0 |
| View | JSP/JSTL | - |
| Frontend | HTML5, CSS3, JS | - |
| Build | Maven | 3.6+ |
| Security | BCrypt | 0.4 |
| Server | Tomcat | 9.x |

---

## ⚡ Quick Start

### Prerequisites

```powershell
# Verify installations
java -version          # JDK 11+
mvn -version           # Maven 3.6+
mysql --version        # MySQL 8.0
Get-Service MySQL80    # MySQL running
```

### Setup Steps

**1. Configure Database**

Edit `src/main/java/com/ecommerce/config/AppConfig.java`:
```java
dataSource.setPassword("your_mysql_password");  // Update this
```

**2. Initialize Database**

```powershell
# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ecommerce;"

# Run main schema
mysql -u root -p ecommerce < src/main/resources/database.sql

# Add sample products
mysql -u root -p ecommerce < src/main/resources/insert_sample_products.sql

# Update product images
mysql -u root -p ecommerce < src/main/resources/update_product_images.sql

# Add DOB field to users table (if upgrading)
mysql -u root -p ecommerce < src/main/resources/database_update_dob.sql
```

**3. Build & Run**

```powershell
# Build
mvn clean package

# Run (Option 1 - Recommended)
mvn cargo:run
# Access: http://localhost:8080/

# Run (Option 2 - Manual Tomcat)
Copy-Item target\ecommerce.war "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\"
cd "C:\Program Files\Apache Software Foundation\Tomcat 9.0\bin"
.\startup.bat
# Access: http://localhost:8080/ecommerce/
```

---

## 📁 Project Structure

```
Kharid-daari/
├── src/main/
│   ├── java/com/ecommerce/
│   │   ├── config/           # Spring configuration
│   │   │   ├── AppConfig.java
│   │   │   └── WebAppInitializer.java
│   │   ├── controller/       # HTTP handlers
│   │   │   ├── HomeController.java
│   │   │   ├── AuthController.java
│   │   │   ├── ContactController.java
│   │   │   ├── CartController.java
│   │   │   └── ProfileController.java
│   │   ├── service/          # Business logic
│   │   │   ├── UserService.java
│   │   │   ├── ProductService.java
│   │   │   ├── ContactService.java
│   │   │   ├── CartService.java
│   │   │   ├── AddressService.java
│   │   │   └── OrderService.java
│   │   ├── repository/       # Data access (CRUD)
│   │   │   ├── UserRepository.java
│   │   │   ├── ProductRepository.java
│   │   │   ├── ContactMessageRepository.java
│   │   │   ├── CartRepository.java
│   │   │   ├── CartItemRepository.java
│   │   │   ├── AddressRepository.java
│   │   │   └── OrderRepository.java
│   │   └── model/            # Entities
│   │       ├── User.java
│   │       ├── Product.java
│   │       ├── ContactMessage.java
│   │       ├── Cart.java
│   │       ├── CartItem.java
│   │       ├── Address.java
│   │       ├── Order.java
│   │       └── OrderItem.java
│   ├── resources/            # SQL scripts
│   │   └── database.sql
│   └── webapp/WEB-INF/
│       ├── views/            # JSP templates
│       │   ├── home.jsp
│       │   ├── products.jsp
│       │   ├── login.jsp
│       │   ├── register.jsp
│       │   ├── cart.jsp
│       │   ├── profile.jsp
│       │   ├── addresses.jsp
│       │   ├── orders.jsp
│       │   ├── contact.jsp
│       │   ├── about.jsp
│       │   └── includes/
│       │       ├── header.jsp
│       │       └── footer.jsp
│       └── css/              # Stylesheets
│           └── style.css
├── target/
│   └── ecommerce.war         # Deployable WAR
├── pom.xml                   # Maven config
├── *.puml, *.mmd            # Architecture diagrams
└── README.md
```

---

## 💾 Database Schema

**Database:** `ecommerce` (9 tables)

| Table | Purpose | Fields | Status |
|-------|---------|--------|--------|
| users | User accounts | id, name, email, recovery_email, password_hash, phone, **dob**, created_at, updated_at | ✅ |
| addresses | Shipping addresses | id, user_id, line1, line2, city, state, postal_code, country, is_default, recipient_name, recipient_phone | ✅ |
| products | Product catalog | id, sku, name, description, price, stock, image_url, active, created_at | ✅ |
| contact_messages | Customer inquiries | id, name, email, message, submitted_at | ✅ |
| carts | Shopping cart | id, user_id, created_at, updated_at | ✅ |
| cart_items | Cart line items | id, cart_id, product_id, quantity, added_at | ✅ |
| orders | Order records | id, user_id, order_number, total_amount, status, shipping_address_id, billing_address_id, primary_mobile, alternate_mobile, alternate_contact_name, payment_method, created_at | ✅ |
| order_items | Order line items | id, order_id, product_id, quantity, price_at_time, subtotal | ✅ |
| payments | Payment transactions | id, order_id, amount, payment_method, transaction_id, status, payment_date | ✅ |

**Key Relationships:**
```
USERS (1) ──→ (*) ADDRESSES
USERS (1) ──→ (1) CARTS ──→ (*) CART_ITEMS ←── (*) PRODUCTS
USERS (1) ──→ (*) ORDERS ──→ (*) ORDER_ITEMS ←── (*) PRODUCTS
ORDERS (1) ──→ (1) PAYMENTS (planned)
ORDERS (*) ──→ (1) ADDRESSES (shipping & billing)
```

**Sample Products:**
- PROD-001: Wireless Headphones - $129.99
- PROD-002: Smart Watch - $199.99
- PROD-003: Laptop Backpack - $49.99
- PROD-004: Bluetooth Speaker - $79.99
- PROD-005: Mechanical Keyboard - $89.99
- PROD-006: Wireless Mouse - $29.99

---

## 🌐 Application URLs

| Page | URL | Description | Auth Required |
|------|-----|-------------|---------------|
| Home | `/` | Landing page with featured products | No |
| Products | `/products` | Complete catalog with filtering & sorting | No |
| Cart | `/cart` | Shopping cart management | Yes |
| Profile | `/profile` | User profile with tabs | Yes |
| Profile Details | `/profile#details` | View account information | Yes |
| Edit Profile | `/profile#edit` | Update name, email, phone | Yes |
| Change Password | `/profile#password` | Change account password | Yes |
| Addresses | `/profile/addresses` | Manage shipping addresses | Yes |
| Order History | `/profile/orders` | View past orders | Yes |
| Checkout Start | `/checkout` | Start checkout process | Yes |
| Checkout Shipping | `/checkout/shipping` | Select shipping address & contact | Yes |
| Checkout Billing | `/checkout/billing` | Select billing address | Yes |
| Checkout Payment | `/checkout/payment` | Select payment method | Yes |
| Checkout Review | `/checkout/review` | Review order before placement | Yes |
| Place Order | `/checkout/place-order` | Complete order | Yes |
| Order Success | `/checkout/order-success` | Order confirmation page | Yes |
| Login | `/login` | User authentication | No |
| Register | `/register` | New user signup | No |
| Contact | `/contact` | Contact form | No |
| About | `/about` | Company information | No |
| Logout | `/logout` | End session | Yes |

---

## 🛒 Checkout Flow

The platform implements a comprehensive 5-step checkout process:

### Step 1: Checkout Initiation (`/checkout`)
- Validates user authentication
- Checks cart is not empty
- Redirects to shipping page

### Step 2: Shipping Address & Contact (`/checkout/shipping`)
- Select from existing addresses or add new address
- Primary mobile number (auto-populated from user registration)
- Optional alternate contact details (name and mobile)
- Address details stored in session

### Step 3: Billing Address (`/checkout/billing`)
- Option to use same as shipping address
- Or select different billing address
- Cart summary display with item details and totals
- Billing information stored in session

### Step 4: Payment Method (`/checkout/payment`)
- **Payment Options:**
  - Credit/Debit Card
  - Net Banking
  - UPI
  - Cash on Delivery (COD)
- Order summary review
- Total amount display

### Step 5: Order Review & Placement (`/checkout/place-order`)
- Final order review
- Order creation with unique order number (format: ORD-YYYYMMDD-XXXX)
- Order items saved to database
- Cart cleared after successful order
- Redirect to order success page

### Order Confirmation (`/checkout/order-success`)
- Display order confirmation
- Order details summary
- Order number for tracking
- Link to order history

---

## 🔐 Security

**Features:**
- ✅ BCrypt password hashing (10 rounds)
- ✅ Session-based authentication
- ✅ SQL injection prevention (JdbcTemplate)
- ✅ Input validation

**Password Example:**
```java
// Registration
String hash = BCrypt.hashpw(password, BCrypt.gensalt());

// Login
boolean valid = BCrypt.checkpw(entered, storedHash);
```

**Architecture (MVC):**
```
Browser → Controllers → Services → Repositories → MySQL
           ↓
        JSP Views
```

---

## 🧪 Testing

### Scenario 1: User Registration
1. Go to `/register`
2. Fill form:
   - First Name: John (must start with capital, 2-50 chars)
   - Last Name: Doe (must start with capital, 2-50 chars)
   - Email: john@example.com (valid email format)
   - **Date of Birth**: Select date from calendar picker
   - Phone: 1234567890 (exactly 10 digits)
   - Password: Test@123 (8+ chars, uppercase, lowercase, digit, special char)
   - Confirm Password: Test@123 (real-time matching indicator)
3. Submit → Success message on login page
4. Verify: `SELECT * FROM users WHERE email = 'john@example.com';`

### Scenario 2: User Login
1. Go to `/login`
2. Enter: john@example.com / Test@123
3. Submit → Redirect to home, header shows "Hello, John Doe"
4. Verify cart icon appears in header

### Scenario 3: Browse & Filter Products
1. Click "Products" → View all 6 products
2. Apply filters:
   - Price range: $50-$100
   - Availability: In Stock
3. Sort by: Price Low to High
4. Verify filtered results displayed

### Scenario 4: Shopping Cart
1. On products page, select quantity (e.g., 2)
2. Click "Add to Cart" → See success notification
3. Observe cart count badge update in header
4. Click cart icon → View cart with items
5. Update quantity → Verify subtotal recalculates
6. Remove item → Verify cart updates
7. Verify: `SELECT * FROM carts WHERE user_id = <id>;`
8. Verify: `SELECT * FROM cart_items WHERE cart_id = <cart_id>;`

### Scenario 5: User Profile Management
1. Click "My Profile" in header
2. **Test Profile Details tab:**
   - View name, email, phone, **date of birth**, member since date
3. **Test Edit Profile tab:**
   - Update first name: Jane
   - Update last name: Smith
   - Update email: jane@example.com
   - Update recovery email: recovery@example.com
   - Update phone: 9876543210
   - Submit → Verify success message
4. **Test Change Password tab:**
   - Enter current password
   - Enter new password: NewTest@456
   - Confirm new password (watch real-time matching)
   - Submit → Verify success message

### Scenario 6: Address Management
1. Go to Addresses tab
2. Click "+ Add New Address"
3. Fill modal form:
   - Address Line 1: 123 Main Street
   - Address Line 2: Apt 4B (optional)
   - City: New York
   - State: NY (optional)
   - Postal Code: 10001 (optional)
   - Country: USA
   - Recipient Name: John Doe
   - Recipient Phone: 1234567890
   - Check "Set as default"
4. Submit → Verify address card displayed with "Default" badge
5. Add another address → Click "Set Default"
6. Edit address → Update details → Verify changes
7. Delete non-default address → Confirm deletion
8. Verify: `SELECT * FROM addresses WHERE user_id = <id>;`

### Scenario 7: Complete Checkout Process
1. **Add items to cart** (minimum 1 product)
2. Click cart icon → Click "Proceed to Checkout"
3. **Shipping Page:**
   - Select shipping address (or add new address)
   - Verify primary mobile auto-populated
   - Optionally add alternate contact details
   - Click "Continue to Billing"
4. **Billing Page:**
   - Option 1: Check "Same as shipping address"
   - Option 2: Select different billing address
   - Review cart summary
   - Click "Continue to Payment"
5. **Payment Page:**
   - Select payment method (COD, Credit Card, UPI, Net Banking)
   - Review order summary with total amount
   - Click "Review Order"
6. **Place Order:**
   - Final review of all details
   - Click "Place Order"
   - Redirect to order success page
7. **Order Confirmation:**
   - Note order number (format: ORD-YYYYMMDD-XXXX)
   - Verify order details displayed
8. **Verify Database:**
   ```sql
   SELECT * FROM orders WHERE user_id = <id> ORDER BY created_at DESC LIMIT 1;
   SELECT * FROM order_items WHERE order_id = <order_id>;
   SELECT * FROM carts WHERE user_id = <id>; -- Should have no items
   ```

### Scenario 8: Order History
1. Go to Order History tab in profile
2. View all placed orders
3. Verify order details: 
   - Order number
   - Order date
   - Order status (Pending, Processing, Shipped, Delivered, Cancelled)
   - Items with product names, quantities, and prices
   - Total amount

### Scenario 9: Contact Form
1. Go to `/contact`
2. Fill form with name, email, and message
3. Submit form
4. Verify success message
5. Verify: `SELECT * FROM contact_messages ORDER BY submitted_at DESC LIMIT 1;`

### Scenario 10: Session & Logout
1. Login → Navigate pages → Logout
2. Verify session cleared
3. Try accessing `/profile` → Redirect to login
4. Try accessing `/checkout` → Redirect to login

---

## 🐛 Troubleshooting

### Port 8080 in use
```powershell
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Database connection error
```powershell
Get-Service MySQL80        # Check status
Start-Service MySQL80      # Start if stopped
mysql -u root -p -e "SHOW DATABASES;"
```

### Maven build fails
```powershell
mvn clean install -U       # Force update
mvn clean package -DskipTests   # Skip tests
mvn clean package -X       # Verbose output
```

### WAR not deploying
```powershell
ls target\ecommerce.war    # Verify file exists
Get-Content "C:\Program Files\Apache Software Foundation\Tomcat 9.0\logs\catalina.*.log" -Tail 50
```

### 404 errors
- Check context path: `/ecommerce/` vs `/`
- Verify `pom.xml` → `<path>/</path>`
- Clear browser cache (Ctrl+Shift+Delete)

### Login fails
```sql
-- Verify password hash length (~60 chars)
SELECT email, LENGTH(password_hash) FROM users;
```

---

## 🔧 Spring Annotations Overview

**Configuration Layer:**
- `@Configuration` - Defines Spring configuration class
- `@EnableWebMvc` - Enables Spring MVC features
- `@ComponentScan` - Scans for Spring components
- `@Bean` - Defines managed beans (DataSource, JdbcTemplate, ViewResolver)

**Web Layer:**
- `@Controller` - Marks MVC controllers
- `@RequestMapping` - Maps HTTP requests to methods
- `@RequestParam` - Binds request parameters
- `@ModelAttribute` - Binds objects from form data

**Service Layer:**
- `@Service` - Marks business logic classes

**Data Layer:**
- `@Repository` - Marks data access classes
- `@Autowired` - Injects dependencies

**All layers use `@Override` for interface implementations.**

---

## 🗄️ Database & JDBC Driver

**JDBC Driver:** MySQL Connector/J 8.0.33 (`com.mysql.cj.jdbc.Driver`)
- Type 4 pure Java driver for MySQL communication
- Translates JDBC calls to MySQL protocol over TCP/IP
- Handles connection pooling, prepared statements, and result sets

**Connection URL:** `jdbc:mysql://localhost:3306/ecommerce?useSSL=false&serverTimezone=UTC`

**Why PreparedStatement over Statement:**
- **Security:** Prevents SQL injection attacks
- **Performance:** Precompiled queries with cached execution plans
- **Type Safety:** Automatic data type handling and character escaping
- **Required for:** Auto-generated key retrieval (`RETURN_GENERATED_KEYS`)

---

## 🔐 Enhanced Security Details

**Password Security:**
- BCrypt hashing with adaptive cost factor (10 rounds)
- Protects against rainbow table attacks
- Industry-standard for password storage

**SQL Injection Prevention:**
```java
// SECURE: Parameterized queries
String sql = "SELECT * FROM users WHERE email = ?";
jdbcTemplate.queryForObject(sql, USER_ROW_MAPPER, email);

// VULNERABLE: String concatenation
String sql = "SELECT * FROM users WHERE email = '" + email + "'"; // NEVER DO THIS
```

**Session Management:**
- Server-side session storage
- Automatic cleanup on logout
- User data stored: ID, name, email

---

## 📊 Application Architecture Flow

**Request Processing:**
```
Browser → DispatcherServlet → Controller → Service → Repository → MySQL
         ↓
    ViewResolver → JSP → Response
```

**Data Flow (User Registration):**
1. Form submission → `AuthController.register()`
2. Validation (name, email, phone, password, DOB format)
3. `UserService.register()` - password hashing
4. `UserRepository.save()` - database insertion
5. SQL INSERT with `PreparedStatement` including DOB field
6. Retrieve generated ID → Return complete User object

**Key Components:**
- **Controllers:** 6
  - HomeController (landing page, products)
  - AuthController (login, register, logout)
  - ContactController (contact form)
  - CartController (add, update, remove, clear cart)
  - ProfileController (profile, addresses, orders, password change)
  - CheckoutController (shipping, billing, payment, order placement)
  
- **Services:** 7
  - UserService (authentication, profile management)
  - ProductService (product catalog, filtering, sorting)
  - ContactService (contact message handling)
  - CartService (cart operations, persistence)
  - AddressService (address CRUD operations)
  - OrderService (order creation, retrieval, status management)
  - PaymentService (payment processing - planned)
  
- **Repositories:** 8
  - UserRepository
  - ProductRepository
  - ContactMessageRepository
  - CartRepository
  - CartItemRepository
  - AddressRepository
  - OrderRepository
  - PaymentRepository (planned)
  
- **Models:** 9
  - User (with DOB field)
  - Product
  - ContactMessage
  - Cart
  - CartItem
  - Address
  - Order
  - OrderItem
  - Payment
  
- **Views:** 16 JSP pages
  - Public: home, products, about, contact, login, register
  - Protected: cart, profile, addresses, orders
  - Checkout: checkout-shipping, checkout-billing, checkout-payment, checkout-review, order-success
  - Includes: header, footer

**Session Management:**
- User authentication state (userId, userName, userEmail)
- Shopping cart persistence
- Checkout flow data (shipping address, billing address, contact info, payment method)

---

## 🚀 Future Scope

### Phase 1: Enhanced User Experience (High Priority)
1. **Email Notifications**
   - Order confirmation emails
   - Password reset emails
   - Shipping updates

2. **Product Reviews & Ratings**
   - User reviews on products
   - Star rating system
   - Review moderation

3. **Wishlist Feature**
   - Save products for later
   - Move items between cart and wishlist
   - Share wishlist

4. **Search Functionality**
   - Product search by name/description
   - Auto-complete suggestions
   - Search filters

### Phase 2: Business Intelligence (Medium Priority)
5. **Admin Dashboard**
   - Sales analytics and reports
   - Product inventory management
   - User management
   - Order management (update status, cancel orders)
   - Revenue tracking

6. **Order Tracking**
   - Real-time order status updates
   - Shipment tracking integration
   - Estimated delivery dates
   - Order cancellation requests

7. **Advanced Analytics**
   - Customer purchase patterns
   - Popular products tracking
   - Revenue by product category
   - Cart abandonment tracking

### Phase 3: Payment & Security (High Priority)
8. **Payment Gateway Integration**
   - Actual payment processing (currently mock)
   - Integration with Razorpay/Stripe/PayPal
   - Payment failure handling and retry
   - Refund processing

9. **Enhanced Security**
   - Two-factor authentication (2FA)
   - CAPTCHA on login/registration
   - Rate limiting for API endpoints
   - Session timeout warnings

10. **Password Recovery**
    - Forgot password functionality using recovery email
    - Secure token-based reset links
    - Password history tracking

### Phase 4: Advanced Features (Low Priority)
11. **Multi-vendor Support**
    - Vendor registration and management
    - Separate vendor dashboards
    - Commission management

12. **Loyalty Program**
    - Points on purchases
    - Referral rewards
    - Tier-based benefits

13. **Social Features**
    - Social login (Google, Facebook)
    - Share products on social media
    - Social proof (X people bought this)

14. **Mobile App**
    - Native Android/iOS apps
    - Push notifications
    - Mobile-specific features

15. **Internationalization**
    - Multi-language support
    - Multi-currency support
    - Region-specific pricing

### Phase 5: Performance & Scalability
16. **Caching Layer**
    - Redis for session management
    - Product catalog caching
    - Frequently accessed data caching

17. **API Development**
    - RESTful API for mobile apps
    - API documentation (Swagger)
    - Rate limiting and authentication

18. **Microservices Architecture**
    - Decompose monolith into microservices
    - User service, Order service, Product service
    - Event-driven architecture

19. **CDN Integration**
    - Product images on CDN
    - Static assets optimization
    - Global content delivery

### Technical Improvements
20. **Testing Suite**
    - Unit tests (JUnit)
    - Integration tests
    - Selenium for UI testing
    - Code coverage reports

21. **CI/CD Pipeline**
    - Automated builds
    - Automated deployments
    - Environment management (dev, staging, prod)

22. **Logging & Monitoring**
    - Centralized logging (ELK stack)
    - Application performance monitoring
    - Error tracking (Sentry)
    - Uptime monitoring

23. **Database Optimization**
    - Query optimization
    - Indexing strategy
    - Connection pooling
    - Database sharding for scalability



---

**Version:** 2.0-SNAPSHOT  
**Last Updated:** January 27, 2026  
**Author:** Cognizant Technical Training  
**License:** Educational/Evaluation purposes

**Key Achievements:**
- ✅ Complete user authentication and authorization system
- ✅ Full-featured shopping cart with database persistence
- ✅ Multi-step checkout process with order placement
- ✅ Comprehensive user profile management
- ✅ Address management system
- ✅ Order history and tracking
- ✅ Responsive design for all screen sizes
- ✅ Secure password handling with BCrypt
- ✅ SQL injection prevention with prepared statements
- ✅ Session-based state management

**Technologies Demonstrated:**
- Spring MVC 5.3.27
- JDBC Template for database operations
- JSP/JSTL for server-side rendering
- MySQL 8.0 for data persistence
- BCrypt for password encryption
- Maven for build management
- Tomcat 9.x for application server

**Repository Structure:**
- `/src` - Application source code
- `/target` - Compiled artifacts and WAR file
- `/*.puml` - PlantUML use case diagrams
- `/*.mmd` - Mermaid class and sequence diagrams
- `/README.md` - This documentation
