CREATE DATABASE OnlineMarketplace;

USE OnlineMarketplace;

SHOW DATABASES;

CREATE TABLE Sellers (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    seller_id INT,
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (seller_id) REFERENCES Sellers(seller_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert records into Sellers
INSERT INTO Sellers VALUES
(1, 'Aman Store', 'aman@gmail.com', '9876543210'),
(2, 'Tech World', 'tech@gmail.com', '9876543211');

-- Insert records into Customers
INSERT INTO Customers VALUES
(1, 'Rahul', 'rahul@gmail.com', '9876543212', 'Delhi'),
(2, 'Priya', 'priya@gmail.com', '9876543213', 'Gurgaon'),
(3, 'Amit', 'amit@gmail.com', '9876543214', 'Noida');

-- Insert records into Categories
INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');

-- Insert records into Products
INSERT INTO Products VALUES
(1, 'Laptop', 2, 1, 55000, 10),
(2, 'Headphones', 2, 1, 2000, 25),
(3, 'T-Shirt', 1, 2, 800, 40),
(4, 'SQL Book', 1, 3, 500, 30);

-- Insert records into Orders
INSERT INTO Orders VALUES
(1, 1, '2026-01-10'),
(2, 2, '2026-01-15'),
(3, 1, '2026-02-05'),
(4, 3, '2026-02-12');

-- Insert records into Order_Items
INSERT INTO Order_Items VALUES
(1, 1, 1, 1, 55000),
(2, 1, 2, 2, 2000),
(3, 2, 3, 2, 800),
(4, 3, 2, 1, 2000),
(5, 4, 4, 1, 500);

-- Insert records into Reviews
INSERT INTO Reviews VALUES
(1, 1, 1, 5, 'Excellent product'),
(2, 2, 3, 4, 'Good quality'),
(3, 3, 4, 5, 'Very useful book'),
(4, 1, 2, 4, 'Good sound quality');

-- 1.Display inserted records
SELECT * FROM Sellers;
SELECT * FROM Customers;
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
SELECT * FROM Reviews;

-- 2. Retrieve customers from Delhi
SELECT * FROM Customers
WHERE city = 'Delhi';

-- 3. Display products in descending order of price
SELECT * FROM Products
ORDER BY price DESC;

-- 4. Display unique customer cities
SELECT DISTINCT city
FROM Customers;

-- 1. Update the stock quantity of a product
UPDATE Products
SET stock = 15
WHERE product_id = 1;

-- Verify updated record
SELECT * FROM Products
WHERE product_id = 1;

-- 2. Delete an unnecessary review
DELETE FROM Reviews
WHERE review_id = 4;

-- Verify remaining records
SELECT * FROM Reviews;



-- 1. INNER JOIN: Display customers and their orders
SELECT
    Customers.customer_id,
    Customers.customer_name,
    Orders.order_id,
    Orders.order_date
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id;

-- 2. LEFT JOIN: Display all customers and their orders
SELECT
    Customers.customer_id,
    Customers.customer_name,
    Orders.order_id,
    Orders.order_date
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id;

-- 3. INNER JOIN: Display product names with seller names
SELECT
    Products.product_id,
    Products.product_name,
    Sellers.seller_name,
    Products.price
FROM Products
INNER JOIN Sellers
ON Products.seller_id = Sellers.seller_id;

-- 4. INNER JOIN: Display order details with product names
SELECT
    Orders.order_id,
    Orders.order_date,
    Products.product_name,
    Order_Items.quantity,
    Order_Items.price
FROM Orders
INNER JOIN Order_Items
ON Orders.order_id = Order_Items.order_id
INNER JOIN Products
ON Order_Items.product_id = Products.product_id;


-- Create composite index on Orders table
CREATE INDEX idx_customer_date
ON Orders (customer_id, order_date);

-- Create composite index on Products table
CREATE INDEX idx_category_price
ON Products (category_id, price);

-- Display indexes of Orders table
SHOW INDEX FROM Orders;

-- Display indexes of Products table
SHOW INDEX FROM Products;

-- Add description column if it does not already exist
ALTER TABLE Products
ADD COLUMN description TEXT;

-- Create FULLTEXT index on product name and description
ALTER TABLE Products
ADD FULLTEXT INDEX ft_product_search
(product_name, description);

-- Search products using FULLTEXT search
SELECT *
FROM Products
WHERE MATCH(product_name, description)
AGAINST ('laptop' IN NATURAL LANGUAGE MODE);

-- Display indexes of Products table
SHOW INDEX FROM Products;


-- 1. Examine query performance before indexing
EXPLAIN
SELECT *
FROM Orders
WHERE customer_id = 1
AND order_date >= '2026-01-01';

-- 2. Examine query performance after indexing
EXPLAIN
SELECT *
FROM Orders
WHERE customer_id = 1
AND order_date >= '2026-01-01';

-- 3. Check the structure of Orders table
DESCRIBE Orders;

-- 4. Add status column only if it does not already exist
ALTER TABLE Orders
ADD COLUMN status VARCHAR(30);

-- 5. Create an index on the status column
CREATE INDEX idx_order_status
ON Orders(status);

-- 6. Examine query performance using status index
EXPLAIN
SELECT *
FROM Orders
WHERE status = 'Delivered';

-- 7. Display indexes
SHOW INDEX FROM Orders;

-- 1. Analyse monthly sales trends
SELECT
    DATE_FORMAT(Orders.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT Orders.order_id) AS total_orders,
    SUM(Order_Items.quantity * Order_Items.price) AS total_revenue
FROM Orders
INNER JOIN Order_Items
ON Orders.order_id = Order_Items.order_id
GROUP BY DATE_FORMAT(Orders.order_date, '%Y-%m')
ORDER BY sales_month;

-- 2. Calculate total number of orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM Orders;

-- 3. Calculate total marketplace revenue
SELECT
    SUM(quantity * price) AS total_revenue
FROM Order_Items;


-- 1. Identify top-selling products based on quantity sold
SELECT
    Products.product_id,
    Products.product_name,
    SUM(Order_Items.quantity) AS total_quantity_sold
FROM Products
INNER JOIN Order_Items
ON Products.product_id = Order_Items.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY total_quantity_sold DESC;

-- 2. Identify top-selling products based on revenue generated
SELECT
    Products.product_id,
    Products.product_name,
    SUM(Order_Items.quantity * Order_Items.price) AS total_revenue
FROM Products
INNER JOIN Order_Items
ON Products.product_id = Order_Items.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY total_revenue DESC;


-- 1. Calculate average rating of each product
SELECT
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS average_rating
FROM Products
INNER JOIN Reviews
ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, Products.product_name;

-- 2. Display total reviews and average rating
SELECT
    Products.product_name,
    COUNT(Reviews.review_id) AS total_reviews,
    AVG(Reviews.rating) AS average_rating
FROM Products
INNER JOIN Reviews
ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY average_rating DESC;

CREATE OR REPLACE VIEW seller_performance AS
SELECT
    s.seller_id,
    s.seller_name,
    COALESCE(ss.total_sales, 0) AS total_sales,
    COALESCE(sr.average_rating, 0) AS average_rating,
    COALESCE(ss.return_rate, 0) AS return_rate
FROM Sellers s

LEFT JOIN (
    SELECT
        p.seller_id,
        SUM(oi.quantity * oi.price) AS total_sales,
        CASE
            WHEN COUNT(DISTINCT o.order_id) = 0 THEN 0
            ELSE
                COUNT(DISTINCT CASE
                    WHEN o.status = 'Returned' THEN o.order_id
                END) * 100.0 / COUNT(DISTINCT o.order_id)
        END AS return_rate
    FROM Products p
    INNER JOIN Order_Items oi
        ON p.product_id = oi.product_id
    INNER JOIN Orders o
        ON oi.order_id = o.order_id
    GROUP BY p.seller_id
) ss
    ON s.seller_id = ss.seller_id

LEFT JOIN (
    SELECT
        p.seller_id,
        AVG(r.rating) AS average_rating
    FROM Products p
    INNER JOIN Reviews r
        ON p.product_id = r.product_id
    GROUP BY p.seller_id
) sr
    ON s.seller_id = sr.seller_id;

-- Display seller performance
SELECT * FROM seller_performance;

-- Create Customer Lifetime Value View
CREATE OR REPLACE VIEW customer_lifetime_value AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity * oi.price), 0) AS lifetime_value
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
LEFT JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name;

-- Display Customer Lifetime Value
SELECT * FROM customer_lifetime_value
ORDER BY lifetime_value DESC;

-- 1. Create a summary table to store monthly sales information
CREATE TABLE marketplace_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_month VARCHAR(7),
    total_orders INT,
    total_quantity_sold INT,
    total_revenue DECIMAL(12,2)
);

-- 2. Insert pre-calculated sales information
INSERT INTO marketplace_summary
    (sales_month, total_orders, total_quantity_sold, total_revenue)
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM Orders o
INNER JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m');

-- 3. Display summary table records
SELECT * FROM marketplace_summary;

-- 1. Execute the stored procedure to refresh the summary table
CALL refresh_marketplace_summary();

-- 2. Display the updated summary table
SELECT * FROM marketplace_summary
ORDER BY sales_month;

TRUNCATE TABLE marketplace_summary;

-- 1. View: Customer Lifetime Value
SELECT * FROM customer_lifetime_value;

-- 2. Summary Table: Stored Monthly Sales Information
SELECT * FROM marketplace_summary;

-- 3. Compare total revenue from the view-independent source data
SELECT
    SUM(quantity * price) AS total_revenue
FROM Order_Items;

-- 4. Compare stored revenue in the summary table
SELECT
    SUM(total_revenue) AS summary_revenue
FROM marketplace_summary;

-- Rank products based on revenue within each category
SELECT *
FROM (
    SELECT
        Categories.category_name,
        Products.product_id,
        Products.product_name,
        SUM(Order_Items.quantity * Order_Items.price) AS total_revenue,
        RANK() OVER (
            PARTITION BY Products.category_id
            ORDER BY SUM(Order_Items.quantity * Order_Items.price) DESC
        ) AS product_rank
    FROM Products
    INNER JOIN Categories
        ON Products.category_id = Categories.category_id
    INNER JOIN Order_Items
        ON Products.product_id = Order_Items.product_id
    GROUP BY
        Categories.category_name,
        Products.category_id,
        Products.product_id,
        Products.product_name
) AS ranked_products
WHERE product_rank <= 3
ORDER BY category_name, product_rank;

USE OnlineMarketplace;

-- Calculate monthly revenue and compare it with the previous month
SELECT
    sales_month,
    total_revenue,
    LAG(total_revenue) OVER (
        ORDER BY sales_month
    ) AS previous_month_revenue,

    total_revenue - LAG(total_revenue) OVER (
        ORDER BY sales_month
    ) AS revenue_change,

    ROUND(
        (
            (total_revenue - LAG(total_revenue) OVER (
                ORDER BY sales_month
            )) * 100.0
        ) / NULLIF(
            LAG(total_revenue) OVER (
                ORDER BY sales_month
            ), 0
        ),
        2
    ) AS growth_percentage

FROM (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.price) AS total_revenue
    FROM Orders o
    INNER JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
) AS monthly_sales
ORDER BY sales_month;

USE OnlineMarketplace;

-- Calculate monthly revenue and three-month moving average
SELECT
    sales_month,
    monthly_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.price) AS monthly_revenue
    FROM Orders o
    INNER JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
) AS monthly_sales
ORDER BY sales_month;

USE OnlineMarketplace;

-- Identify the first purchase date of each customer
SELECT
    customer_id,
    order_id,
    order_date,
    MIN(order_date) OVER (
        PARTITION BY customer_id
    ) AS first_purchase_date
FROM Orders
ORDER BY customer_id, order_date;

-- Group customers by their first purchase month
SELECT DISTINCT
    customer_id,
    first_purchase_date,
    DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month
FROM (
    SELECT
        customer_id,
        MIN(order_date) OVER (
            PARTITION BY customer_id
        ) AS first_purchase_date
    FROM Orders
) AS customer_cohorts
ORDER BY customer_id;

USE OnlineMarketplace;

-- Calculate total spending of each customer
SELECT
    customer_id,
    customer_name,
    total_spending,
    NTILE(4) OVER (
        ORDER BY total_spending DESC
    ) AS spending_quartile
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(oi.quantity * oi.price), 0) AS total_spending
    FROM Customers c
    LEFT JOIN Orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_spending
ORDER BY spending_quartile, total_spending DESC;