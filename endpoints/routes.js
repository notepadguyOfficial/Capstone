const express = require('express');
const router = express.Router();
const Logs = require('../utils/Logs');
const { db, Connect, Stop } = require('../config/database');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// #region Water Refilling Stations

// 02-05-2025 3:16 PM 

/**
 * POST /register-wrs
 * 
 * This endpoint registers a new water refilling station.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {string} req.body.name - Name of the water refilling station
 * @param {string} req.body.address - Address of the water refilling station
 * @param {string} req.body.phone_num - Phone number of the water refilling station
 * @param {string} req.body.lng - Longitude of the water refilling station
 * @param {string} req.body.lat - Latitude of the water refilling station
 * @param {string} [req.body.station_paymaya_acc] - PayMaya account of the water refilling station (optional)
 * @param {string} [req.body.station_gcash_qr] - GCash QR code of the water refilling station (optional)
 * @param {string} [req.body.station_paymaya_qr] - PayMaya QR code of the water refilling station (optional)
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response indicating the registration status of the water refilling station.
 */
router.post('/register-wrs', async (req, res) => {
    Logs.http('Received POST request to /register');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { name, address, phone_num, lng, lat, station_paymaya_acc, station_gcash_qr, station_paymaya_qr } = req.body;    

    const config = {
        requiredFields: ['name', 'address', 'phone_num', 'lng', 'lat'],
        table: 'water_refilling_station',
        data: {
            station_name: name,
            customer_lname: address,
            station_address: phone_num,
            station_phone_num: address,
            station_longitude: lng,
            station_latitude: lat,
            station_paymaya_acc: null,
            station_gcash_qr: null,
            station_paymaya_qr: null,
        },
        field: 'station_id',
    }

    // Validate required fields
    const missingFields = config.requiredFields.filter((field) => !req.body[field]);

    if (missingFields.length) {
        Logs.warning(`Response being sent: Missing Fields: ${missingFields.join(', ')} | status: 400`);
        return res.status(400).json({ error: `Missing Fields: ${missingFields.join(', ')}` });
    }

    try {
        const [user] = await db(config.table)
            .insert(config.data)
            .returning([config.field]);

        res.json({ message: 'Water Refilling Station Registered Successfully!', token });
        Logs.http(`Response being sent: Water Refilling Station Registered Successfully! User ID: ${user[config.field]} | Token: ${token}`);
    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * GET /get-wrs
 * 
 * This endpoint retrieves all water refilling stations.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response with the retrieved water refilling stations or an error message.
 */
router.get('/get-wrs', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    try {
        const { result } = await db('water_refilling_station')
        .select('*');

        if(!result) {
            Logs.error(`Empty Water Refilling Stations! | status: 200`);
            return res.status(200).json({ message: "Empty Water Refilling Stations!" });
        }

        const json_map = result.map(station => ({
            station_id: result.station_id,
            station_name: result.station_name,
            station_address: result.station_address,
            station_phone_num: result.station_phone_num,
            station_longitude: result.station_longitude,
            station_latitude: result.station_latitude,
            station_paymaya_acc: result.station_paymaya_acc,
            station_gcash_qr: result.station_gcash_qr
                ? `/public/${result.station_id}/img/qr/${path.basename(result.station_gcash_qr)}`
                : null,
            station_paymaya_qr: result.station_paymaya_qr
                ? `/public/${result.station_id}/img/qr/${path.basename(result.station_paymaya_qr)}`
                : null,
        }));
        
        res.status(200).json({ message: "Successfully retrieved Water Refilling Station!", data: json_map });
        Logs.http(`Response being sent: Successfully retrieved Water Refilling Station!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * GET /get-wrs-details
 * 
 * This endpoint retrieves the details of a specific water refilling station based on the provided station_id.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.station_id - ID of the water refilling station to retrieve
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response with the retrieved water refilling station details or an error message.
 */
router.get('/get-wrs-datails', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { station_id } = req.body;

    if(!station_id) {
        Logs.warning(`Response being sent: Missing Required Data for Query! | status: 400` );
        return res.status(400).json({ error: 'Missing Required Data for Query!' });
    }

    try {
        const result = await db('water_refilling_station')
        .select('*')
        .where({ station_id })
        .first();

        if(!result) {
            Logs.error(`Water Refilling Station doesn't Exists! | status: 404`);
            return res.status(404).json({ message: "Water Refilling Station doesn't Exists!" });
        }

        const json_map = result.map(station => ({
            station_id: result.station_id,
            station_name: result.station_name,
            station_address: result.station_address,
            station_phone_num: result.station_phone_num,
            station_longitude: result.station_longitude,
            station_latitude: result.station_latitude,
            station_paymaya_acc: result.station_paymaya_acc,
            station_gcash_qr: result.station_gcash_qr
                ? `/public/${result.station_id}/img/qr/${path.basename(result.station_gcash_qr)}`
                : null,
            station_paymaya_qr: result.station_paymaya_qr
                ? `/public/${result.station_id}/img/qr/${path.basename(result.station_paymaya_qr)}`
                : null,
        }));
        
        res.status(200).json({ message: "Successfully retrieved Water Refilling Station Details!", data: json_map });
        Logs.http(`Response being sent: Successfully retrieved Water Refilling Station Details!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * PUT /update-wrs-details
 * 
 * This endpoint updates the details of a specified water refilling station.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.station_id - ID of the water refilling station to update
 * @param {string} [req.body.station_name] - New name of the water refilling station (optional)
 * @param {string} [req.body.station_address] - New address of the water refilling station (optional)
 * @param {string} [req.body.station_phone_num] - New phone number of the water refilling station (optional)
 * @param {string} [req.body.station_longitude] - New longitude of the water refilling station (optional)
 * @param {string} [req.body.station_latitude] - New latitude of the water refilling station (optional)
 * @param {string} [req.body.station_paymaya_acc] - New PayMaya account of the water refilling station (optional)
 * @param {string} [req.body.station_gcash_qr] - New GCash QR code of the water refilling station (optional)
 * @param {string} [req.body.station_paymaya_qr] - New PayMaya QR code of the water refilling station (optional)
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response indicating the update status of the water refilling station.
 */
router.get('/update-wrs-details', async (req, res) => {
    Logs.http('Received PUT request to /update-wrs-details');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { station_id, station_name, station_address, station_phone_num, station_longitude, station_latitude, station_paymaya_acc, station_gcash_qr, station_paymaya_qr } = req.body;

    if (!station_id) {
        Logs.warning(`Response being sent: Missing Required Data for Query! | status: 400`);
        return res.status(400).json({ error: 'Missing station_id for the update!' });
    }

    const updateData = {
        station_name,
        station_address,
        station_phone_num,
        station_longitude,
        station_latitude,
        station_paymaya_acc,
        station_gcash_qr,
        station_paymaya_qr
    };

    Object.keys(updateData).forEach(key => updateData[key] == null && delete updateData[key]);

    try {
        const existingStation = await db('water_refilling_station')
            .select('*')
            .where({ station_id })
            .first();

        if (!existingStation) {
            Logs.error(`Water Refilling Station with ID ${station_id} doesn't exist! | status: 404`);
            return res.status(404).json({ message: "Water Refilling Station doesn't exist!" });
        }

        const result = await db('water_refilling_station')
            .where({ station_id })
            .update(updateData);

        if (!result) {
            Logs.error(`Failed to update Water Refilling Station with ID ${station_id} | status: 400`);
            return res.status(400).json({ message: "Failed to update Water Refilling Station details!" });
        }

        res.status(200).json({ message: "Successfully updated Water Refilling Station details!" });
        Logs.http(`Response being sent: Successfully updated Water Refilling Station details!`);

    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

// #endregion

// #region Staff, Customer, Owner, Admin

/**
 * Handles user registration for different types of users (Customer, Owner, Staff).
 * 
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} req.body - The request body containing user registration data.
 * @param {string} req.body.fname - First name of the user.
 * @param {string} req.body.lname - Last name of the user.
 * @param {string} [req.body.staff_type] - Type of staff (required for staff registration).
 * @param {string} [req.body.address] - Address of the user (required for customer registration).
 * @param {string} req.body.phone - Phone number of the user.
 * @param {string} req.body.gender - Gender of the user.
 * @param {string} req.body.username - Username for the new account.
 * @param {string} req.body.password - Password for the new account.
 * @param {number} [req.body.long] - Longitude of the user's address (required for customer registration).
 * @param {number} [req.body.lang] - Latitude of the user's address (required for customer registration).
 * @param {number} req.body.type - Type of user (1: Customer, 2: Owner, 3: Staff).
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A promise that resolves when the registration process is complete.
 * 
 * @throws {Error} Will throw an error if the registration process fails.
 */
router.post('/register', async (req, res) => {
    Logs.http('Received POST request to /register');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { fname, lname, staff_type, address, phone, gender, username, password, long, lang, type } = req.body;

    if (!type_enum.includes(type)) {
        Logs.error('Response being sent: Invalid user type! | status: 400');
        return res.status(400).json({ error: 'Invalid user type!' });
    }

    const fieldConfigs = {
        1: { // Customer
            requiredFields: ['fname', 'lname', 'address', 'phone', 'gender', 'username', 'password', 'lng', 'lat'],
            table: 'Customer',
            data: {
                customer_fname: fname,
                customer_lname: lname,
                customer_phone_num: phone,
                customer_address: address,
                customer_gender: gender,
                customer_username: username,
                customer_password: null, // Placeholder for hashed password
                customer_address_long: lng,
                customer_address_lat: lat,
            },
            field: 'customer_id',
        },
        2: { // Owner
            requiredFields: ['fname', 'lname', 'phone', 'gender', 'username', 'password'],
            table: 'station_owner',
            data: {
                st_owner_fname: fname,
                st_owner_lname: lname,
                st_owner_phone_num: phone,
                st_owner_gender: gender,
                st_owner_username: username,
                st_owner_password: null, // Placeholder for hashed password
            },
            field: 'st_owner_id',
        },
        3: { // Staff
            requiredFields: ['fname', 'lname', 'staff_type', 'phone', 'gender', 'username', 'password'],
            table: 'staff',
            data: {
                staff_fname: fname,
                staff_lname: lname,
                staff_type: staff_type,
                staff_phone_num: phone,
                staff_gender: gender,
                staff_username: username,
                staff_password: null, // Placeholder for hashed password
            },
            field: 'staff_id',
        },
    };

    const config = fieldConfigs[type];

    if (!config) {
        Logs.error('Response being sent: Unknown type received | status: 400');
        return res.status(400).json({ error: 'Invalid user type!' });
    }

    // Validate required fields
    const missingFields = config.requiredFields.filter((field) => !req.body[field]);

    if (missingFields.length) {
        Logs.warning(`Response being sent: Missing Fields: ${missingFields.join(', ')} | status: 400`);
        return res.status(400).json({ error: `Missing Fields: ${missingFields.join(', ')}` });
    }

    try {
        const hash = await bcrypt.hash(password, 10);
        config.data[Object.keys(config.data).find((key) => key.includes('password'))] = hash;

        const [user] = await db(config.table)
            .insert(config.data)
            .returning([config.field]);

        const token = GenerateToken(user[config.field], type);

        await db('authentication')
            .insert({ userid: user[config.field], token })
            .onConflict('userid')
            .merge({ token, created_at: db.fn.now() });

        res.json({ message: 'User Registered Successfully!', token });
        Logs.http(`Response being sent: User Registered Successfully! User ID: ${user[config.field]} | Token: ${token}`);
    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * Handles user login for different types of users (Admin, Customer, Owner, Staff).
 * 
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} req.body - The request body containing login data.
 * @param {string} req.body.username - The username of the user trying to log in.
 * @param {string} req.body.password - The password of the user trying to log in.
 * @param {number} req.body.type - The type of user (0: Admin, 1: Customer, 2: Owner, 3: Staff).
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A promise that resolves when the login process is complete.
 * 
 * @throws {Error} Will throw an error if the login process fails.
 * 
 * @description
 * This function validates the login credentials, checks the user type,
 * verifies the password, generates a token upon successful login,
 * and updates the authentication table with the new token.
 */
router.post('/login', async(req, res) => {
    Logs.http('Received POST request to /login');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { username, password, type } = req.body;

    if(!username
        || !password
        || !type
    ) {
        Logs.warning(`Response being sent: All Fields are require! | status: 400` );
        return res.status(400).json({ error: 'All Fields are require!' });
    }

    if(!type_enum.includes(type)) {
        Logs.error(`Response being sent: Invalid user type! | status: 400` );
        return res.status(400).json({
            error: 'Invalid user type!'
        });
    }

    try {
        let table, field, user, pass;

        switch (type) {
            case 0: // Admin
                table = 'router_owner';
                field = 'router_owner_id';
                pass = 'router_owner_password';
                user = 'staff_username';
                break;
            case 1: // Customer
                table = 'Customer';
                field = 'customer_id';
                pass = 'customer_password';
                user = 'customer_username';
                break;
            case 2: // Owner
                table = 'userstation_owner';
                field = 'st_owner_id';
                pass = 'st_owner_password';
                user = 'st_owner_username';
                break;
            case 3: // Staff
                table = 'staff';
                field = 'staff_id';
                pass = 'staff_password';
                user = 'staff_username';
                break;
            default:
                Logs.error('Invalid user type provided.');
                return res.status(400).json({ error: 'Invalid user type!' });
        }

        const data = await db(table)
            .select({ id: field, password: pass })
            .where(user, username)
            .first();

        if (!data) {
            Logs.error(`Response being sent: User not found! | status: 404`);
            return res.status(404).json({ error: 'User not found!' });
        }

        const isPasswordValid = await bcrypt.compare(password, data.password);

        if (!isPasswordValid) {
            Logs.debug(`Response being sent: Invalid credentials! | status: 401`);
            return res.status(401).json({ error: 'Invalid credentials!' });
        }

        const token = GenerateToken(data.id, type);

        await db('authentication')
            .insert({ userid: data.id, token })
            .onConflict('userid')
            .merge({ token, created_at: db.fn.now() });

        Logs.http(`Response being sent: Login successful for UserID: ${data.id} | Token: ${token}`);
        res.json({ message: 'Login successful!', token });
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});


/**
 * Handles user logout by invalidating the authentication token.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object.
 * @param {Object} req.body - The request body containing logout data.
 * @param {string} req.body.userid - The user ID of the user logging out.
 * @param {string} req.body.token - The authentication token to be invalidated.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>} - A promise that resolves when the logout process is complete.
 * 
 * @throws {Error} Will throw an error if the logout process fails.
 * 
 * @description
 * This function validates the provided user ID and token, checks if they exist in the authentication table,
 * removes the authentication entry if valid, and sends routerropriate responses based on the outcome.
 */
router.post('/logout', async(req, res) => {
    Logs.http('Received POST request to /logout');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { userid, token } = req.body;

    if(!userid || !token) {
        return res.status(400).json({ error: 'User ID and Token are required for logout' });
    }

    try {
        const result = await db('authentication')
            .select('*')
            .where({ userid, token })
            .first();

        if(!result) {
            Logs.error(`Response being sent: Invalid token! | status: 401`);
            return res.status(401).json({ error: 'Invalid token!' });
        }

        await db('authentication')
            .where({ userid })
            .delete();

        Logs.http(`Response being sent: User logged out successfully for UserID: ${userid}`);
        res.json({ message: 'Logout successful!' });
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

// #endregion

// #region Orders

/**
 * POST /get-orders
 * 
 * This endpoint retrieves orders based on the provided ws_id and status.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.ws_id - Water Refilling Station Identification
 * @param {string} req.body.status - Status of the order e.g Accepted, On-Route, Completed, Cancelled
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response with the retrieved orders or an error message.
 */
router.post('/get-orders', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { ws_id, status } = req.body;

    if(!ws_id || !status) {
        Logs.warning(`Response being sent: Missing Required Data for Query! | status: 400` );
        return res.status(400).json({ error: 'Missing Required Data for Query!' });
    }

    try {

        const { result } = await db('Orders')
        .select('*')
        .where({ ws_id, status });

        if(!result) {
            Logs.error(`Empty Orders! | status: 200`);
            return res.status(200).json({ message: "Empty Orders!" });
        }
        
        res.status(200).json({ message: "Successfully retrieved orders!", data: result });
        Logs.http(`Response being sent: Successfully retrieved orders!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * POST /get-order-details
 * 
 * This endpoint retrieves the details of a specific order based on the provided order_id.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.order_id - ID of the order to retrieve
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response with the retrieved order details or an error message.
 */
router.post('/get-order-datails', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { order_id } = req.body;

    if(!order_id) {
        Logs.warning(`Response being sent: Missing Required Data for Query! | status: 400` );
        return res.status(400).json({ error: 'Missing Required Data for Query!' });
    }

    try {
        const result = await db('Orders')
        .select('*')
        .where({ order_id })
        .first();

        if(!result) {
            Logs.error(`Order doesn't Exists! | status: 404`);
            return res.status(404).json({ error: "Order doesn't Exists!" });
        }
        
        res.status(200).json({ message: "Successfully retrieved Order Details!", data: result });
        Logs.http(`Response being sent: Successfully retrieved Order Details!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * Handles POST requests to the /feedback endpoint.
 *
 * This endpoint receives feedback data from the request body, validates it,
 * and inserts it into the database. Logs are generated for the request and response.
 *
 * @param {Object} req - The request object from the client.
 * @param {Object} req.body - The body of the request containing feedback data.
 * @param {number} req.body.rating - The rating provided by the customer (1-5).
 * @param {string} req.body.comment - The comment provided by the customer.
 * @param {number} req.body.order_id - The ID of the related order.
 * @param {Object} req.headers - The headers of the request.
 * @param {string} req.ip - The IP address of the client.
 * @param {Object} req.socket - The socket object containing the remote address.
 * @param {Object} res - The response object to send the response back to the client.
 *
 * @returns {void} - Sends a JSON response with a success message or an error message.
 */
router.post('/feedback', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { rating, comment, order_id } = req.body;

    if(!rating || !comment) {
        Logs.warning(`Response being sent: All Fields are require! | status: 400` );
        return res.status(400).json({ error: 'All Fields are require!' });
    }

    try {
        let query = {
            table: 'feedback',
            data: {
                feedback_rating : rating,
                feedback_description: comment,
                order_id: order_id,
            },
            field: 'feedback_id',
        }

        const [feedback] = await db(query.table)
            .insert(query.data)
            .returning([query.field]);

        res.json({ message: 'Successfully sent Feedback!' });
        Logs.http(`Response being sent: Successfully sent Feedback!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

// #endregion

// #region QR Code

// 02-05-2025 3:16 PM

/**
 * POST /upload-qrcode-gcash
 * 
 * This endpoint uploads a GCash QR code for a specified water refilling station.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.station_id - ID of the water refilling station
 * @param {Object} req.file - Uploaded file object
 * @param {Buffer} req.file.buffer - Buffer containing the uploaded file data
 * @param {string} req.file.originalname - Original name of the uploaded file
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response indicating the upload status of the GCash QR code.
 */
router.post('/upload-qrcode-gcash', upload.single('gcash_qr'), async (req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { station_id } = req.body;

    const qrCodeFilePath = path.join(__dirname, 'public', station_id, 'img', 'qr', req.file.originalname);

    fs.writeFileSync(qrCodeFilePath, req.file.buffer);

    const qrCodeUrl = `/public/${station_id}/img/qr/${req.file.originalname}`;

    try {
        const result = await db('water_refilling_station')
        .where({ station_id })
        .update({ station_gcash_qr: qrCodeUrl });

        if(!result) {
            return res.status(404).json({ error: 'Water Refilling Station not Found!' });
            Logs.http(`Response being sent: Water Refilling Station not Found!`);
        }

        res.status(200).json({ message: 'QR code Uploaded Successfully!' });
        Logs.http(`Response being sent: QR code Uploaded Successfully!`);
    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * POST /upload-qrcode-maya
 * 
 * This endpoint uploads a PayMaya QR code for a specified water refilling station.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.station_id - ID of the water refilling station
 * @param {Object} req.file - Uploaded file object
 * @param {Buffer} req.file.buffer - Buffer containing the uploaded file data
 * @param {string} req.file.originalname - Original name of the uploaded file
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response indicating the upload status of the PayMaya QR code.
 */
router.post('/upload-qrcode-maya', upload.single('maya_qr'), async (req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { station_id } = req.body;

    const qrCodeFilePath = path.join(__dirname, 'public', station_id, 'img', 'qr', req.file.originalname);

    const qrCodeUrl = `/public/${station_id}/img/qr/${req.file.originalname}`;

    try {
        const result = await db('water_refilling_station')
        .where({ station_id })
        .update({ station_paymaya_qr: qrCodeUrl });

        if(!result) {
            return res.status(404).json({ error: 'Water Refilling Station not Found!' });
            Logs.http(`Response being sent: Water Refilling Station not Found!`);
        }

        res.status(200).json({ message: 'QR code Uploaded Successfully!' });
        Logs.http(`Response being sent: QR code Uploaded Successfully!`);
    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

// #endregion

module.exports = router;