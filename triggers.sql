-- Create trigger to delete cart items of user when user places an order

CREATE TRIGGER delete_cart_itemsv2 AFTER DELETE ON orders
FOR EACH ROW
    DELETE FROM carts
    WHERE orderid = OLD.orderid;


CREATE TRIGGER delete_seller_products AFTER DELETE ON sellers
FOR EACH ROW
    DELETE FROM products
    WHERE sellerid = OLD.sellerid;