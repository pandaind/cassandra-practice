CREATE KEYSPACE IF NOT EXISTS ecommerce WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};
USE ecommerce;

/* Session 1 - Product data model */
/* category table */
CREATE TABLE IF NOT EXISTS category
(
    parent_id
        UUID,
    category_id
        UUID,
    name
        TEXT,
    image
        TEXT,
    products
        LIST<TEXT>,
    PRIMARY
        KEY
        (
        parent_id,
        category_id
        )
);

/* price table */
CREATE TABLE IF NOT EXISTS price
(
    product_id
        TEXT,
    store_id
        TEXT,
    value
        DECIMAL,
    PRIMARY
        KEY
        (
        product_id,
        store_id
        )
);

/* product table */
CREATE TABLE IF NOT EXISTS product
(
    product_id
        TEXT,
    product_group
        TEXT,
    name
        TEXT,
    brand
        TEXT,
    model_number
        TEXT,
    short_desc
        TEXT,
    long_desc
        TEXT,
    specifications
        MAP<TEXT, TEXT>,
    linked_documents
        MAP<TEXT, TEXT>,
    images
        SET<TEXT>,
    PRIMARY
        KEY
        (
        product_id
        )
);

/* featured product groups table */
CREATE TABLE IF NOT EXISTS featured_product_groups
(
    feature_id
        INT,
    category_id
        UUID,
    name
        TEXT,
    image
        TEXT,
    parent_id
        UUID,
    price
        DECIMAL,
    PRIMARY
        KEY
        (
        feature_id,
        category_id
        )
);

/* Session 2 - Shopping Cart data model */
CREATE TABLE IF NOT EXISTS user_carts
(
    user_id
        uuid,
    cart_name
        text,
    cart_id
        uuid,
    cart_is_active
        boolean,
    user_email
        text,
    PRIMARY
        KEY
        (
        user_id,
         cart_name,
         cart_id
        )
) WITH default_time_to_live = 5184000;

CREATE TABLE IF NOT EXISTS cart_products
(
    cart_id
        uuid,
    product_timestamp
        timestamp,
    product_id
        text,
    product_description
        text,
    product_name
        text,
    quantity
        int,
    PRIMARY
        KEY
        (
        cart_id,
         product_timestamp,
         product_id
        )
) WITH CLUSTERING ORDER BY (product_timestamp DESC, product_id ASC)
   AND default_time_to_live = 5184000;

/* Session 3 - User Profile data model */
CREATE TYPE IF NOT EXISTS address (
    type TEXT,
    mailto_name TEXT,
    street TEXT,
    street2 TEXT,
    city TEXT,
    state_province TEXT,
    postal_code TEXT,
    country TEXT
    );

CREATE TABLE IF NOT EXISTS user
(
    user_id
        UUID,
    user_email
        TEXT,
    picture_url
        TEXT,
    first_name
        TEXT,
    last_name
        TEXT,
    locale
        TEXT,
    addresses
        LIST<FROZEN<address>>,
    session_id
        TEXT,
    password
        TEXT,
    password_timestamp
        TIMESTAMP,
    PRIMARY
        KEY
        (
        user_id
        )
);

CREATE TABLE IF NOT EXISTS user_by_email
(
    user_email
        TEXT
        PRIMARY
            KEY,
    user_id
        UUID
);

/* Session 4 - Order Processing System data model */
CREATE TABLE IF NOT EXISTS order_by_id
(
    order_id
        timeuuid,
    product_name
        text,
    product_id
        text,
    order_shipping_handling
        decimal
        static,
    order_status
        text
        static,
    order_subtotal
        decimal
        static,
    order_tax
        decimal
        static,
    order_total
        decimal
        static,
    payment_method
        text
        static,
    product_price
        decimal,
    product_qty
        int,
    shipping_address
        address
        static,
    PRIMARY
        KEY
        (
        order_id,
         product_name,
         product_id
        )
) WITH CLUSTERING ORDER BY (product_name ASC, product_id ASC);

CREATE TABLE IF NOT EXISTS order_by_user
(
    user_id
        uuid,
    order_id
        timeuuid,
    order_status
        text,
    order_total
        decimal,
    PRIMARY
        KEY
        (
        user_id,
        order_id
        )
) WITH CLUSTERING ORDER BY (order_id DESC);

CREATE TABLE IF NOT EXISTS order_status_history
(
    order_id
        timeuuid,
    status_timestamp
        timestamp,
    order_status
        text,
    PRIMARY
        KEY
        (
        order_id,
        status_timestamp
        )
) WITH CLUSTERING ORDER BY (status_timestamp DESC);

INSERT INTO category (name,category_id,image,parent_id) VALUES ('Clothing',18105592-77aa-4469-8556-833b419dacf4,'ls534.png',ffdac25a-0244-4894-bb31-a0884bc82aa9);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Tech Accessories',5929e846-53e8-473e-8525-80b666c46a83,'',ffdac25a-0244-4894-bb31-a0884bc82aa9);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Cups and Mugs',675cf3a2-2752-4de7-ae2e-849471c29f51,'',ffdac25a-0244-4894-bb31-a0884bc82aa9);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Wall Decor',591bf485-de09-4b46-8fd2-5d9dc7ca101e,'bh001.png',ffdac25a-0244-4894-bb31-a0884bc82aa9);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('T-Shirts',91455473-212e-4c6e-8bec-1da06779ae10,'ls534.png',18105592-77aa-4469-8556-833b419dacf4);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Hoodies',6a4d86aa-ceb5-4c6f-b9b9-80e9a8c58ad1,'',18105592-77aa-4469-8556-833b419dacf4);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Jackets',d887b049-d16c-46e1-8c94-0a1280dedc30,'',18105592-77aa-4469-8556-833b419dacf4);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Mousepads',d04dfb5b-69c6-4e97-b572-e9e390165a84,'',5929e846-53e8-473e-8525-80b666c46a83);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Wrist Rests',aa161129-d456-45ba-b1f0-fac7898b6d06,'',5929e846-53e8-473e-8525-80b666c46a83);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Laptop Covers',1c4b8599-78df-4f93-9c52-578bd959a3a5,'',5929e846-53e8-473e-8525-80b666c46a83);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Cups',7536fdef-fcd9-44a3-9360-0bffd2904408,'',675cf3a2-2752-4de7-ae2e-849471c29f51);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Coffee Mugs',20374300-185c-4ee5-b0bc-77fbdc3a21ed,'',675cf3a2-2752-4de7-ae2e-849471c29f51);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Travel Mugs',0660483e-2fad-447b-b19a-63ab4935e482,'',675cf3a2-2752-4de7-ae2e-849471c29f51);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Posters',fdbe9dcb-6878-4216-a64d-27c094b1b075,'',591bf485-de09-4b46-8fd2-5d9dc7ca101e);
INSERT INTO category (name,category_id,image,parent_id) VALUES ('Wall Art',943482f9-070c-4390-bb30-2107b6fe653a,'bh001.png',591bf485-de09-4b46-8fd2-5d9dc7ca101e);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('Men''s "Go Away...Annotation" T-Shirt',99c4d825-d262-4a95-a04e-cc72e7e273c1,'ls534.png',91455473-212e-4c6e-8bec-1da06779ae10,['LS534S','LS534M','LS534L','LS534XL','LS5342XL','LS5343XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('Men''s "Your Face...Autowired" T-Shirt',3fa13eee-d057-48d0-b0ae-2d83af9e3e3e,'ln355.png',91455473-212e-4c6e-8bec-1da06779ae10,['LN355S','LN355M','LN355L','LN355XL','LN3552XL','LN3553XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('Bigheads',2f25a732-0744-406d-baee-3e8131cbe500,'bh001.png',943482f9-070c-4390-bb30-2107b6fe653a,['bh001','bh002','bh003']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('DataStax Gray Track Jacket',f629e107-b219-4563-a852-6909fd246949,'dss821.jpg',d887b049-d16c-46e1-8c94-0a1280dedc30,['DSS821S','DSS821M','DSS821L','DSS821XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('DataStax Vintage 2015 MVP Hoodie',86d234a4-6b97-476c-ada8-efb344d39743,'dsh915.jpg',6a4d86aa-ceb5-4c6f-b9b9-80e9a8c58ad1,['DSH915S','DSH915M','DSH915L','DSH915XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('DataStax Black Hoodie',b9bed3c0-0a76-44ea-bce6-f5f21611a3f1,'dsh916.jpg',6a4d86aa-ceb5-4c6f-b9b9-80e9a8c58ad1,['DSH916S','DSH916M','DSH916L','DSH916XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('Apache Cassandra 3.0 Contributor T-Shirt',95ae4613-0184-46ee-b4b0-adfe882754a8,'apc30a.jpg',91455473-212e-4c6e-8bec-1da06779ae10,['APC30S','APC30M','APC30L','APC30XL','APC302XL','APC303XL']);
INSERT INTO category (name,category_id,image,parent_id,products) VALUES ('DataStax Astra "One Team" Long Sleeve Tee',775be203-1a84-4822-9645-4da98ca2b2d8,'dsa1121.jpg',91455473-212e-4c6e-8bec-1da06779ae10,['DSA1121S','DSA1121M','DSA1121L','DSA1121XL','DSA11212XL','DSA11213XL']);

INSERT INTO price(product_id,store_id,value) VALUES ('LS534S','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LS534M','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LS534L','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LS534XL','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LS5342XL','web',16.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LS5343XL','web',16.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN355S','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN355M','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN355L','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN355XL','web',14.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN3552XL','web',16.99);
INSERT INTO price(product_id,store_id,value) VALUES ('LN3553XL','web',16.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA1121S','web',21.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA1121M','web',21.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA1121L','web',21.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA1121XL','web',21.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA11212XL','web',23.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSA11213XL','web',23.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSS821S','web',44.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSS821M','web',44.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSS821L','web',44.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSS821XL','web',44.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH915S','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH915M','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH915L','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH915XL','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH916S','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH916M','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH916L','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('DSH916XL','web',35.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC30S','web',15.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC30M','web',15.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC30L','web',15.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC30XL','web',15.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC302XL','web',17.99);
INSERT INTO price(product_id,store_id,value) VALUES ('APC303XL','web',17.99);

INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS534S','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s Small "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'Small','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS534M','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s Medium "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'Medium','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS534L','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s Large "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS534XL','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s Extra Large "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'Extra Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS5342XL','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s 2x Large "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'2x Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LS5343XL','LS534','Go Away Annotation T-Shirt','NerdShirts','NS101','Men''s 3x Large "Go Away...Annotation" T-Shirt','Having to answer support questions when you really want to get back to coding?  Wear this to work, and let there be no question as to what you''d rather be doing.',{'size':'3x Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ls534.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN355S','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s Small "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'Small','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN355M','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s Medium "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'Medium','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN355L','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s Large "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN355XL','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s Extra Large "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'Extra Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN3552XL','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s 2x Large "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'2x Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('LN355XL','LN355','Your Face is an @Autowired @Bean T-Shirt','NerdShirts','NS102','Men''s 3x Large "Your Face...Autowired" T-Shirt','Everyone knows that one person who overuses the "your face" jokes.',{'size':'3x Large','material':'cotton, polyester','cut':'men''s','color':'black'},{'ln355.png'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA1121S','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - Small','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'Small','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA1121M','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - Medium','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'Medium','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA1121L','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - Large','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'Large','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA1121XL','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - Extra Large','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'Extra Large','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA11212XL','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - 2X Large','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'2X Large','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSA11213XL','DSA1121','DataStax Astra "One Team" Long Sleeve Tee','DataStax','DSA1121','DataStax Astra "One Team" Long Sleeve Tee - 3X Large','Given out at the internal summit, show how proud you are to talk about the world''s best multi-region, multi-cloud, serverless database!',{'size':'3X Large','material':'cotton, polyester','color':'black'},{'dsa1121.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC30S','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - Small','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'Small','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC30M','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - Medium','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'Medium','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC30L','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - Large','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'Large','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC30XL','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - Extra Large','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'Extra Large','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC302XL','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - 2X Large','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'2X Large','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('APC303XL','APC30','Apache Cassandra 3.0 Contributor T-Shirt','Apache Foundation','APC30','Apache Cassandra 3.0 Contributor T-Shirt - 3X Large','Own a piece of Cassandra history with this Apache Cassandra 3.0 "Contributor" shirt.  Given out to all of the contributors to the project in 2016, shows the unmistakable Cassandra Eye on the front, with the
engine rebuild" on the back.',{'size':'3X Large','material':'cotton, polyester','color':'black'},{'apc30.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSS821S','DSS821','DataStax Gray Track Jacket','DataStax','DSS821','DataStax Gray Track Jacket - Small','This lightweight polyester jacket will be your favorite while hiking the trails or teeing off.',{'size':'Small','material':'polyester','color':'gray'},{'dss821.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSS821M','DSS821','DataStax Gray Track Jacket','DataStax','DSS821','DataStax Gray Track Jacket - Medium','This lightweight polyester jacket will be your favorite while hiking the trails or teeing off.',{'size':'Medium','material':'polyester','color':'gray'},{'dss821.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSS821L','DSS821','DataStax Gray Track Jacket','DataStax','DSS821','DataStax Gray Track Jacket - Large','This lightweight polyester jacket will be your favorite while hiking the trails or teeing off.',{'size':'Large','material':'polyester','color':'gray'},{'dss821.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSS821XL','DSS821','DataStax Gray Track Jacket','DataStax','DSS821','DataStax Gray Track Jacket - Extra Large','This lightweight polyester jacket will be your favorite while hiking the trails or teeing off.',{'size':'Extra Large','material':'polyester','color':'gray'},{'dss821.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH915S','DSH915','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS915','DataStax Vintage 2015 MVP Hoodie - Small','Given out to MVPs at the 2015 DataStax Cassandra Summit.  Warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Small','color':'black'},{'dsh915.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH915M','DSH915','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS915','DataStax Vintage 2015 MVP Hoodie - Medium','Given out to MVPs at the 2015 DataStax Cassandra Summit.  Warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Medium','color':'black'},{'dsh915.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH915L','DSH915','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS915','DataStax Vintage 2015 MVP Hoodie - Large','Given out to MVPs at the 2015 DataStax Cassandra Summit.  Warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Large','color':'black'},{'dsh915.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH915XL','DSH915','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS915','DataStax Vintage 2015 MVP Hoodie - Extra Large','Given out to MVPs at the 2015 DataStax Cassandra Summit.  Warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Extra Large','color':'black'},{'dsh915.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH916S','DSH916','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS916','DataStax Black Hoodie - Small','Super warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Small','color':'black'},{'dsh916.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH916M','DSH916','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS916','DataStax Black Hoodie - Medium','Super warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Medium','color':'black'},{'dsh916.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH916L','DSH916','DataStax Vintage 2015 MVP Hoodie','DataStax','DSS916','DataStax Black Hoodie - Large','Super warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Large','color':'black'},{'dsh916.jpg'});
INSERT INTO product(product_id,product_group,name,brand,model_number,short_desc,long_desc,specifications,images)
VALUES ('DSH916XL','DSH916','DataStax Black Hoodie','DataStax','DSS916','DataStax Black Hoodie - Extra Large','Super warm!  You will underestimate how many times you will fall asleep wearing this!',{'size':'Extra Large','color':'black'},{'dsh916.jpg'});

INSERT INTO featured_product_groups (feature_id,name,category_id,image,price,parent_id) VALUES (202112,'DataStax Gray Track Jacket',f629e107-b219-4563-a852-6909fd246949,'dss821.jpg',44.99,d887b049-d16c-46e1-8c94-0a1280dedc30);
INSERT INTO featured_product_groups (feature_id,name,category_id,image,price,parent_id) VALUES (202112,'DataStax Black Hoodie',b9bed3c0-0a76-44ea-bce6-f5f21611a3f1,'dsh916.jpg',35.99,6a4d86aa-ceb5-4c6f-b9b9-80e9a8c58ad1);
INSERT INTO featured_product_groups (feature_id,name,category_id,image,price,parent_id) VALUES (202112,'Apache Cassandra 3.0 Contributor T-Shirt',95ae4613-0184-46ee-b4b0-adfe882754a8,'apc30a.jpg',15.99,91455473-212e-4c6e-8bec-1da06779ae10);
INSERT INTO featured_product_groups (feature_id,name,category_id,image,price,parent_id) VALUES (202112,'DataStax Astra "One Team" Long Sleeve Tee',775be203-1a84-4822-9645-4da98ca2b2d8,'dsa1121.jpg',21.99,91455473-212e-4c6e-8bec-1da06779ae10);
