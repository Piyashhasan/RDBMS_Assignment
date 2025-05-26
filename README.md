<!-- Banner (replace with your image if available) -->
<p align="center">
  <img src="https://w7.pngwing.com/pngs/386/991/png-transparent-postgresql-logo-landscape-tech-companies.png" alt="Banner" width="100%" />
</p>

<h1 align="center">PostgreSQL</h1>

> ✅ **Author**: [Piyash Hasan](https://github.com/piyashhasan)  
> 📝 **Topic**: PostgreSQL </br>
> 📅 **Published**: 26 May 2025

# PostgreSQL Complete Guide 🐘

A comprehensive guide to PostgreSQL fundamentals with practical examples you can copy and run.

## Table of Contents

- [What is PostgreSQL?](#what-is-postgresql)
- [Database Schema](#database-schema)
- [Primary Key and Foreign Key](#primary-key-and-foreign-key)
- [Data Types: VARCHAR vs CHAR](#data-types-varchar-vs-char)
- [WHERE Clause](#where-clause)
- [LIMIT and OFFSET](#limit-and-offset)
- [UPDATE Statements](#update-statements)
- [JOIN Operations](#join-operations)
- [GROUP BY Clause](#group-by-clause)
- [Aggregate Functions](#aggregate-functions)

## What is PostgreSQL?

PostgreSQL is a powerful, open-source object-relational database system with over 35 years of active development. It's known for its reliability, feature robustness, and performance.

**Key Features:**

- ACID compliance
- Advanced data types (JSON, Arrays, UUID)
- Full-text search
- Extensibility
- Cross-platform support

## Database Schema

A database schema is a logical structure that defines how data is organized in a database. It includes tables, columns, data types, relationships, and constraints.

### Creating a Schema Example

```sql
-- Create a new schema
CREATE SCHEMA company;

-- Create tables within the schema
CREATE TABLE company.departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(10,2)
);

CREATE TABLE company.employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES company.departments(id),
    salary DECIMAL(10,2)
);

-- List all schemas
\dn

-- Set search path to use schema
SET search_path TO company, public;
```

## Primary Key and Foreign Key

### Primary Key

A primary key uniquely identifies each record in a table. It cannot be NULL and must be unique.

### Foreign Key

A foreign key creates a link between two tables and ensures referential integrity.

```sql
-- Create departments table with Primary Key
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- Create employees table with Foreign Key
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    dept_id INTEGER,
    hire_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Insert sample data
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'San Francisco'),
    ('Marketing', 'New York'),
    ('Sales', 'Chicago');

INSERT INTO employees (first_name, last_name, email, dept_id) VALUES
    ('John', 'Doe', 'john.doe@company.com', 1),
    ('Jane', 'Smith', 'jane.smith@company.com', 2),
    ('Mike', 'Johnson', 'mike.johnson@company.com', 1);
```

## Data Types: VARCHAR vs CHAR

### VARCHAR

- Variable-length character string
- Storage efficient
- Recommended for most use cases

### CHAR

- Fixed-length character string
- Pads with spaces if shorter
- Faster for fixed-length data

```sql
-- Create table demonstrating VARCHAR vs CHAR
CREATE TABLE data_types_demo (
    id SERIAL PRIMARY KEY,
    varchar_field VARCHAR(10),
    char_field CHAR(10),
    text_field TEXT
);

-- Insert sample data
INSERT INTO data_types_demo (varchar_field, char_field, text_field) VALUES
    ('Hello', 'Hello', 'This is a long text field that can store unlimited characters'),
    ('Hi', 'Hi', 'Short text'),
    ('PostgreSQL', 'PostgreSQL', 'Another example of text storage');

-- Check actual storage
SELECT
    varchar_field,
    LENGTH(varchar_field) as varchar_length,
    char_field,
    LENGTH(char_field) as char_length,
    CHAR_LENGTH(char_field) as char_char_length
FROM data_types_demo;
```

## WHERE Clause

The WHERE clause filters records based on specified conditions.

```sql
-- Create products table for examples
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INTEGER,
    created_date DATE DEFAULT CURRENT_DATE
);

-- Insert sample data
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
    ('Laptop Pro', 'Electronics', 1299.99, 15),
    ('Office Chair', 'Furniture', 299.50, 8),
    ('Smartphone', 'Electronics', 699.99, 25),
    ('Desk Lamp', 'Furniture', 89.99, 12),
    ('Tablet', 'Electronics', 399.99, 20),
    ('Bookshelf', 'Furniture', 199.99, 5);

-- WHERE clause examples
-- Basic condition
SELECT * FROM products WHERE category = 'Electronics';

-- Multiple conditions with AND
SELECT * FROM products WHERE category = 'Electronics' AND price < 800;

-- Multiple conditions with OR
SELECT * FROM products WHERE category = 'Furniture' OR stock_quantity < 10;

-- Range condition
SELECT * FROM products WHERE price BETWEEN 200 AND 700;

-- Pattern matching
SELECT * FROM products WHERE product_name LIKE '%Pro%';

-- IN clause
SELECT * FROM products WHERE category IN ('Electronics', 'Furniture');

-- NULL check
SELECT * FROM products WHERE created_date IS NOT NULL;
```

## LIMIT and OFFSET

LIMIT restricts the number of rows returned, while OFFSET skips a specified number of rows (useful for pagination).

```sql
-- LIMIT examples
-- Get first 3 products
SELECT * FROM products LIMIT 3;

-- Get products ordered by price (ascending)
SELECT * FROM products ORDER BY price LIMIT 5;

-- OFFSET examples (pagination)
-- Get first page (items 1-3)
SELECT * FROM products ORDER BY product_id LIMIT 3 OFFSET 0;

-- Get second page (items 4-6)
SELECT * FROM products ORDER BY product_id LIMIT 3 OFFSET 3;

-- Get third page (items 7-9)
SELECT * FROM products ORDER BY product_id LIMIT 3 OFFSET 6;

-- Common pagination pattern
-- Page 1: OFFSET 0, LIMIT 3
-- Page 2: OFFSET 3, LIMIT 3
-- Page 3: OFFSET 6, LIMIT 3
-- Formula: OFFSET = (page_number - 1) * items_per_page

-- Get most expensive products
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 2;
```

## UPDATE Statements

UPDATE statements modify existing data in tables.

```sql
-- Basic UPDATE
UPDATE products
SET price = 1199.99
WHERE product_name = 'Laptop Pro';

-- UPDATE multiple columns
UPDATE products
SET price = 649.99, stock_quantity = 30
WHERE product_name = 'Smartphone';

-- UPDATE with calculation
UPDATE products
SET price = price * 0.9
WHERE category = 'Furniture';

-- UPDATE with subquery
UPDATE products
SET stock_quantity = stock_quantity + 5
WHERE price < (SELECT AVG(price) FROM products);

-- Conditional UPDATE with CASE
UPDATE products
SET stock_quantity = CASE
    WHEN stock_quantity < 10 THEN stock_quantity + 10
    WHEN stock_quantity BETWEEN 10 AND 20 THEN stock_quantity + 5
    ELSE stock_quantity + 2
END;

-- UPDATE with RETURNING (see what was changed)
UPDATE products
SET price = price * 1.1
WHERE category = 'Electronics'
RETURNING product_name, price;

-- Verify changes
SELECT * FROM products ORDER BY product_id;
```

## JOIN Operations

JOINs combine rows from two or more tables based on related columns.

```sql
-- Ensure we have our tables with data
-- (departments and employees from earlier examples)

-- INNER JOIN - Returns matching records from both tables
SELECT
    e.first_name,
    e.last_name,
    d.dept_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN - Returns all records from left table
SELECT
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- RIGHT JOIN - Returns all records from right table
SELECT
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- FULL OUTER JOIN - Returns all records when there's a match in either table
SELECT
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- Multiple JOINs example
-- Create projects table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    emp_id INTEGER REFERENCES employees(emp_id),
    start_date DATE,
    budget DECIMAL(10,2)
);

INSERT INTO projects (project_name, emp_id, start_date, budget) VALUES
    ('Website Redesign', 1, '2024-01-15', 50000),
    ('Mobile App', 1, '2024-02-01', 75000),
    ('Marketing Campaign', 2, '2024-01-20', 25000);

-- Three-table JOIN
SELECT
    e.first_name,
    e.last_name,
    d.dept_name,
    p.project_name,
    p.budget
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON e.emp_id = p.emp_id;
```

## GROUP BY Clause

GROUP BY groups rows that have the same values in specified columns and allows aggregate functions.

```sql
-- Basic GROUP BY
SELECT
    category,
    COUNT(*) as product_count
FROM products
GROUP BY category;

-- GROUP BY with multiple aggregate functions
SELECT
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price,
    SUM(stock_quantity) as total_stock
FROM products
GROUP BY category;

-- GROUP BY with HAVING (filter groups)
SELECT
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY category
HAVING COUNT(*) >= 2;

-- GROUP BY with JOINs
SELECT
    d.dept_name,
    COUNT(e.emp_id) as employee_count,
    COUNT(p.project_id) as project_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON e.emp_id = p.emp_id
GROUP BY d.dept_id, d.dept_name;

-- GROUP BY with ORDER BY
SELECT
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;
```

## Aggregate Functions

Aggregate functions perform calculations on a set of rows and return a single value.

```sql
-- Basic aggregate functions
SELECT
    COUNT(*) as total_products,
    COUNT(DISTINCT category) as unique_categories,
    SUM(price) as total_value,
    AVG(price) as average_price,
    MIN(price) as cheapest_price,
    MAX(price) as most_expensive_price,
    SUM(stock_quantity) as total_inventory
FROM products;

-- Aggregate functions with conditions
SELECT
    COUNT(*) as electronics_count,
    AVG(price) as avg_electronics_price,
    SUM(stock_quantity) as electronics_inventory
FROM products
WHERE category = 'Electronics';

-- String aggregation
SELECT
    category,
    STRING_AGG(product_name, ', ') as product_list
FROM products
GROUP BY category;

-- Advanced aggregations
SELECT
    category,
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as avg_price,
    ROUND(STDDEV(price), 2) as price_std_dev,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) as median_price
FROM products
GROUP BY category;

-- Window functions (advanced aggregation)
SELECT
    product_name,
    category,
    price,
    AVG(price) OVER (PARTITION BY category) as category_avg_price,
    price - AVG(price) OVER (PARTITION BY category) as price_difference,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as price_rank
FROM products;

-- Conditional aggregation
SELECT
    COUNT(*) as total_products,
    COUNT(CASE WHEN price > 500 THEN 1 END) as expensive_products,
    COUNT(CASE WHEN stock_quantity < 10 THEN 1 END) as low_stock_products,
    AVG(CASE WHEN category = 'Electronics' THEN price END) as avg_electronics_price
FROM products;
```

## Quick Reference Commands

```sql
-- Database operations
CREATE DATABASE my_database;
DROP DATABASE my_database;
\l                          -- List databases
\c database_name            -- Connect to database

-- Table operations
\dt                         -- List tables
\d table_name              -- Describe table structure
DROP TABLE table_name;      -- Delete table

-- User operations
CREATE USER username WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;

-- Backup and restore
pg_dump database_name > backup.sql
psql database_name < backup.sql
```

## Best Practices

1. **Always use transactions for multiple related operations**

```sql
BEGIN;
INSERT INTO departments (dept_name, location) VALUES ('HR', 'Boston');
INSERT INTO employees (first_name, last_name, dept_id) VALUES ('Alice', 'Wilson', currval('departments_dept_id_seq'));
COMMIT;
```

2. **Use indexes for frequently queried columns**

```sql
CREATE INDEX idx_employees_dept_id ON employees(dept_id);
CREATE INDEX idx_products_category ON products(category);
```

3. **Use EXPLAIN to analyze query performance**

```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';
```

## Running the Examples

1. Copy any SQL block
2. Connect to your PostgreSQL database
3. Paste and execute the commands
4. All examples are self-contained and runnable

## Contributing

Feel free to submit issues and enhancement requests!
