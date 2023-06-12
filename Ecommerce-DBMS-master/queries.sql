-- Retrieve all the products with their respective categories:

SELECT p.productname, c.categoryname 
FROM products p
INNER JOIN categories c
ON p.categoryid = c.categoryid;


-- Retrieve the email and password of user whose name is ‘pdrummondj’:

SELECT email, pass
FROM users
WHERE username = 'lburles2q';


-- Retrieving all the orders place by a specific user that have not been assigned a delivery person:

SELECT * 
FROM orders 
WHERE userid = (
    SELECT userid 
    FROM users 
    WHERE Username = 'lburles2q'
) 
AND delivererid IS NULL;
-- Retrieve products sorted by their average rating:

SELECT p.productid, p.productname, AVG(r.Rating) as avg_rating,COUNT(r.reviewid) as num_reviews
FROM products p
LEFT JOIN reviews r ON p.productid = r.productid
GROUP BY p.productid
ORDER BY avg_rating DESC;

-- Retrieve the list of customers who have not placed any orders yet:

SELECT u.username
FROM users u
EXCEPT
(
    SELECT u.username
    FROM users u
    JOIN orders o ON u.userid = o.userid
);


-- Retrieve the total price of an order:

SELECT SUM(p.Price)
FROM products p
JOIN carts c ON p.productid = c.productid
JOIN orders o ON c.orderid = o.orderid
WHERE o.orderid = 11;


-- Retrieving all the products in a specific category along with their prices and ratings, but only if the average rating is 3 or greater

SELECT p.productid, p.productname, p.Price, AVG(r.Rating) as avg_rating
FROM products p
JOIN reviews r ON p.productid = r.productid
WHERE p.categoryid = 1
GROUP BY p.productid
HAVING AVG(r.Rating) >= 3;

-- Calculate total value of products sold by a seller:
SELECT s.sellerid, s.sellername, SUM(p.Price) AS total_value_sold
FROM sellers s
JOIN products p ON s.sellerid = p.sellerid
JOIN carts c ON p.productid = c.productid
JOIN orders o ON c.orderid = o.orderid
WHERE o.haspaid = 1
GROUP BY s.sellerid;


-- Updating the price of a product in products table:


UPDATE products
SET Price = 50.0
WHERE productid = 1;

-- Removing a product from the products table:
DELETE FROM products
WHERE productid = 1;

-- Adding a new product to an order:
INSERT INTO carts (productid, orderid) VALUES (2, 1);


-- Getting products within a price range:
SELECT p.productid, p.productname, p.Price
FROM products p
WHERE p.Price BETWEEN 100 AND 10000;

