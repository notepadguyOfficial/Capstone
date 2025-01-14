const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const os = require('os');
const axios = require('axios');
const WebSocket = require('ws');
const Logs = require('./utils/Logs');
const { db, Connect, Stop } = require('./config/database');
const { type_enum, GenerateToken, channels } = require('./utils/lib');
const cors = require('cors');

const port = 3000;

const app = express();
const sockets = new WebSocket.Server({ noServer: true });

app.use(cors());

app.use(bodyParser.json());

app.use((req, res, next) => {
    Logs.http(`${req.method} ${req.url}`);
    next();
});

sockets.on('connection', (socket) => {
    Logs.http('WebSocket client connected.');

    pool.on('notification', (msg) => {
        Logs.http(`Received notification on channel ${msg.channel}: ${msg.payload}`);
        socket.send(msg.payload);
    });

    socket.on('close', async() => {
        Logs.http('WebSocket client disconnected.');

        if(sockets.clients.size === 0) {
            await Stop([channels]);
            Logs.http('Stopped listening to PostgreSQL because no clients are connected.');
        }
    });
});

app.post('/register', async (req, res) => {
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
            requiredFields: ['fname', 'lname', 'address', 'phone', 'gender', 'username', 'password', 'long', 'lang'],
            table: 'Customer',
            data: {
                customer_fname: fname,
                customer_lname: lname,
                customer_phone_num: phone,
                customer_address: address,
                customer_gender: gender,
                customer_username: username,
                customer_password: null, // Placeholder for hashed password
                customer_address_long: long,
                customer_address_lat: lang,
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


app.post('/login', async(req, res) => {
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
        return res.status(400).json({
            error: 'All Fields are require!'
        });
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
                table = 'app_owner';
                field = 'app_owner_id';
                pass = 'app_owner_password';
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

app.post('/logout', async(req, res) => {
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

/**
 * Starts the application server and logs the local and public host information.
 *
 * @param {number} port - The port number on which the server will listen.
 * @returns {Promise<void>} A promise that resolves when the server is successfully started.
 *
 * @example
 * app.listen(3000, async () => {
 *     // Server is running on port 3000
 * });
 *
 * @function localhost
 * @returns {string|null} The local IPv4 address of the machine, or null if not found.
 *
 * @function public
 * @returns {Promise<string|null>} A promise that resolves to the public IP address of the machine, or null if an error occurs.
 *
 * @async
 * @throws {Error} If there is an error while fetching the public IP address.
 *
 * Logs the following information:
 * - Local Host: The local IPv4 address of the machine.
 * - Public Host: The public IP address fetched from the ipify API.
 * - Port: The port number on which the server is listening.
 *
 * @example
 * Logs.info(`Local Host: ${localhost()}`);
 * Logs.info(`Public Host: ${publichost}`);
 * Logs.info(`Port: ${port}`);
 *
 * @async
 * @function Connect
 * @param {Array} channels - An array of channels to connect to.
 * @returns {Promise<void>} A promise that resolves when the connection is established.
 */
app.listen(port, async() => {
    const localhost = () => {
        const network = os.networkInterfaces();
        for(let name in network) {
            for(let address of network[name]) {
                if(address.family == 'IPv4' && !address.internal) {
                    return address.address;
                }
            }
        }
    };

    const public = async() => {
        try {
            const response = await axios.get('https://api.ipify.org?format=json');
            return response.data.ip;
        }
        catch(error) {
            console.error(`Error getting Public Host: ${error}` );
            return null;
        }
    };

    const publichost = await public();

    Logs.info(`Local Host: ${localhost()}` );
    Logs.info(`Public Host: ${publichost}` );
    Logs.info(`Port: ${port}` );

    await Connect(channels);
});