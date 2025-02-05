const express = require('express');
const router = express.Router();
const Logs = require('../utils/Logs');
const { db, Connect, Stop } = require('../config/database');

// #region Water Refilling Stations

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
 * POST /get-wrs
 * 
 * This endpoint retrieves all water refilling stations.
 * 
 * @async
 * @function
 * @param {Object} req - Express request object
 * @param {Object} req.body - Request body
 * @param {number} req.body.ws_id - Workspace ID
 * @param {Object} res - Express response object
 * 
 * @returns {Promise<void>} Sends a JSON response with the retrieved water refilling stations or an error message.
 */
router.post('/get-wrs', async(req, res) => {
    Logs.http('Received POST request to /feedback');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
    Logs.http(`Request Headers: ${JSON.stringify(req.headers)}`);
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { ws_id } = req.body;

    if(!ws_id) {
        Logs.warning(`Response being sent: Missing Required Data for Query! | status: 400` );
        return res.status(400).json({ error: 'Missing Required Data for Query!' });
    }

    try {
        const { result } = await db('water_refilling_station')
        .select('*');

        if(!result) {
            Logs.error(`Empty Water Refilling Stations! | status: 200`);
            return res.status(200).json({ message: "Empty Water Refilling Stations!" });
        }
        
        res.status(200).json({ message: "Successfully retrieved Water Refilling Station!", data: result });
        Logs.http(`Response being sent: Successfully retrieved Water Refilling Station!`);
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

/**
 * POST /get-wrs-details
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
router.post('/get-wrs-datails', async(req, res) => {
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
        
        res.status(200).json({ message: "Successfully retrieved Water Refilling Station Details!", data: result });
        Logs.http(`Response being sent: Successfully retrieved Water Refilling Station Details!`);
    }
    catch(error) {
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
            return res.status(404).json({ message: "Order doesn't Exists!" });
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

module.exports = router;