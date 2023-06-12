drop database if exists alldeez;
create schema alldeez;
use alldeez;


create table users (
    userid INT NOT NULL AUTO_INCREMENT,
    Username VARCHAR(255) NOT NULL unique,
    email VARCHAR(255),
    pass VARCHAR(255) NOT NULL,
    fullname VARCHAR(40) NOT NULL,
    useraddress VARCHAR(255) NOT NULL,
    Phonenumber VARCHAR(255) NOT NULL,
    PRIMARY KEY (userid)
);

create table delivery_persons(
    deliveryid INT NOT NULL AUTO_INCREMENT,
    deliveryname VARCHAR(255),
    Phonenumber VARCHAR(255) NOT NULL,
    PRIMARY KEY (deliveryid)
);


create table sellers (
    sellerid INT NOT NULL AUTO_INCREMENT,
    Username VARCHAR(255) NOT NULL unique,
    pass VARCHAR(255) NOT NULL,
    sellername VARCHAR(255) NOT NULL,
    Phonenumber VARCHAR(255) NOT NULL unique,
    PRIMARY KEY (sellerid)
);

create table categories (
    categoryid INT NOT NULL AUTO_INCREMENT,
    categoryname VARCHAR(255) NOT NULL unique,
    PRIMARY KEY (categoryid)
);

create table products (
    productid INT NOT NULL AUTO_INCREMENT,
    categoryid INT NOT NULL,
    sellerid INT NOT NULL,
    productname VARCHAR(255) NOT NULL,
    Price INT NOT NULL,
    productdesc VARCHAR(255) NOT NULL,
    PRIMARY KEY (productid),
    FOREIGN KEY (categoryid) REFERENCES categories(categoryid) on DELETE CASCADE,
    FOREIGN KEY (sellerid) REFERENCES sellers(sellerid) on DELETE CASCADE
);

create table carts (
    cartid INT NOT NULL AUTO_INCREMENT,
    productid INT NOT NULL,
    orderid INT NOT NULL,
    PRIMARY KEY (cartid),
    FOREIGN KEY (productid) REFERENCES products(productid) on DELETE CASCADE
);


create table orders (
    orderid INT NOT NULL AUTO_INCREMENT,
    userid INT NOT NULL,
    haspaid INT NOT NULL DEFAULT 0,
    delivererid INT,
    PRIMARY KEY (orderid),
    FOREIGN KEY (userid) REFERENCES users(userid) on DELETE CASCADE,
    FOREIGN KEY (delivererid) REFERENCES delivery_persons(deliveryid) on DELETE CASCADE,
    CHECK (haspaid IN (0,1))
);

create table carts (
    cartid INT NOT NULL AUTO_INCREMENT,
    productid INT NOT NULL,
    orderid INT NOT NULL,
    PRIMARY KEY (cartid),
    FOREIGN KEY (productid) REFERENCES products(productid) on DELETE CASCADE,
    FOREIGN KEY (orderid) REFERENCES orders(orderid) on DELETE CASCADE
);




create table reviews (
    reviewid INT NOT NULL AUTO_INCREMENT,
    productid INT NOT NULL,
    userid INT NOT NULL,
    Rating INT,
    PRIMARY KEY (reviewid),
    FOREIGN KEY (productid) REFERENCES products(productid) on DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid) on DELETE CASCADE,
    CHECK (Rating IN (1,2,3,4,5))
);

create table prod_returns(
    returnid INT NOT NULL AUTO_INCREMENT,
    productid INT NOT NULL,
    userid INT NOT NULL,
    returnstatus VARCHAR(255),
    PRIMARY KEY (returnid),
    FOREIGN KEY (productid) REFERENCES products(productid) on DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid) on DELETE CASCADE,
    CHECK (returnstatus IN ('pending','accepted','rejected'))
);

create table customer_care(
    id INT NOT NULL AUTO_INCREMENT,
    carename VARCHAR(255),
    Phonenumber VARCHAR(255),
    PRIMARY KEY (id)
);


create table customer_queries(
    queryid INT NOT NULL AUTO_INCREMENT,
    userid INT NOT NULL,
    careid INT,
    Query VARCHAR(1024),
    PRIMARY KEY (queryid),
    FOREIGN KEY (careid) REFERENCES customer_care(id) on DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid) on DELETE CASCADE
);