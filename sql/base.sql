--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-02-05 22:26:32

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
-- TOC entry 5 (class 2615 OID 16390)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 876 (class 1247 OID 16392)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'Male',
    'Female'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- TOC entry 879 (class 1247 OID 16398)
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
-- TOC entry 882 (class 1247 OID 16408)
-- Name: order_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_enum AS ENUM (
    'Delivery',
    'Pick-Up'
);


ALTER TYPE public.order_enum OWNER TO postgres;

--
-- TOC entry 885 (class 1247 OID 16414)
-- Name: order_service_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_service_enum AS ENUM (
    'On-the-Day',
    'Pre-Order'
);


ALTER TYPE public.order_service_enum OWNER TO postgres;

--
-- TOC entry 888 (class 1247 OID 16420)
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'Accepted',
    'On-Route',
    'Completed',
    'Cancelled'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- TOC entry 891 (class 1247 OID 16430)
-- Name: payment_method_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method_enum AS ENUM (
    'Cash',
    'GCash',
    'Maya'
);


ALTER TYPE public.payment_method_enum OWNER TO postgres;

--
-- TOC entry 894 (class 1247 OID 16438)
-- Name: staff_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.staff_type_enum AS ENUM (
    'Onsite',
    'Delivery'
);


ALTER TYPE public.staff_type_enum OWNER TO postgres;

--
-- TOC entry 897 (class 1247 OID 16444)
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
-- TOC entry 217 (class 1259 OID 16449)
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
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "Customer"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Customer" IS 'This table contains the personal information of the customer.';


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_id IS 'Customer’s ID and primary key of the table.';


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_fname IS 'Customer’s first name.';


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_lname IS 'Customer’s last name.';


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_phone_num IS 'Customer’s active phone number.';


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address IS 'Customer’s delivery address.';


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_gender IS 'Customer’s gender.';


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_username IS 'Customer’s username.';


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_password IS 'Customer’s hashed password.';


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_address_long; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address_long IS 'Longitude of the customer’s address for precise location.';


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN "Customer".customer_address_lat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Customer".customer_address_lat IS 'Latitude of the customer’s address for precise location.';


--
-- TOC entry 218 (class 1259 OID 16454)
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
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 218
-- Name: Customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Customer_customer_id_seq" OWNED BY public."Customer".customer_id;


--
-- TOC entry 219 (class 1259 OID 16455)
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
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE app_owner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.app_owner IS 'This table contains the personal information of the App Owner.';


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_id IS 'Primary key of the App Owner table.';


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_fname IS 'First name of the App Owner.';


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_lname IS 'Last name of the App Owner.';


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_phone_num IS 'Phone number of the App Owner.';


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_address IS 'Address of the App Owner.';


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_gender IS 'Gender of the App Owner.';


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_username IS 'Username of the App Owner.';


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN app_owner.app_owner_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.app_owner.app_owner_password IS 'Password of the App Owner.';


--
-- TOC entry 220 (class 1259 OID 16460)
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
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 220
-- Name: app_owner_app_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_owner_app_owner_id_seq OWNED BY public.app_owner.app_owner_id;


--
-- TOC entry 221 (class 1259 OID 16461)
-- Name: authentication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication (
    userid integer NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.authentication OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16465)
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
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE feedback; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feedback IS 'This table contains the feedback details of the delivery and service created by the customer.';


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN feedback.feedback_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_id IS 'Feedback ID and primary key of the table.';


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN feedback.feedback_rating; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_rating IS 'Star rating of the service (1 to 5).';


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN feedback.feedback_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.feedback_description IS 'Comments provided by the customer.';


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN feedback.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feedback.order_id IS 'Foreign key to the related order ID.';


--
-- TOC entry 223 (class 1259 OID 16469)
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
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 223
-- Name: feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_feedback_id_seq OWNED BY public.feedback.feedback_id;


--
-- TOC entry 224 (class 1259 OID 16470)
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    inv_id integer NOT NULL,
    staff_id integer
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE inventory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.inventory IS 'This table contains stock details logged by the delivery staff and onsite workers.';


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN inventory.inv_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.inv_id IS 'Primary key for the inventory log.';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN inventory.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';


--
-- TOC entry 225 (class 1259 OID 16473)
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
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 225
-- Name: inventory_inv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_inv_id_seq OWNED BY public.inventory.inv_id;


--
-- TOC entry 226 (class 1259 OID 16474)
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
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "order"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."order" IS 'This table contains the order details scheduled by the customer.';


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_id IS 'Order ID and primary key of the table.';


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_status IS 'Current status of the order (e.g., Accepted, Completed).';


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_service_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_service_type IS 'Service type for the order (e.g., On the Day or Pre-Order).';


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_type IS 'Type of order: Delivery or Pick-Up.';


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_schedule IS 'The scheduled date and time for delivery.';


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_location IS 'Delivery location for the order.';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".customer_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".customer_id IS 'Foreign key referencing the customer who placed the order.';


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_longitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_longitude IS 'Longitude of the delivery location.';


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_latitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_latitude IS 'Latitude of the delivery location.';


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN "order".order_created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."order".order_created IS 'Date and time the order was created.';


--
-- TOC entry 227 (class 1259 OID 16479)
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
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE order_delivery_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_delivery_sales IS 'This table contains orders used by delivery personnel to generate routes and confirm deliveries.';


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.ods_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_id IS 'Primary key for the order delivery sales.';


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.ods_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.ods_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.ods_delivery_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_delivery_confirm_photo IS 'Photo evidence of delivery completion.';


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.ods_time_complete; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.ods_time_complete IS 'Timestamp when the delivery was completed.';


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.order_id IS 'Foreign key referencing the related order ID.';


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN order_delivery_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_delivery_sales.staff_id IS 'Foreign key referencing the staff who handled the delivery.';


--
-- TOC entry 228 (class 1259 OID 16484)
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
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 228
-- Name: order_delivery_sales_ods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_delivery_sales_ods_id_seq OWNED BY public.order_delivery_sales.ods_id;


--
-- TOC entry 229 (class 1259 OID 16485)
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
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_order_id_seq OWNED BY public."order".order_id;


--
-- TOC entry 230 (class 1259 OID 16486)
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
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE order_pick_up_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_pick_up_sales IS 'This table contains orders used by onsite workers to confirm pick-up orders.';


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.ops_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_id IS 'Primary key for the order pick-up sales.';


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.ops_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_payment_method IS 'Payment method used for the order (e.g., Cash, GCash, Maya).';


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.ops_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.ops_time_complete; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.ops_time_complete IS 'Timestamp when the pick-up order was completed.';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.order_id IS 'Foreign key referencing the related order ID.';


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN order_pick_up_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_pick_up_sales.staff_id IS 'Foreign key referencing the staff who handled the pick-up.';


--
-- TOC entry 231 (class 1259 OID 16489)
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
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 231
-- Name: order_pick_up_sales_ops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_pick_up_sales_ops_id_seq OWNED BY public.order_pick_up_sales.ops_id;


--
-- TOC entry 232 (class 1259 OID 16490)
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
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE order_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_product IS 'This table contains the products associated with orders scheduled by customers.';


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN order_product.order_product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_id IS 'Primary key for the ordered product.';


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN order_product.order_product_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_quantity IS 'Number of gallons ordered through the app.';


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN order_product.order_product_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_product_price IS 'Total price of the products ordered (stored as NUMERIC for precision).';


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN order_product.order_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.order_id IS 'Foreign key referencing the related order ID.';


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN order_product.stock_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_product.stock_id IS 'Foreign key referencing the related stock ID.';


--
-- TOC entry 233 (class 1259 OID 16495)
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
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_product_order_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_product_order_product_id_seq OWNED BY public.order_product.order_product_id;


--
-- TOC entry 234 (class 1259 OID 16496)
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
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product IS 'This table contains product information sold by the water refilling station.';


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN product.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_id IS 'Primary key for the product.';


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN product.product_water_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_water_type IS 'Type of water (e.g., purified, alkaline).';


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN product.product_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_price IS 'Price of the product.';


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN product.product_size; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.product_size IS 'Size of the container (e.g., 5 gallons).';


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN product.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.station_id IS 'Foreign key referencing the related station ID.';


--
-- TOC entry 235 (class 1259 OID 16500)
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
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE product_inventory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product_inventory IS 'This table contains product details associated with the inventory logs.';


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.prod_inv_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_id IS 'Primary key for the product inventory log.';


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.prod_inv_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_type IS 'Type of logging in the inventory (e.g., Refilled, Deployed).';


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.prod_inv_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_quantity IS 'Number of containers logged.';


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.prod_inv_time_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.prod_inv_time_date IS 'Timestamp when the inventory was logged.';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.staff_id IS 'Foreign key referencing the staff who logged the inventory.';


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_inventory.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_inventory.product_id IS 'Foreign key referencing the product in the inventory.';


--
-- TOC entry 236 (class 1259 OID 16504)
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
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 236
-- Name: product_inventory_prod_inv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_inventory_prod_inv_id_seq OWNED BY public.product_inventory.prod_inv_id;


--
-- TOC entry 237 (class 1259 OID 16505)
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
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 237
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- TOC entry 238 (class 1259 OID 16506)
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
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE staff; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.staff IS 'This table contains the personal information of the staff (delivery and onsite workers).';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_id IS 'Primary key for the staff.';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_fname IS 'First name of the staff member.';


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_lname IS 'Last name of the staff member.';


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_type IS 'Type of staff (Delivery, Onsite).';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_phone_num IS 'Phone number of the staff member.';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_gender IS 'Gender of the staff member.';


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_username IS 'Username of the staff member.';


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.staff_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.staff_password IS 'Password of the staff member.';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN staff.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.station_id IS 'Foreign key referencing the related water refilling station.';


--
-- TOC entry 239 (class 1259 OID 16509)
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
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 239
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_staff_id_seq OWNED BY public.staff.staff_id;


--
-- TOC entry 240 (class 1259 OID 16510)
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
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE station_owner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.station_owner IS 'This table contains personal information of the station owner.';


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_id IS 'Primary key for the station owner.';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_fname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_fname IS 'First name of the station owner.';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_lname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_lname IS 'Last name of the station owner.';


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_phone_num IS 'Phone number of the station owner.';


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_gender IS 'Gender of the station owner.';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_username IS 'Unique username for the station owner.';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN station_owner.st_owner_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.station_owner.st_owner_password IS 'Password for the station owner account.';


--
-- TOC entry 241 (class 1259 OID 16513)
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
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 241
-- Name: station_owner_st_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.station_owner_st_owner_id_seq OWNED BY public.station_owner.st_owner_id;


--
-- TOC entry 242 (class 1259 OID 16514)
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
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE walk_in_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.walk_in_product IS 'This table contains information about products sold through onsite and offsite transactions by walk-in customers.';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN walk_in_product.walk_in_product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_product_id IS 'Primary key of the Walk-In Product table.';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN walk_in_product.walk_in_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_quantity IS 'The number of containers sold through onsite and offsite transactions.';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN walk_in_product.walk_in_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_price IS 'Total price of the products sold for this record.';


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN walk_in_product.walk_in_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.walk_in_id IS 'Foreign key referencing the Walk-In Sales table.';


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN walk_in_product.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_product.product_id IS 'Foreign key referencing the Product table.';


--
-- TOC entry 243 (class 1259 OID 16519)
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
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 243
-- Name: walk_in_product_walk_in_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.walk_in_product_walk_in_product_id_seq OWNED BY public.walk_in_product.walk_in_product_id;


--
-- TOC entry 244 (class 1259 OID 16520)
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
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE walk_in_sales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.walk_in_sales IS 'This table contains sales information from onsite and offsite walk-in transactions.';


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.walk_in_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_id IS 'Primary key for walk-in sales.';


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.walk_in_trans_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_trans_type IS 'Type of transaction (Onsite or Offsite).';


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.walk_in_payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment_method IS 'Payment method used for the transaction.';


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.walk_in_payment_confirm_photo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment_confirm_photo IS 'Photo evidence of payment.';


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.walk_in_payment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.walk_in_payment IS 'Amount paid during the transaction (NUMERIC for precise financial calculations).';


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN walk_in_sales.staff_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.walk_in_sales.staff_id IS 'Foreign key referencing the staff who handled the transaction.';


--
-- TOC entry 245 (class 1259 OID 16524)
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
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 245
-- Name: walk_in_sales_walk_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.walk_in_sales_walk_in_id_seq OWNED BY public.walk_in_sales.walk_in_id;


--
-- TOC entry 246 (class 1259 OID 16525)
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
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE water_refilling_station; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.water_refilling_station IS 'This table contains the details of the water refilling stations.';


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_id IS 'Primary key for the station.';


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_name IS 'Name of the water refilling station.';


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_address IS 'Address of the water refilling station.';


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_phone_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_phone_num IS 'Contact phone number of the station.';


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_longitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_longitude IS 'Longitude for precise station location.';


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_latitude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_latitude IS 'Latitude for precise station location.';


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_paymaya_acc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_paymaya_acc IS 'PayMaya account of the station.';


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_gcash_qr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_gcash_qr IS 'GCash QR code for transactions.';


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN water_refilling_station.station_paymaya_qr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.water_refilling_station.station_paymaya_qr IS 'PayMaya QR code for transactions.';


--
-- TOC entry 247 (class 1259 OID 16530)
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
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 247
-- Name: water_refilling_station_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.water_refilling_station_station_id_seq OWNED BY public.water_refilling_station.station_id;


--
-- TOC entry 4840 (class 2604 OID 16531)
-- Name: Customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer" ALTER COLUMN customer_id SET DEFAULT nextval('public."Customer_customer_id_seq"'::regclass);


--
-- TOC entry 4841 (class 2604 OID 16532)
-- Name: app_owner app_owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_owner ALTER COLUMN app_owner_id SET DEFAULT nextval('public.app_owner_app_owner_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 16533)
-- Name: feedback feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN feedback_id SET DEFAULT nextval('public.feedback_feedback_id_seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 16534)
-- Name: inventory inv_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory ALTER COLUMN inv_id SET DEFAULT nextval('public.inventory_inv_id_seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 16535)
-- Name: order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN order_id SET DEFAULT nextval('public.order_order_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 16536)
-- Name: order_delivery_sales ods_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales ALTER COLUMN ods_id SET DEFAULT nextval('public.order_delivery_sales_ods_id_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 16537)
-- Name: order_pick_up_sales ops_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales ALTER COLUMN ops_id SET DEFAULT nextval('public.order_pick_up_sales_ops_id_seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 16538)
-- Name: order_product order_product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product ALTER COLUMN order_product_id SET DEFAULT nextval('public.order_product_order_product_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 16539)
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 16540)
-- Name: product_inventory prod_inv_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory ALTER COLUMN prod_inv_id SET DEFAULT nextval('public.product_inventory_prod_inv_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 16541)
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_staff_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 16542)
-- Name: station_owner st_owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner ALTER COLUMN st_owner_id SET DEFAULT nextval('public.station_owner_st_owner_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 16543)
-- Name: walk_in_product walk_in_product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product ALTER COLUMN walk_in_product_id SET DEFAULT nextval('public.walk_in_product_walk_in_product_id_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 16544)
-- Name: walk_in_sales walk_in_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales ALTER COLUMN walk_in_id SET DEFAULT nextval('public.walk_in_sales_walk_in_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 16545)
-- Name: water_refilling_station station_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station ALTER COLUMN station_id SET DEFAULT nextval('public.water_refilling_station_station_id_seq'::regclass);


--
-- TOC entry 4865 (class 2606 OID 16547)
-- Name: Customer Customer_customer_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_customer_username_key" UNIQUE (customer_username);


--
-- TOC entry 4867 (class 2606 OID 16549)
-- Name: Customer Customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (customer_id);


--
-- TOC entry 4869 (class 2606 OID 16551)
-- Name: app_owner app_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_owner
    ADD CONSTRAINT app_owner_pkey PRIMARY KEY (app_owner_id);


--
-- TOC entry 4873 (class 2606 OID 16553)
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- TOC entry 4875 (class 2606 OID 16555)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inv_id);


--
-- TOC entry 4879 (class 2606 OID 16557)
-- Name: order_delivery_sales order_delivery_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_pkey PRIMARY KEY (ods_id);


--
-- TOC entry 4881 (class 2606 OID 16559)
-- Name: order_pick_up_sales order_pick_up_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_pkey PRIMARY KEY (ops_id);


--
-- TOC entry 4877 (class 2606 OID 16561)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4883 (class 2606 OID 16563)
-- Name: order_product order_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_pkey PRIMARY KEY (order_product_id);


--
-- TOC entry 4887 (class 2606 OID 16565)
-- Name: product_inventory product_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_pkey PRIMARY KEY (prod_inv_id);


--
-- TOC entry 4885 (class 2606 OID 16567)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4889 (class 2606 OID 16569)
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- TOC entry 4891 (class 2606 OID 16571)
-- Name: staff staff_staff_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_staff_phone_num_key UNIQUE (staff_phone_num);


--
-- TOC entry 4893 (class 2606 OID 16573)
-- Name: staff staff_staff_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_staff_username_key UNIQUE (staff_username);


--
-- TOC entry 4895 (class 2606 OID 16575)
-- Name: station_owner station_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_pkey PRIMARY KEY (st_owner_id);


--
-- TOC entry 4897 (class 2606 OID 16577)
-- Name: station_owner station_owner_st_owner_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_st_owner_phone_num_key UNIQUE (st_owner_phone_num);


--
-- TOC entry 4899 (class 2606 OID 16579)
-- Name: station_owner station_owner_st_owner_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station_owner
    ADD CONSTRAINT station_owner_st_owner_username_key UNIQUE (st_owner_username);


--
-- TOC entry 4871 (class 2606 OID 16581)
-- Name: authentication unique_userid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication
    ADD CONSTRAINT unique_userid UNIQUE (userid);


--
-- TOC entry 4901 (class 2606 OID 16583)
-- Name: walk_in_product walk_in_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_pkey PRIMARY KEY (walk_in_product_id);


--
-- TOC entry 4903 (class 2606 OID 16585)
-- Name: walk_in_sales walk_in_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales
    ADD CONSTRAINT walk_in_sales_pkey PRIMARY KEY (walk_in_id);


--
-- TOC entry 4905 (class 2606 OID 16587)
-- Name: water_refilling_station water_refilling_station_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station
    ADD CONSTRAINT water_refilling_station_pkey PRIMARY KEY (station_id);


--
-- TOC entry 4907 (class 2606 OID 16589)
-- Name: water_refilling_station water_refilling_station_station_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.water_refilling_station
    ADD CONSTRAINT water_refilling_station_station_phone_num_key UNIQUE (station_phone_num);


--
-- TOC entry 4908 (class 2606 OID 16590)
-- Name: feedback feedback_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- TOC entry 4909 (class 2606 OID 16595)
-- Name: inventory inventory_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- TOC entry 4910 (class 2606 OID 16600)
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public."Customer"(customer_id);


--
-- TOC entry 4911 (class 2606 OID 16605)
-- Name: order_delivery_sales order_delivery_sales_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- TOC entry 4912 (class 2606 OID 16610)
-- Name: order_delivery_sales order_delivery_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_delivery_sales
    ADD CONSTRAINT order_delivery_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- TOC entry 4913 (class 2606 OID 16615)
-- Name: order_pick_up_sales order_pick_up_sales_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- TOC entry 4914 (class 2606 OID 16620)
-- Name: order_pick_up_sales order_pick_up_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_pick_up_sales
    ADD CONSTRAINT order_pick_up_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- TOC entry 4915 (class 2606 OID 16625)
-- Name: order_product order_product_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- TOC entry 4916 (class 2606 OID 16630)
-- Name: order_product order_product_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_product
    ADD CONSTRAINT order_product_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.inventory(inv_id);


--
-- TOC entry 4918 (class 2606 OID 16635)
-- Name: product_inventory product_inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 4919 (class 2606 OID 16640)
-- Name: product_inventory product_inventory_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_inventory
    ADD CONSTRAINT product_inventory_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- TOC entry 4917 (class 2606 OID 16645)
-- Name: product product_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.water_refilling_station(station_id);


--
-- TOC entry 4920 (class 2606 OID 16650)
-- Name: staff staff_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.water_refilling_station(station_id);


--
-- TOC entry 4921 (class 2606 OID 16655)
-- Name: walk_in_product walk_in_product_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 4922 (class 2606 OID 16660)
-- Name: walk_in_product walk_in_product_walk_in_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_product
    ADD CONSTRAINT walk_in_product_walk_in_id_fkey FOREIGN KEY (walk_in_id) REFERENCES public.walk_in_sales(walk_in_id);


--
-- TOC entry 4923 (class 2606 OID 16665)
-- Name: walk_in_sales walk_in_sales_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.walk_in_sales
    ADD CONSTRAINT walk_in_sales_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-02-05 22:26:32

--
-- PostgreSQL database dump complete
--

