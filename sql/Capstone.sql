-- ENUM TYPES
CREATE TYPE gender AS ENUM ('Male', 'Female');
CREATE TYPE order_status_enum AS ENUM ('Accepted', 'On Route', 'Completed', 'Cancelled');
CREATE TYPE order_service_enum AS ENUM ('On the Day', 'Pre-Order');
CREATE TYPE order_enum AS ENUM ('Delivery', 'Pick-Up');
CREATE TYPE payment_method_enum AS ENUM ('Cash', 'GCash', 'Maya');
CREATE TYPE transaction_type_enum AS ENUM ('Onsite', 'Offsite');
CREATE TYPE inventory_type_enum AS ENUM ('Refilled', 'Deployed', 'Returned', 'Discarded');
CREATE TYPE staff_type_enum AS ENUM ('Onsite', 'Delivery');

-- TABLE 1: Water Refilling Station
CREATE TABLE water_refilling_station (
    station_id SERIAL PRIMARY KEY, -- Station ID
    station_name VARCHAR(100) NOT NULL, -- Name of the water refilling station
    station_address VARCHAR(255) NOT NULL, -- Address of the water refilling station
    station_phone_num CHAR(11) UNIQUE NOT NULL, -- Phone number
    station_longitude VARCHAR(255), -- Longitude for map location
    station_latitude VARCHAR(255), -- Latitude for map location
    station_paymaya_acc VARCHAR(255), -- PayMaya account
    station_gcash_qr VARCHAR(255), -- GCash QR code
    station_paymaya_qr VARCHAR(255) -- PayMaya QR code
);
COMMENT ON TABLE water_refilling_station IS 'This table contains the details of the water refilling stations.';
COMMENT ON COLUMN water_refilling_station.station_id IS 'Primary key for the station.';
COMMENT ON COLUMN water_refilling_station.station_name IS 'Name of the water refilling station.';
COMMENT ON COLUMN water_refilling_station.station_address IS 'Address of the water refilling station.';
COMMENT ON COLUMN water_refilling_station.station_phone_num IS 'Contact phone number of the station.';
COMMENT ON COLUMN water_refilling_station.station_longitude IS 'Longitude for precise station location.';
COMMENT ON COLUMN water_refilling_station.station_latitude IS 'Latitude for precise station location.';
COMMENT ON COLUMN water_refilling_station.station_paymaya_acc IS 'PayMaya account of the station.';
COMMENT ON COLUMN water_refilling_station.station_gcash_qr IS 'GCash QR code for transactions.';
COMMENT ON COLUMN water_refilling_station.station_paymaya_qr IS 'PayMaya QR code for transactions.';

-- TABLE 2: Product
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY, -- Product ID
    product_water_type VARCHAR(30) NOT NULL, -- Type of water
    product_price NUMERIC(10, 2) CHECK (product_price >= 0), -- Price
    product_size VARCHAR(20) NOT NULL, -- Size of container
    station_id INT REFERENCES water_refilling_station(station_id) -- Related station ID
);
COMMENT ON TABLE product IS 'This table contains product information sold by the water refilling station.';
COMMENT ON COLUMN product.product_id IS 'Primary key for the product.';
COMMENT ON COLUMN product.product_water_type IS 'Type of water (e.g., purified, alkaline).';
COMMENT ON COLUMN product.product_price IS 'Price of the product.';
COMMENT ON COLUMN product.product_size IS 'Size of the container (e.g., 5 gallons).';
COMMENT ON COLUMN product.station_id IS 'Foreign key referencing the related station ID.';

-- TABLE 3: Customer
CREATE TABLE public."Customer" (
    customer_id SERIAL PRIMARY KEY, -- Customer’s ID
    customer_fname VARCHAR(30) NOT NULL, -- Customer’s first name
    customer_lname VARCHAR(30) NOT NULL, -- Customer’s last name
    customer_phone_num BIGINT NOT NULL, -- Customer’s active phone number
    customer_address VARCHAR(100) NOT NULL, -- Customer’s address for delivery
    customer_gender gender NOT NULL, -- Customer’s gender
    customer_username VARCHAR(50) UNIQUE NOT NULL, -- Customer’s username
    customer_password VARCHAR(255) NOT NULL, -- Customer’s password
    customer_address_long VARCHAR(255) NOT NULL, -- Longitude for precise location
    customer_address_lat VARCHAR(255) NOT NULL -- Latitude for precise location
);
COMMENT ON TABLE public."Customer" IS 'This table contains the personal information of the customer.';
COMMENT ON COLUMN public."Customer".customer_id IS 'Customer’s ID and primary key of the table.';
COMMENT ON COLUMN public."Customer".customer_fname IS 'Customer’s first name.';
COMMENT ON COLUMN public."Customer".customer_lname IS 'Customer’s last name.';
COMMENT ON COLUMN public."Customer".customer_phone_num IS 'Customer’s active phone number.';
COMMENT ON COLUMN public."Customer".customer_address IS 'Customer’s delivery address.';
COMMENT ON COLUMN public."Customer".customer_gender IS 'Customer’s gender.';
COMMENT ON COLUMN public."Customer".customer_username IS 'Customer’s username.';
COMMENT ON COLUMN public."Customer".customer_password IS 'Customer’s hashed password.';
COMMENT ON COLUMN public."Customer".customer_address_long IS 'Longitude of the customer’s address for precise location.';
COMMENT ON COLUMN public."Customer".customer_address_lat IS 'Latitude of the customer’s address for precise location.';

-- TABLE 4: Staff
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY, -- Staff ID
    staff_fname VARCHAR(30) NOT NULL, -- First name
    staff_lname VARCHAR(30) NOT NULL, -- Last name
    staff_type staff_type_enum NOT NULL, -- Staff type
    staff_phone_num CHAR(11) UNIQUE NOT NULL, -- Phone number
    staff_gender gender NOT NULL, -- Gender
    staff_username VARCHAR(50) UNIQUE NOT NULL, -- Username
    staff_password VARCHAR(255) NOT NULL, -- Password
    station_id INT REFERENCES water_refilling_station(station_id) -- Related station ID
);
COMMENT ON TABLE staff IS 'This table contains the personal information of the staff (delivery and onsite workers).';
COMMENT ON COLUMN staff.staff_id IS 'Primary key for the staff.';
COMMENT ON COLUMN staff.staff_fname IS 'First name of the staff member.';
COMMENT ON COLUMN staff.staff_lname IS 'Last name of the staff member.';
COMMENT ON COLUMN staff.staff_type IS 'Type of staff (Delivery, Onsite).';
COMMENT ON COLUMN staff.staff_phone_num IS 'Phone number of the staff member.';
COMMENT ON COLUMN staff.staff_gender IS 'Gender of the staff member.';
COMMENT ON COLUMN staff.staff_username IS 'Username of the staff member.';
COMMENT ON COLUMN staff.staff_password IS 'Password of the staff member.';
COMMENT ON COLUMN staff.station_id IS 'Foreign key referencing the related water refilling station.';

-- TABLE 5: Inventory
CREATE TABLE inventory (
    inv_id SERIAL PRIMARY KEY, -- Inventory ID
    staff_id INT REFERENCES staff(staff_id) -- Related staff ID
);
COMMENT ON TABLE inventory IS 'This table contains stock details logged by the delivery staff and onsite workers.';
COMMENT ON COLUMN inventory.inv_id IS 'Primary key for the inventory log.';
COMMENT ON COLUMN inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';

-- TABLE 6: Product Inventory
CREATE TABLE product_inventory (
    prod_inv_id SERIAL PRIMARY KEY, -- Product inventory ID
    prod_inv_type inventory_type_enum NOT NULL, -- Inventory type
    prod_inv_quantity INT CHECK (prod_inv_quantity >= 0), -- Quantity logged
    prod_inv_time_date TIMESTAMP, -- Timestamp of the log
    staff_id INT REFERENCES staff(staff_id), -- Related staff ID
    product_id INT REFERENCES product(product_id) -- Related product ID
);
COMMENT ON TABLE product_inventory IS 'This table contains product details associated with the inventory logs.';
COMMENT ON COLUMN product_inventory.prod_inv_id IS 'Primary key for the product inventory log.';
COMMENT ON COLUMN product_inventory.prod_inv_type IS 'Type of logging in the inventory (e.g., Refilled, Deployed).';
COMMENT ON COLUMN product_inventory.prod_inv_quantity IS 'Number of containers logged.';
COMMENT ON COLUMN product_inventory.prod_inv_time_date IS 'Timestamp when the inventory was logged.';
COMMENT ON COLUMN product_inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';
COMMENT ON COLUMN product_inventory.product_id IS 'Foreign key referencing the product in the inventory.';

-- TABLE 7: Order
CREATE TABLE "order" (
    order_id SERIAL PRIMARY KEY, -- Order ID
    order_status order_status_enum, -- Status of the order
    order_service_type order_service_enum, -- Type of service (on-the-day/pre-order)
    order_type order_enum, -- Delivery or pick-up
    order_schedule TIMESTAMP, -- Scheduled time for delivery
    order_location VARCHAR(255), -- Delivery location
    customer_id INT REFERENCES public."Customer"(customer_id), -- Related customer ID
    order_longitude VARCHAR(255), -- Longitude for precise location
    order_latitude VARCHAR(255), -- Latitude for precise location
    order_created TIMESTAMP -- Time and date the order was created
);
COMMENT ON TABLE "order" IS 'This table contains the order details scheduled by the customer.';
COMMENT ON COLUMN "order".order_id IS 'Order ID and primary key of the table.';
COMMENT ON COLUMN "order".order_status IS 'Current status of the order (e.g., Accepted, Completed).';
COMMENT ON COLUMN "order".order_service_type IS 'Service type for the order (e.g., On the Day or Pre-Order).';
COMMENT ON COLUMN "order".order_type IS 'Type of order: Delivery or Pick-Up.';
COMMENT ON COLUMN "order".order_schedule IS 'The scheduled date and time for delivery.';
COMMENT ON COLUMN "order".order_location IS 'Delivery location for the order.';
COMMENT ON COLUMN "order".customer_id IS 'Foreign key referencing the customer who placed the order.';
COMMENT ON COLUMN "order".order_longitude IS 'Longitude of the delivery location.';
COMMENT ON COLUMN "order".order_latitude IS 'Latitude of the delivery location.';
COMMENT ON COLUMN "order".order_created IS 'Date and time the order was created.';

-- TABLE 8: Feedback
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY, -- Feedback ID
    feedback_rating INT CHECK (feedback_rating BETWEEN 1 AND 5), -- Star rating (1-5)
    feedback_description VARCHAR(255), -- Customer comments
    order_id INT REFERENCES "order"(order_id) -- Related order ID
);
COMMENT ON TABLE feedback IS 'This table contains the feedback details of the delivery and service created by the customer.';
COMMENT ON COLUMN feedback.feedback_id IS 'Feedback ID and primary key of the table.';
COMMENT ON COLUMN feedback.feedback_rating IS 'Star rating of the service (1 to 5).';
COMMENT ON COLUMN feedback.feedback_description IS 'Comments provided by the customer.';
COMMENT ON COLUMN feedback.order_id IS 'Foreign key to the related order ID.';

-- TABLE 9: Order Product
CREATE TABLE order_product (
    order_product_id SERIAL PRIMARY KEY, -- Order Product ID
    order_product_quantity INT CHECK (order_product_quantity >= 0), -- Quantity ordered
    order_product_price NUMERIC(10, 2) CHECK (order_product_price >= 0), -- Total price
    order_id INT REFERENCES "order"(order_id), -- Related order ID
    stock_id INT REFERENCES inventory(inv_id) -- Related stock ID
);
COMMENT ON TABLE order_product IS 'This table contains the products associated with orders scheduled by customers.';
COMMENT ON COLUMN order_product.order_product_id IS 'Primary key for the ordered product.';
COMMENT ON COLUMN order_product.order_product_quantity IS 'Number of gallons ordered through the app.';
COMMENT ON COLUMN order_product.order_product_price IS 'Total price of the products ordered (stored as NUMERIC for precision).';
COMMENT ON COLUMN order_product.order_id IS 'Foreign key referencing the related order ID.';
COMMENT ON COLUMN order_product.stock_id IS 'Foreign key referencing the related stock ID.';

-- TABLE 10: Order Delivery Sales
CREATE TABLE order_delivery_sales (
    ods_id SERIAL PRIMARY KEY, -- Order delivery sales ID
    ods_payment_method payment_method_enum NOT NULL, -- Payment method
    ods_payment_confirm_photo VARCHAR(255), -- Photo evidence of payment
    ods_delivery_confirm_photo VARCHAR(255), -- Photo evidence of delivery
    ods_time_complete TIMESTAMP, -- Completion time
    order_id INT REFERENCES "order"(order_id), -- Related order ID
    staff_id INT REFERENCES staff(staff_id) -- Related staff ID
);
COMMENT ON TABLE order_delivery_sales IS 'This table contains orders used by delivery personnel to generate routes and confirm deliveries.';
COMMENT ON COLUMN order_delivery_sales.ods_id IS 'Primary key for the order delivery sales.';
COMMENT ON COLUMN order_delivery_sales.ods_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';
COMMENT ON COLUMN order_delivery_sales.ods_payment_confirm_photo IS 'Photo evidence of payment.';
COMMENT ON COLUMN order_delivery_sales.ods_delivery_confirm_photo IS 'Photo evidence of delivery completion.';
COMMENT ON COLUMN order_delivery_sales.ods_time_complete IS 'Timestamp when the delivery was completed.';
COMMENT ON COLUMN order_delivery_sales.order_id IS 'Foreign key referencing the related order ID.';
COMMENT ON COLUMN order_delivery_sales.staff_id IS 'Foreign key referencing the staff who handled the delivery.';

-- TABLE 11: Order Pick Up Sales
CREATE TABLE order_pick_up_sales (
    ops_id SERIAL PRIMARY KEY, -- Order pick-up sales ID
    ops_payment_method payment_method_enum NOT NULL, -- Payment method
    ops_payment_confirm_photo VARCHAR(255), -- Photo evidence of payment
    ops_time_complete TIMESTAMP, -- Completion time
    order_id INT REFERENCES "order"(order_id), -- Related order ID
    staff_id INT REFERENCES staff(staff_id) -- Related staff ID
);
COMMENT ON TABLE order_pick_up_sales IS 'This table contains orders used by onsite workers to confirm pick-up orders.';
COMMENT ON COLUMN order_pick_up_sales.ops_id IS 'Primary key for the order pick-up sales.';
COMMENT ON COLUMN order_pick_up_sales.ops_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';
COMMENT ON COLUMN order_pick_up_sales.ops_payment_confirm_photo IS 'Photo evidence of payment.';
COMMENT ON COLUMN order_pick_up_sales.ops_time_complete IS 'Timestamp when the pick-up order was completed.';
COMMENT ON COLUMN order_pick_up_sales.order_id IS 'Foreign key referencing the related order ID.';
COMMENT ON COLUMN order_pick_up_sales.staff_id IS 'Foreign key referencing the staff who handled the pick-up.';

-- TABLE 12: Walk-In Sales
CREATE TABLE walk_in_sales (
    walk_in_id SERIAL PRIMARY KEY, -- Walk-in sales ID
    walk_in_trans_type transaction_type_enum NOT NULL, -- Transaction type
    walk_in_payment_method payment_method_enum NOT NULL, -- Payment method
    walk_in_payment_confirm_photo VARCHAR(255), -- Photo evidence of payment
    walk_in_payment NUMERIC(10, 2) CHECK (walk_in_payment >= 0), -- Payment amount
    staff_id INT REFERENCES staff(staff_id) -- Related staff ID
);
COMMENT ON TABLE walk_in_sales IS 'This table contains sales information from onsite and offsite walk-in transactions.';
COMMENT ON COLUMN walk_in_sales.walk_in_id IS 'Primary key for walk-in sales.';
COMMENT ON COLUMN walk_in_sales.walk_in_trans_type IS 'Type of transaction (Onsite or Offsite).';
COMMENT ON COLUMN walk_in_sales.walk_in_payment_method IS 'Payment method used for the transaction.';
COMMENT ON COLUMN walk_in_sales.walk_in_payment_confirm_photo IS 'Photo evidence of payment.';
COMMENT ON COLUMN walk_in_sales.walk_in_payment IS 'Amount paid during the transaction (NUMERIC for precise financial calculations).';
COMMENT ON COLUMN walk_in_sales.staff_id IS 'Foreign key referencing the staff who handled the transaction.';

-- TABLE 13: Station Owner
CREATE TABLE station_owner (
    st_owner_id SERIAL PRIMARY KEY, -- Station owner ID
    st_owner_fname VARCHAR(30) NOT NULL, -- First name
    st_owner_lname VARCHAR(30) NOT NULL, -- Last name
    st_owner_phone_num CHAR(11) UNIQUE NOT NULL, -- Phone number
    st_owner_gender gender NOT NULL, -- Gender
    st_owner_username VARCHAR(50) UNIQUE NOT NULL, -- Username
    st_owner_password VARCHAR(255) NOT NULL -- Password
);
COMMENT ON TABLE station_owner IS 'This table contains personal information of the station owner.';
COMMENT ON COLUMN station_owner.st_owner_id IS 'Primary key for the station owner.';
COMMENT ON COLUMN station_owner.st_owner_fname IS 'First name of the station owner.';
COMMENT ON COLUMN station_owner.st_owner_lname IS 'Last name of the station owner.';
COMMENT ON COLUMN station_owner.st_owner_phone_num IS 'Phone number of the station owner.';
COMMENT ON COLUMN station_owner.st_owner_gender IS 'Gender of the station owner.';
COMMENT ON COLUMN station_owner.st_owner_username IS 'Unique username for the station owner.';
COMMENT ON COLUMN station_owner.st_owner_password IS 'Password for the station owner account.';

-- TABLE 14: App Owner
CREATE TABLE app_owner (
    app_owner_id SERIAL PRIMARY KEY, -- App owner ID
    app_owner_fname VARCHAR(30), -- First name
    app_owner_lname VARCHAR(30), -- Last name
    app_owner_phone_num BIGINT, -- Active phone number
    app_owner_address VARCHAR(255), -- Address
    app_owner_gender gender, -- Gender
    app_owner_username VARCHAR(50), -- Username
    app_owner_password VARCHAR(255) -- Password
);
COMMENT ON TABLE app_owner IS 'This table contains the personal information of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_id IS 'Primary key of the App Owner table.';
COMMENT ON COLUMN app_owner.app_owner_fname IS 'First name of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_lname IS 'Last name of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_phone_num IS 'Phone number of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_address IS 'Address of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_gender IS 'Gender of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_username IS 'Username of the App Owner.';
COMMENT ON COLUMN app_owner.app_owner_password IS 'Password of the App Owner.';

-- TABLE 15: Walk-In Product
CREATE TABLE walk_in_product (
    walk_in_product_id SERIAL PRIMARY KEY, -- Walk-in Product ID
    walk_in_quantity INT CHECK (walk_in_quantity >= 0) NOT NULL, -- Quantity of containers sold
  	walk_in_price NUMERIC(3, 2) CHECK (walk_in_price >= 0), -- Total price of the products sold
    walk_in_id INT REFERENCES walk_in_sales(walk_in_id), -- Walk-In Sales ID (Foreign Key)
    product_id INT REFERENCES product(product_id) -- Product ID (Foreign Key)
);
COMMENT ON TABLE walk_in_product IS 'This table contains information about products sold through onsite and offsite transactions by walk-in customers.';
COMMENT ON COLUMN walk_in_product.walk_in_product_id IS 'Primary key of the Walk-In Product table.';
COMMENT ON COLUMN walk_in_product.walk_in_quantity IS 'The number of containers sold through onsite and offsite transactions.';
COMMENT ON COLUMN walk_in_product.walk_in_price IS 'Total price of the products sold for this record.';
COMMENT ON COLUMN walk_in_product.walk_in_id IS 'Foreign key referencing the Walk-In Sales table.';
COMMENT ON COLUMN walk_in_product.product_id IS 'Foreign key referencing the Product table.';
