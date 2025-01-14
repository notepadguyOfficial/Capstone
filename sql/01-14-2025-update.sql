--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'Male',
    'Female'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- Name: inventory_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.inventory_type_enum AS ENUM (
    'Refilled',
    'Deployed',
    'Returned',
    'Discarded'
);


ALTER TYPE public.inventory_type_enum OWNER TO postgres;

--
-- Name: order_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_enum AS ENUM (
    'Delivery',
    'Pick-Up'
);


ALTER TYPE public.order_enum OWNER TO postgres;

--
-- Name: order_service_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_service_enum AS ENUM (
    'On the Day',
    'Pre-Order'
);


ALTER TYPE public.order_service_enum OWNER TO postgres;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'Accepted',
    'On Route',
    'Completed',
    'Cancelled'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- Name: payment_method_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method_enum AS ENUM (
    'Cash',
    'GCash',
    'Maya'
);


ALTER TYPE public.payment_method_enum OWNER TO postgres;

--
-- Name: staff_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.staff_type_enum AS ENUM (
    'Onsite',
    'Delivery'
);


ALTER TYPE public.staff_type_enum OWNER TO postgres;

--
-- Name: transaction_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_type_enum AS ENUM (
    'Onsite',
    'Offsite'
);


ALTER TYPE public.transaction_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Customer" (
    customer_id integer NOT NULL,
    customer_fname character varying(30) NOT NULL,
    customer_lname character varying(30) NOT NULL,
    customer_phone_num bigint NOT NULL,
    customer_address character varying(100) NOT NULL,
    customer_gender public.gender NOT NULL,
    customer_username character varying(50) NOT NULL,
    customer_password character varying(255) NOT NULL,
    customer_address_long character varying(255) NOT NULL,
    customer_address_lat character varying(255) NOT NULL
);


ALTER TABLE public."Customer" OWNER TO postgres;

--
-- Name: TABLE "Customer"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Customer" IS 'This table contains the personal information of the customer.';


--
-- Name: COLUMN "Customer".customer_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_id IS 'Customer’s ID and primary key of the table.';


--
-- Name: COLUMN "Customer".customer_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_fname IS 'Customer’s first name.';


--
-- Name: COLUMN "Customer".customer_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_lname IS 'Customer’s last name.';


--
-- Name: COLUMN "Customer".customer_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_phone_num IS 'Customer’s active phone number.';


--
-- Name: COLUMN "Customer".customer_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address IS 'Customer’s delivery address.';


--
-- Name: COLUMN "Customer".customer_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_gender IS 'Customer’s gender.';


--
-- Name: COLUMN "Customer".customer_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_username IS 'Customer’s username.';


--
-- Name: COLUMN "Customer".customer_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_password IS 'Customer’s hashed password.';


--
-- Name: COLUMN "Customer".customer_address_long; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address_long IS 'Longitude of the customer’s address for precise location.';


--
-- Name: COLUMN "Customer".customer_address_lat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address_lat IS 'Latitude of the customer’s address for precise location.';


--
-- Name: Customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Customer_customer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Customer_customer_id_seq" OWNER TO postgres;

--
-- Name: Customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Customer_customer_id_seq" OWNED BY public."Customer".customer_id;


--
-- Name: app_owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_owner (
    app_owner_id integer NOT NULL,
    app_owner_fname character varying(30),
    app_owner_lname character varying(30),
    app_owner_phone_num bigint,
    app_owner_address character varying(255),
    app_owner_gender public.gender,
    app_owner_username character varying(50),
    app_owner_password character varying(255)
);


ALTER TABLE public.app_owner OWNER TO postgres;

--
-- Name: TABLE app_owner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.app_owner IS 'This table contains the personal information of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_id IS 'Primary key of the App Owner table.';


--
-- Name: COLUMN app_owner.app_owner_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_fname IS 'First name of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_lname IS 'Last name of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_phone_num IS 'Phone number of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_address IS 'Address of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_gender IS 'Gender of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_username IS 'Username of the App Owner.';


--
-- Name: COLUMN app_owner.app_owner_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_password IS 'Password of the App Owner.';


--
-- Name: app_owner_app_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_owner_app_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_owner_app_owner_id_seq OWNER TO postgres;

--
-- Name: app_owner_app_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_owner_app_owner_id_seq OWNED BY public.app_owner.app_owner_id;


--
-- Name: authentication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication (
    userid integer NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.authentication OWNER TO postgres;

--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    feedback_id integer NOT NULL,
    feedback_rating integer,
    feedback_description character varying(255),
    order_id integer,
    CONSTRAINT feedback_feedback_rating_check CHECK (((feedback_rating >= 1) AND (feedback_rating <= 5)))
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: TABLE feedback; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feedback IS 'This table contains the feedback details of the delivery and service created by the customer.';


--
-- Name: COLUMN feedback.feedback_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_id IS 'Feedback ID and primary key of the table.';


--
-- Name: COLUMN feedback.feedback_rating; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_rating IS 'Star rating of the service (1 to 5).';


--
-- Name: COLUMN feedback.feedback_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_description IS 'Comments provided by the customer.';


--
-- Name: COLUMN feedback.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.order_id IS 'Foreign key to the related order ID.';


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feedback_feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_feedback_id_seq OWNED BY public.feedback.feedback_id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    inv_id integer NOT NULL,
    staff_id integer
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: TABLE inventory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.inventory IS 'This table contains stock details logged by the delivery staff and onsite workers.';


--
-- Name: COLUMN inventory.inv_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.inv_id IS 'Primary key for the inventory log.';


--
-- Name: COLUMN inventory.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';


--
-- Name: inventory_inv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_inv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_inv_id_seq OWNER TO postgres;

--
-- Name: inventory_inv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_inv_id_seq OWNED BY public.inventory.inv_id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    order_id integer NOT NULL,
    order_status public.order_status_enum,
    order_service_type public.order_service_enum,
    order_type public.order_enum,
    order_schedule timestamp without time zone,
    order_location character varying(255),
    customer_id integer,
    order_longitude character varying(255),
    order_latitude character varying(255),
    order_created timestamp without time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: TABLE "order"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."order" IS 'This table contains the order details scheduled by the customer.';


--
-- Name: COLUMN "order".order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_id IS 'Order ID and primary key of the table.';


--
-- Name: COLUMN "order".order_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_status IS 'Current status of the order (e.g., Accepted, Completed).';


--
-- Name: COLUMN "order".order_service_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_service_type IS 'Service type for the order (e.g., On the Day or Pre-Order).';


--
-- Name: COLUMN "order".order_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_type IS 'Type of order: Delivery or Pick-Up.';


--
-- Name: COLUMN "order".order_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_schedule IS 'The scheduled date and time for delivery.';


--
-- Name: COLUMN "order".order_location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_location IS 'Delivery location for the order.';


--
-- Name: COLUMN "order".customer_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".customer_id IS 'Foreign key referencing the customer who placed the order.';


--
-- Name: COLUMN "order".order_longitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_longitude IS 'Longitude of the delivery location.';


--
-- Name: COLUMN "order".order_latitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_latitude IS 'Latitude of the delivery location.';


--
-- Name: COLUMN "order".order_created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_created IS 'Date and time the order was created.';


--
-- Name: order_delivery_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_delivery_sales (
    ods_id integer NOT NULL,
    ods_payment_method public.payment_method_enum NOT NULL,
    ods_payment_confirm_photo character varying(255),
    ods_delivery_confirm_photo character varying(255),
    ods_time_complete timestamp without time zone,
    order_id integer,
    staff_id integer
);


ALTER TABLE public.order_delivery_sales OWNER TO postgres;

--
-- Name: TABLE order_delivery_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_delivery_sales IS 'This table contains orders used by delivery personnel to generate routes and confirm deliveries.';


--
-- Name: COLUMN order_delivery_sales.ods_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_id IS 'Primary key for the order delivery sales.';


--
-- Name: COLUMN order_delivery_sales.ods_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';


--
-- Name: COLUMN order_delivery_sales.ods_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- Name: COLUMN order_delivery_sales.ods_delivery_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_delivery_confirm_photo IS 'Photo evidence of delivery completion.';


--
-- Name: COLUMN order_delivery_sales.ods_time_complete; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_time_complete IS 'Timestamp when the delivery was completed.';


--
-- Name: COLUMN order_delivery_sales.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.order_id IS 'Foreign key referencing the related order ID.';


--
-- Name: COLUMN order_delivery_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.staff_id IS 'Foreign key referencing the staff who handled the delivery.';


--
-- Name: order_delivery_sales_ods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_delivery_sales_ods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_delivery_sales_ods_id_seq OWNER TO postgres;

--
-- Name: order_delivery_sales_ods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_delivery_sales_ods_id_seq OWNED BY public.order_delivery_sales.ods_id;


--
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_order_id_seq OWNER TO postgres;

--
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_order_id_seq OWNED BY public."order".order_id;


--
-- Name: order_pick_up_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_pick_up_sales (
    ops_id integer NOT NULL,
    ops_payment_method public.payment_method_enum NOT NULL,
    ops_payment_confirm_photo character varying(255),
    ops_time_complete timestamp without time zone,
    order_id integer,
    staff_id integer
);


ALTER TABLE public.order_pick_up_sales OWNER TO postgres;

--
-- Name: TABLE order_pick_up_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_pick_up_sales IS 'This table contains orders used by onsite workers to confirm pick-up orders.';


--
-- Name: COLUMN order_pick_up_sales.ops_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_id IS 'Primary key for the order pick-up sales.';


--
-- Name: COLUMN order_pick_up_sales.ops_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';


--
-- Name: COLUMN order_pick_up_sales.ops_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- Name: COLUMN order_pick_up_sales.ops_time_complete; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_time_complete IS 'Timestamp when the pick-up order was completed.';


--
-- Name: COLUMN order_pick_up_sales.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.order_id IS 'Foreign key referencing the related order ID.';


--
-- Name: COLUMN order_pick_up_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.staff_id IS 'Foreign key referencing the staff who handled the pick-up.';


--
-- Name: order_pick_up_sales_ops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_pick_up_sales_ops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_pick_up_sales_ops_id_seq OWNER TO postgres;

--
-- Name: order_pick_up_sales_ops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_pick_up_sales_ops_id_seq OWNED BY public.order_pick_up_sales.ops_id;


--
-- Name: order_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_product (
    order_product_id integer NOT NULL,
    order_product_quantity integer,
    order_product_price numeric(10,2),
    order_id integer,
    stock_id integer,
    CONSTRAINT order_product_order_product_price_check CHECK ((order_product_price >= (0)::numeric)),
    CONSTRAINT order_product_order_product_quantity_check CHECK ((order_product_quantity >= 0))
);


ALTER TABLE public.order_product OWNER TO postgres;

--
-- Name: TABLE order_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_product IS 'This table contains the products associated with orders scheduled by customers.';


--
-- Name: COLUMN order_product.order_product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_id IS 'Primary key for the ordered product.';


--
-- Name: COLUMN order_product.order_product_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_quantity IS 'Number of gallons ordered through the app.';


--
-- Name: COLUMN order_product.order_product_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_price IS 'Total price of the products ordered (stored as NUMERIC for precision).';


--
-- Name: COLUMN order_product.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_id IS 'Foreign key referencing the related order ID.';


--
-- Name: COLUMN order_product.stock_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.stock_id IS 'Foreign key referencing the related stock ID.';


--
-- Name: order_product_order_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_product_order_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_product_order_product_id_seq OWNER TO postgres;

--
-- Name: order_product_order_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_product_order_product_id_seq OWNED BY public.order_product.order_product_id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    product_water_type character varying(30) NOT NULL,
    product_price numeric(10,2),
    product_size character varying(20) NOT NULL,
    station_id integer,
    CONSTRAINT product_product_price_check CHECK ((product_price >= (0)::numeric))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: TABLE product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product IS 'This table contains product information sold by the water refilling station.';


--
-- Name: COLUMN product.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_id IS 'Primary key for the product.';


--
-- Name: COLUMN product.product_water_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_water_type IS 'Type of water (e.g., purified, alkaline).';


--
-- Name: COLUMN product.product_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_price IS 'Price of the product.';


--
-- Name: COLUMN product.product_size; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_size IS 'Size of the container (e.g., 5 gallons).';


--
-- Name: COLUMN product.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.station_id IS 'Foreign key referencing the related station ID.';


--
-- Name: product_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_inventory (
    prod_inv_id integer NOT NULL,
    prod_inv_type public.inventory_type_enum NOT NULL,
    prod_inv_quantity integer,
    prod_inv_time_date timestamp without time zone,
    staff_id integer,
    product_id integer,
    CONSTRAINT product_inventory_prod_inv_quantity_check CHECK ((prod_inv_quantity >= 0))
);


ALTER TABLE public.product_inventory OWNER TO postgres;

--
-- Name: TABLE product_inventory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product_inventory IS 'This table contains product details associated with the inventory logs.';


--
-- Name: COLUMN product_inventory.prod_inv_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_id IS 'Primary key for the product inventory log.';


--
-- Name: COLUMN product_inventory.prod_inv_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_type IS 'Type of logging in the inventory (e.g., Refilled, Deployed).';


--
-- Name: COLUMN product_inventory.prod_inv_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_quantity IS 'Number of containers logged.';


--
-- Name: COLUMN product_inventory.prod_inv_time_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_time_date IS 'Timestamp when the inventory was logged.';


--
-- Name: COLUMN product_inventory.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';


--
-- Name: COLUMN product_inventory.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.product_id IS 'Foreign key referencing the product in the inventory.';


--
-- Name: product_inventory_prod_inv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_inventory_prod_inv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_inventory_prod_inv_id_seq OWNER TO postgres;

--
-- Name: product_inventory_prod_inv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_inventory_prod_inv_id_seq OWNED BY public.product_inventory.prod_inv_id;


--
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_product_id_seq OWNER TO postgres;

--
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staff_id integer NOT NULL,
    staff_fname character varying(30) NOT NULL,
    staff_lname character varying(30) NOT NULL,
    staff_type public.staff_type_enum NOT NULL,
    staff_phone_num character(11) NOT NULL,
    staff_gender public.gender NOT NULL,
    staff_username character varying(50) NOT NULL,
    staff_password character varying(255) NOT NULL,
    station_id integer
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: TABLE staff; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.staff IS 'This table contains the personal information of the staff (delivery and onsite workers).';


--
-- Name: COLUMN staff.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_id IS 'Primary key for the staff.';


--
-- Name: COLUMN staff.staff_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_fname IS 'First name of the staff member.';


--
-- Name: COLUMN staff.staff_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_lname IS 'Last name of the staff member.';


--
-- Name: COLUMN staff.staff_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_type IS 'Type of staff (Delivery, Onsite).';


--
-- Name: COLUMN staff.staff_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_phone_num IS 'Phone number of the staff member.';


--
-- Name: COLUMN staff.staff_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_gender IS 'Gender of the staff member.';


--
-- Name: COLUMN staff.staff_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_username IS 'Username of the staff member.';


--
-- Name: COLUMN staff.staff_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_password IS 'Password of the staff member.';


--
-- Name: COLUMN staff.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.station_id IS 'Foreign key referencing the related water refilling station.';


--
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_staff_id_seq OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_staff_id_seq OWNED BY public.staff.staff_id;


--
-- Name: station_owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.station_owner (
    st_owner_id integer NOT NULL,
    st_owner_fname character varying(30) NOT NULL,
    st_owner_lname character varying(30) NOT NULL,
    st_owner_phone_num character(11) NOT NULL,
    st_owner_gender public.gender NOT NULL,
    st_owner_username character varying(50) NOT NULL,
    st_owner_password character varying(255) NOT NULL
);


ALTER TABLE public.station_owner OWNER TO postgres;

--
-- Name: TABLE station_owner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.station_owner IS 'This table contains personal information of the station owner.';


--
-- Name: COLUMN station_owner.st_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_id IS 'Primary key for the station owner.';


--
-- Name: COLUMN station_owner.st_owner_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_fname IS 'First name of the station owner.';


--
-- Name: COLUMN station_owner.st_owner_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_lname IS 'Last name of the station owner.';


--
-- Name: COLUMN station_owner.st_owner_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_phone_num IS 'Phone number of the station owner.';


--
-- Name: COLUMN station_owner.st_owner_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_gender IS 'Gender of the station owner.';


--
-- Name: COLUMN station_owner.st_owner_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_username IS 'Unique username for the station owner.';


--
-- Name: COLUMN station_owner.st_owner_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_password IS 'Password for the station owner account.';


--
-- Name: station_owner_st_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.station_owner_st_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_owner_st_owner_id_seq OWNER TO postgres;

--
-- Name: station_owner_st_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.station_owner_st_owner_id_seq OWNED BY public.station_owner.st_owner_id;


--
-- Name: walk_in_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.walk_in_product (
    walk_in_product_id integer NOT NULL,
    walk_in_quantity integer NOT NULL,
    walk_in_price numeric(3,2),
    walk_in_id integer,
    product_id integer,
    CONSTRAINT walk_in_product_walk_in_price_check CHECK ((walk_in_price >= (0)::numeric)),
    CONSTRAINT walk_in_product_walk_in_quantity_check CHECK ((walk_in_quantity >= 0))
);


ALTER TABLE public.walk_in_product OWNER TO postgres;

--
-- Name: TABLE walk_in_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.walk_in_product IS 'This table contains information about products sold through onsite and offsite transactions by walk-in customers.';


--
-- Name: COLUMN walk_in_product.walk_in_product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_product_id IS 'Primary key of the Walk-In Product table.';


--
-- Name: COLUMN walk_in_product.walk_in_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_quantity IS 'The number of containers sold through onsite and offsite transactions.';


--
-- Name: COLUMN walk_in_product.walk_in_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_price IS 'Total price of the products sold for this record.';


--
-- Name: COLUMN walk_in_product.walk_in_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_id IS 'Foreign key referencing the Walk-In Sales table.';


--
-- Name: COLUMN walk_in_product.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.product_id IS 'Foreign key referencing the Product table.';


--
-- Name: walk_in_product_walk_in_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.walk_in_product_walk_in_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.walk_in_product_walk_in_product_id_seq OWNER TO postgres;

--
-- Name: walk_in_product_walk_in_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.walk_in_product_walk_in_product_id_seq OWNED BY public.walk_in_product.walk_in_product_id;


--
-- Name: walk_in_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.walk_in_sales (
    walk_in_id integer NOT NULL,
    walk_in_trans_type public.transaction_type_enum NOT NULL,
    walk_in_payment_method public.payment_method_enum NOT NULL,
    walk_in_payment_confirm_photo character varying(255),
    walk_in_payment numeric(10,2),
    staff_id integer,
    CONSTRAINT walk_in_sales_walk_in_payment_check CHECK ((walk_in_payment >= (0)::numeric))
);


ALTER TABLE public.walk_in_sales OWNER TO postgres;

--
-- Name: TABLE walk_in_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.walk_in_sales IS 'This table contains sales information from onsite and offsite walk-in transactions.';


--
-- Name: COLUMN walk_in_sales.walk_in_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_id IS 'Primary key for walk-in sales.';


--
-- Name: COLUMN walk_in_sales.walk_in_trans_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_trans_type IS 'Type of transaction (Onsite or Offsite).';


--
-- Name: COLUMN walk_in_sales.walk_in_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment_method IS 'Payment method used for the transaction.';


--
-- Name: COLUMN walk_in_sales.walk_in_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- Name: COLUMN walk_in_sales.walk_in_payment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment IS 'Amount paid during the transaction (NUMERIC for precise financial calculations).';


--
-- Name: COLUMN walk_in_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.staff_id IS 'Foreign key referencing the staff who handled the transaction.';


--
-- Name: walk_in_sales_walk_in_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.walk_in_sales_walk_in_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.walk_in_sales_walk_in_id_seq OWNER TO postgres;

--
-- Name: walk_in_sales_walk_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.walk_in_sales_walk_in_id_seq OWNED BY public.walk_in_sales.walk_in_id;


--
-- Name: water_refilling_station; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.water_refilling_station (
    station_id integer NOT NULL,
    station_name character varying(100) NOT NULL,
    station_address character varying(255) NOT NULL,
    station_phone_num character(11) NOT NULL,
    station_longitude character varying(255),
    station_latitude character varying(255),
    station_paymaya_acc character varying(255),
    station_gcash_qr character varying(255),
    station_paymaya_qr character varying(255)
);


ALTER TABLE public.water_refilling_station OWNER TO postgres;

--
-- Name: TABLE water_refilling_station; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.water_refilling_station IS 'This table contains the details of the water refilling stations.';


--
-- Name: COLUMN water_refilling_station.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_id IS 'Primary key for the station.';


--
-- Name: COLUMN water_refilling_station.station_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_name IS 'Name of the water refilling station.';


--
-- Name: COLUMN water_refilling_station.station_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_address IS 'Address of the water refilling station.';


--
-- Name: COLUMN water_refilling_station.station_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_phone_num IS 'Contact phone number of the station.';


--
-- Name: COLUMN water_refilling_station.station_longitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_longitude IS 'Longitude for precise station location.';


--
-- Name: COLUMN water_refilling_station.station_latitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_latitude IS 'Latitude for precise station location.';


--
-- Name: COLUMN water_refilling_station.station_paymaya_acc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_paymaya_acc IS 'PayMaya account of the station.';


--
-- Name: COLUMN water_refilling_station.station_gcash_qr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_gcash_qr IS 'GCash QR code for transactions.';


--
-- Name: COLUMN water_refilling_station.station_paymaya_qr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_paymaya_qr IS 'PayMaya QR code for transactions.';


--
-- Name: water_refilling_station_station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.water_refilling_station_station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.water_refilling_station_station_id_seq OWNER TO postgres;

--
-- Name: water_refilling_station_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.water_refilling_station_station_id_seq OWNED BY public.water_refilling_station.station_id;


--
-- Name: Customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer" ALTER COLUMN customer_id SET DEFAULT nextval('public."Customer_customer_id_seq"'::regclass);


--
-- Name: app_owner app_owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_owner ALTER COLUMN app_owner_id SET DEFAULT nextval('public.app_owner_app_owner_id_seq'::regclass);


--
-- Name: feedback feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN feedback_id SET DEFAULT nextval('public.feedback_feedback_id_seq'::regclass);


--
-- Name: inventory inv_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory ALTER COLUMN inv_id SET DEFAULT nextval('public.inventory_inv_id_seq'::regclass);


--
-- Name: order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN order_id SET DEFAULT nextval('public.order_order_id_seq'::regclass);


--
-- Name: order_delivery_sales ods_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales ALTER COLUMN ods_id SET DEFAULT nextval('public.order_delivery_sales_ods_id_seq'::regclass);


--
-- Name: order_pick_up_sales ops_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales ALTER COLUMN ops_id SET DEFAULT nextval('public.order_pick_up_sales_ops_id_seq'::regclass);


--
-- Name: order_product order_product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product ALTER COLUMN order_product_id SET DEFAULT nextval('public.order_product_order_product_id_seq'::regclass);


--
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- Name: product_inventory prod_inv_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory ALTER COLUMN prod_inv_id SET DEFAULT nextval('public.product_inventory_prod_inv_id_seq'::regclass);


--
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_staff_id_seq'::regclass);


--
-- Name: station_owner st_owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner ALTER COLUMN st_owner_id SET DEFAULT nextval('public.station_owner_st_owner_id_seq'::regclass);


--
-- Name: walk_in_product walk_in_product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product ALTER COLUMN walk_in_product_id SET DEFAULT nextval('public.walk_in_product_walk_in_product_id_seq'::regclass);


--
-- Name: walk_in_sales walk_in_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales ALTER COLUMN walk_in_id SET DEFAULT nextval('public.walk_in_sales_walk_in_id_seq'::regclass);


--
-- Name: water_refilling_station station_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station ALTER COLUMN station_id SET DEFAULT nextval('public.water_refilling_station_station_id_seq'::regclass);

--
-- Name: Customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Customer_customer_id_seq"', 9, true);


--
-- Name: app_owner_app_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_owner_app_owner_id_seq', 1, false);


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_feedback_id_seq', 1, false);


--
-- Name: inventory_inv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_inv_id_seq', 1, false);


--
-- Name: order_delivery_sales_ods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_delivery_sales_ods_id_seq', 1, false);


--
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_order_id_seq', 1, false);


--
-- Name: order_pick_up_sales_ops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_pick_up_sales_ops_id_seq', 1, false);


--
-- Name: order_product_order_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_product_order_product_id_seq', 1, false);


--
-- Name: product_inventory_prod_inv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_inventory_prod_inv_id_seq', 1, false);


--
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_product_id_seq', 1, false);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_staff_id_seq', 6, true);


--
-- Name: station_owner_st_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.station_owner_st_owner_id_seq', 4, true);


--
-- Name: walk_in_product_walk_in_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.walk_in_product_walk_in_product_id_seq', 1, false);


--
-- Name: walk_in_sales_walk_in_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.walk_in_sales_walk_in_id_seq', 1, false);


--
-- Name: water_refilling_station_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.water_refilling_station_station_id_seq', 1, false);


--
-- Name: Customer Customer_customer_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_customer_username_key" UNIQUE (customer_username);


--
-- Name: Customer Customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (customer_id);


--
-- Name: app_owner app_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_owner
    ADD CONSTRAINT app_owner_pkey PRIMARY KEY (app_owner_id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inv_id);


--
-- Name: order_delivery_sales order_delivery_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_pkey PRIMARY KEY (ods_id);


--
-- Name: order_pick_up_sales order_pick_up_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_pkey PRIMARY KEY (ops_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- Name: order_product order_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_pkey PRIMARY KEY (order_product_id);


--
-- Name: product_inventory product_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_pkey PRIMARY KEY (prod_inv_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: staff staff_staff_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_staff_phone_num_key UNIQUE (staff_phone_num);


--
-- Name: staff staff_staff_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_staff_username_key UNIQUE (staff_username);


--
-- Name: station_owner station_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_pkey PRIMARY KEY (st_owner_id);


--
-- Name: station_owner station_owner_st_owner_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_st_owner_phone_num_key UNIQUE (st_owner_phone_num);


--
-- Name: station_owner station_owner_st_owner_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_st_owner_username_key UNIQUE (st_owner_username);


--
-- Name: authentication unique_userid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication
    ADD CONSTRAINT unique_userid UNIQUE (userid);


--
-- Name: walk_in_product walk_in_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_pkey PRIMARY KEY (walk_in_product_id);


--
-- Name: walk_in_sales walk_in_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales
    ADD CONSTRAINT walk_in_sales_pkey PRIMARY KEY (walk_in_id);


--
-- Name: water_refilling_station water_refilling_station_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station
    ADD CONSTRAINT water_refilling_station_pkey PRIMARY KEY (station_id);


--
-- Name: water_refilling_station water_refilling_station_station_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station
    ADD CONSTRAINT water_refilling_station_station_phone_num_key UNIQUE (station_phone_num);


--
-- Name: feedback feedback_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: inventory inventory_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public."Customer"(customer_id);


--
-- Name: order_delivery_sales order_delivery_sales_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: order_delivery_sales order_delivery_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: order_pick_up_sales order_pick_up_sales_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: order_pick_up_sales order_pick_up_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: order_product order_product_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: order_product order_product_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.inventory(inv_id);


--
-- Name: product_inventory product_inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: product_inventory product_inventory_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: product product_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.water_refilling_station(station_id);


--
-- Name: staff staff_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.water_refilling_station(station_id);


--
-- Name: walk_in_product walk_in_product_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: walk_in_product walk_in_product_walk_in_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_walk_in_id_fkey FOREIGN KEY (walk_in_id) REFERENCES public.walk_in_sales(walk_in_id);


--
-- Name: walk_in_sales walk_in_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales
    ADD CONSTRAINT walk_in_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- PostgreSQL database dump complete
--

