# Kharid-daari E-Commerce Platform

A full-featured e-commerce web application built with **Spring MVC**, **JSP**, and **MySQL**.

---

## 📋 Table of Contents
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Application URLs](#-application-urls)
- [Security](#-security)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Spring Annotations Overview](#-spring-annotations-overview)
- [Database & JDBC Driver](#-database--jdbc-driver)
- [Enhanced Security Details](#-enhanced-security-details)
- [Application Architecture Flow](#-application-architecture-flow)

---

## 🚀 Features

**Implemented** ✅

### User Authentication & Profile Management
- User Registration with comprehensive validation
  - Email validation (proper domain format, no special char start)
  - Name validation (first & last name, capital letter start, 2-50 chars)
  - Phone validation (exactly 10 digits)
  - Password strength requirements (8+ chars, uppercase, lowercase, digit, special char)
  - Real-time password confirmation matching with visual feedback
- User Login/Logout with session management
- BCrypt password encryption (10 rounds)
- User Profile Management
  - View profile details (name, email, phone, member since)
  - Edit profile (update first name, last name, email, phone)
  - Change password with current password verification
  - Address management (add, edit, delete, set default)
  - Order history with detailed item information and status tracking

### Product Catalog & Shopping
- Product Catalog with images, prices, and stock levels
- Advanced Product Filtering
  - Price ranges (Under $50, $50-$100, $100-$200, Over $200)
  - Availability (All, In Stock, Out of Stock)
- Product Sorting (Name A-Z/Z-A, Price Low-High/High-Low, Stock High-Low)
- Add to Cart with quantity selection and stock validation
- Shopping Cart Management
  - View cart with item details and pricing
  - Update item quantities
  - Remove individual items
  - Clear entire cart
  - Cart count badge in header
  - Database persistence (survives session timeout)

### Additional Features
- Contact Form submission
- Responsive design (mobile, tablet, desktop)
- Home Page with featured products (6 items)

**Planned** 🔜
- Checkout Process
- Payment Gateway Integration
- Order Placement & Tracking
- Admin Dashboard

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

# Run scripts
mysql -u root -p ecommerce < src/main/resources/database.sql
mysql -u root -p ecommerce < src/main/resources/insert_sample_products.sql
mysql -u root -p ecommerce < src/main/resources/update_product_images.sql
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

| Table | Purpose | Status |
|-------|---------|--------|
| users | User accounts | ✅ |
| addresses | Shipping addresses | ✅ |
| products | Product catalog | ✅ |
| contact_messages | Customer inquiries | ✅ |
| carts | Shopping cart | ✅ |
| cart_items | Cart line items | ✅ |
| orders | Order records | ✅ |
| order_items | Order line items | ✅ |
| payments | Payment transactions | 🔜 |

**Relationships:**
```
USERS (1) ──→ (*) ADDRESSES
USERS (1) ──→ (1) CARTS ──→ (*) CART_ITEMS ←── (*) PRODUCTS
USERS (1) ──→ (*) ORDERS ──→ (*) ORDER_ITEMS ←── (*) PRODUCTS
ORDERS (1) ──→ (1) PAYMENTS
```
ORDERS (1) ──→ (1) PAYMENTS
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

| Page | URL | Description |
|------|-----|-------------|
| Home | `/` | Landing page with featured products |
| Products | `/products` | Complete catalog with filtering & sorting |
| Cart | `/cart` | Shopping cart management |
| Profile | `/profile` | User profile with tabs |
| Profile Details | `/profile#details` | View account information |
| Edit Profile | `/profile#edit` | Update name, email, phone |
| Change Password | `/profile#password` | Change account password |
| Addresses | `/profile/addresses` | Manage shipping addresses |
| Order History | `/profile/orders` | View past orders |
| Login | `/login` | User authentication |
| Register | `/register` | New user signup |
| Contact | `/contact` | Contact form |
| About | `/about` | Company info |
| Logout | `/logout` | End session |

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
2. Test Profile Details tab:
   - View name, email, phone, member since date
3. Test Edit Profile tab:
   - Update first name: Jane
   - Update last name: Smith
   - Update email: jane@example.com
   - Update phone: 9876543210
   - Submit → Verify success message
4. Test Change Password tab:
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
   - Check "Set as default"
4. Submit → Verify address card displayed with "Default" badge
5. Add another address → Click "Set Default"
6. Edit address → Update details → Verify changes
7. Delete non-default address → Confirm deletion
8. Verify: `SELECT * FROM addresses WHERE user_id = <id>;`

### Scenario 7: Order History
1. Go to Order History tab
2. View orders (if any exist in database)
3. Verify order details: ID, date, status, items, pricing

### Scenario 8: Contact Form
1. Go to `/contact`, submit form
2. Verify: `SELECT * FROM contact_messages ORDER BY created_at DESC LIMIT 1;`

### Scenario 9: Session & Logout
1. Login → Navigate pages → Logout
2. Verify session cleared
3. Try accessing `/profile` → Redirect to login

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
2. Validation → `UserService.register()`
3. Password hash → `UserRepository.save()`
4. SQL INSERT with `PreparedStatement`
5. Retrieve generated ID → Return complete User object

**Key Components:**
- **Controllers:** 5 (Home, Auth, Contact, Cart, Profile)
- **Services:** 6 (User, Product, Contact, Cart, Address, Order)
- **Repositories:** 7 (User, Product, Contact, Cart, CartItem, Address, Order)
- **Models:** 8 (User, Product, ContactMessage, Cart, CartItem, Address, Order, OrderItem)
- **Views:** 13 JSP pages (home, products, cart, profile, addresses, orders, login, register, contact, about, + header/footer includes)

---

**Version:** 1.0-SNAPSHOT  
**Last Updated:** January 14, 2026  
**License:** Educational/Evaluation purposes
