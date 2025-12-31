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

---

## 🚀 Features

**Implemented** ✅
- Home Page with featured products (6 items)
- User Registration with BCrypt encryption
- User Login/Logout with session management
- Product Catalog with images, prices, and stock
- Contact Form submission
- Responsive design (mobile, tablet, desktop)

**Planned** 🔜
- Shopping Cart, Checkout, Payment Gateway
- User Profile & Order History
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
Ecom/
├── src/main/
│   ├── java/com/ecommerce/
│   │   ├── config/           # Spring configuration
│   │   ├── controller/       # HTTP handlers (Home, Auth, Contact)
│   │   ├── service/          # Business logic
│   │   ├── repository/       # Data access (CRUD)
│   │   └── model/            # Entities (User, Product, ContactMessage)
│   ├── resources/            # SQL scripts
│   └── webapp/WEB-INF/
│       ├── views/            # JSP templates
│       └── css/              # Stylesheets
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
| carts, cart_items | Shopping cart | 🔜 |
| orders, order_items | Order records | 🔜 |
| payments | Payment transactions | 🔜 |

**Relationships:**
```
USERS (1) ──→ (*) ADDRESSES
USERS (1) ──→ (1) CARTS ──→ (*) CART_ITEMS ←── (*) PRODUCTS
USERS (1) ──→ (*) ORDERS ──→ (*) ORDER_ITEMS ←── (*) PRODUCTS
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
| Products | `/products` | Complete catalog |
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

### Scenario 1: Registration
1. Go to `/register`
2. Fill: Name, Email (john@example.com), Phone, Password
3. Submit → Success message on login page
4. Verify: `SELECT * FROM users WHERE email = 'john@example.com';`

### Scenario 2: Login
1. Go to `/login`
2. Enter: john@example.com / password
3. Submit → Redirect to home, header shows "Hello, John"

### Scenario 3: Browse Products
1. Click "Products" → View all 6 products

### Scenario 4: Contact Form
1. Go to `/contact`, submit form
2. Verify: `SELECT * FROM contact_messages ORDER BY created_at DESC LIMIT 1;`

### Scenario 5: Session & Logout
1. Login → Navigate pages → Logout
2. Verify session cleared

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

## 📚 Additional Info

**Architecture Diagrams:**
- `01_usecase.puml` - Use cases
- `02_class.mmd` - Classes
- `03_sequence_add_to_cart.mmd` - Add to cart flow
- `04_sequence_checkout.mmd` - Checkout flow
- `05_erd.mmd` - Entity relationships

**Development Commands:**
```powershell
mvn clean package      # Build
mvn cargo:run          # Run
mvn test               # Test
```

**Database Queries:**
```sql
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM contact_messages;
```

---

**Version:** 1.0-SNAPSHOT  
**Last Updated:** December 31, 2025  
**License:** Educational/Evaluation purposes
