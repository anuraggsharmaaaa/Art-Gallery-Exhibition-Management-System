#  Enterprise Art Gallery & Exhibition Management System (AGMS)

> A full-stack, multi-tenant ERP solution for managing distributed art gallery inventories, exhibitions, and financial analytics.

##  Project Overview

This project goes beyond a simple e-commerce store. It is an architectural demonstration of a **Database-First** enterprise application. It manages the complex operations of a multi-national gallery chain (New York, London, Paris), handling inventory logistics, staff management, and secure transactional sales.

The core logic is decoupled from the application layer and enforced directly within **MySQL** using ACID-compliant Stored Procedures, Triggers, and Scheduled Events, ensuring data integrity and high performance.

---

##  Key Features & DBMS "Flexes"

### 1. Advanced Database Architecture
* **Multi-Tenant Schema:** Managing distinct inventory and staff across multiple `Gallery` locations while maintaining a centralized `Artworks` catalog.
* **M:N Relationships:** Complex bridging between `Exhibitions` and `Inventory` (Items), allowing artworks to be curated into specific time-bound events.
* **Database Views:** Pre-joined `VIEW`s (`v_sales_dashboard_details`) abstract complex joins for the admin dashboard, improving read performance and security.
* **Full-Text Search:** Implemented MySQL `FULLTEXT` indexes for high-performance, relevance-based artwork searching (replacing slow `LIKE` queries).

### 2. Transactional Business Logic (ACID)
* **Atomic Sales:** The `sp_BuyArtwork` stored procedure wraps the sale process in a transaction. It locks the inventory row (`FOR UPDATE`), calculates the gallery/artist commission split, inserts the sale record, and updates inventory status. If any step fails, the entire transaction rolls back.
* **Automated Auditing:** Database `TRIGGER`s automatically log every sale and deletion to an immutable `AuditLog` table.

### 3. Database Automation
* **MySQL Event Scheduler:** A native database cron job (`e_NightlySalesReport`) runs every night at 1:00 AM to calculate daily revenue and sales volume, archiving it into a report table without user intervention.

### 4. Secure Full-Stack Application
* **Role-Based Access Control (RBAC):**
    * **Customers:** Can browse, search, and purchase tickets/art.
    * **Admins:** Are strictly bound to their assigned Gallery location. An admin for "New York" cannot see or manage "London" financial data.
* **Visual Analytics:** An admin dashboard featuring Chart.js visualizations derived from SQL aggregation queries.

---

##  Tech Stack

* **Database:** MySQL 8.0+
* **Backend:** Python (Flask)
* **Frontend:** HTML5, CSS3 ("Museum Dark" Theme), JavaScript
* **Authentication:** Flask-Login + Werkzeug Security (Password Hashing)
* **Visualization:** Chart.js

---

##  Installation & Setup

### 1. Clone the Repository
```bash
git clone [https://github.com/anuraggsharmaaaa/Art-Gallery-Exhibition-Management-System.git](https://github.com/anuraggsharmaaaa/Art-Gallery-Exhibition-Management-System.git)
cd Art-Gallery-Exhibition-Management-System


Role,Email,Password,Scope
Admin (NY),admin-ny@gallery.com,password123,Manages New York Data Only
Admin (London),admin-london@gallery.com,password123,Manages London Data Only
Admin (Paris),admin-paris@gallery.com,password123,Manages Paris Data Only
Customer,customer@gallery.com,password123,Can Buy Art & Tickets