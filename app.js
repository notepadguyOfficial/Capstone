const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const os = require('os');
const axios = require('axios');
const WebSocket = require('ws');
const Logs = require('./Logs');
const { Connect, pool, Stop } = require('./db');
const { type_enum, GenerateToken, SecretKey, channels } = require('./lib');
const cors = require('cors');
const { createSecretKey } = require('crypto');

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

app.post('/register', async(req, res) => {
    Logs.http('Recieved POST request to /register' );
    Logs.http(`Request Body: ${req.body}` );
    Logs.http(`Request headers: ${req.headers}` );
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}` );

    const { fname, lname, address, phone, gender, username, password, long, lang, type } = req.body;

    if(!fname
        || !lname
        || !address
        || !phone
        || !gender
        || !username
        || !password
        || !long
        || !lang
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
        const hash = await bcrypt.hash(password, 10);

        let query, data, user;

        switch(type) {
            case 1: // Customer
                query = 'INSERT INTO public."Customer" (customer_fname, customer_lname, customer_phone_num, customer_address, customer_gender, customer_username, customer_password, customer_address_long, customer_address_lat) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING customer_id AS id';
                data = [fname, lname, phone, address, gender, username, hash, long, lang];
                break;
            case 2: // Owner
                query = "INSERT INTO public.station_owner (st_owner_fname, st_owner_lname, st_owner_phone_num, st_owner_gender, st_owner_username, st_owner_password) VALUES ($1, $2, $3, $4, $5, $6) RETURNING st_owner_id AS id";
                data = [fname, lname, phone, gender, username, hash];
                break;
            case 3: // Staff
                query = "INSERT INTO public.staff (staff_fname, staff_lname, staff_phone_num, staff_gender, staff_username, staff_password) VALUES ($1, $2, $3, $4, $5, $6) RETURNING staff_id AS id";
                data = [fname, lname, phone, gender, username, hash];
                break;
        }

        const result = await pool.query(query, data);

        user = result.rows[0];

        const token = GenerateToken(user.id, type);

        const tokenQuery = `
            INSERT INTO public.authentication (userid, token)
            VALUES ($1, $2)
            ON CONFLICT (userid) 
            DO UPDATE SET token = $2, created_at = CURRENT_TIMESTAMP
            RETURNING userid;
        `;

        await pool.query(tokenQuery, [user.id, token]);

        res.json({ message: 'User Registered Successfully!', token });
        Logs.http(`Response being sent: User Registered Successfully! User ID: ${user.id} | Token: ${token}` );
    } catch (error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

app.post('/login', async(req, res) => {
    Logs.http('Received POST request to /login');
    Logs.http(`Request Body: ${JSON.stringify(req.body)}`);
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

    Logs.debug(`Incoming Type: ${type}`);

    try {
        let query, user;

        switch(type) {
            case 0: // Admin
                query = "SELECT app_owner_id AS id, app_owner_password AS password FROM public.app_owner WHERE staff_username = $1";
                break;
            case 1: // Customer
                query = 'SELECT customer_id AS id, customer_password AS password FROM public."Customer" WHERE customer_username = $1';
                break;
            case 2: // Owner
                query = "SELECT st_owner_id AS id, st_owner_password AS password FROM public.station_owner WHERE st_owner_username = $1";
                break;
            case 3: // Staff
                query = "SELECT staff_id AS id, staff_password AS password FROM public.staff WHERE staff_username = $1";
                break;
        }

        const result = await pool.query(query, [username]);

        if(result.rows.length === 0) {
            Logs.error(`Response being sent: User not found! | status: 404`);
            return res.status(404).json({ error: 'User not found!' });
        }

        user = result.rows[0];

        const same = await bcrypt.compare(password, user.password);
        if(!same) {
            Logs.debug(`Response being sent: Invalid credentials! | status: 401`);
            return res.status(401).json({ error: 'Invalid credentials!' });
        }

        const token = GenerateToken(user.id, type);

        const tokenQuery = `
            INSERT INTO public.authentication (userid, token)
            VALUES ($1, $2)
            ON CONFLICT (userid) 
            DO UPDATE SET token = $2, created_at = CURRENT_TIMESTAMP
            RETURNING userid;
        `;

        await pool.query(tokenQuery, [user.id, token]);
        
        Logs.http(`Response being sent: Login successful for UserID: ${user.id} | Token: ${token}`);
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
    Logs.http(`Incoming Remote Address: ${req.ip || req.socket.remoteAddress}`);

    const { userid, token } = req.body;
    
    if(!userid || !token) {
        return res.status(400).json({ error: 'User ID and Token are required for logout' });
    }

    try {
        const query = "SELECT * FROM public.authentication WHERE userid = $1 AND token = $2";
        const result = await pool.query(query, [userid, token]);

        if(result.rows.length === 0) {
            Logs.error(`Response being sent: Invalid token! | status: 401`);
            return res.status(401).json({ error: 'Invalid token!' });
        }

        const deleteQuery = "DELETE FROM public.authentication WHERE userid = $1";
        await pool.query(deleteQuery, [userid]);

        Logs.http(`Response being sent: User logged out successfully for UserID: ${userid}`);
        res.json({ message: 'Logout successful!' });
    }
    catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

//testing
app.get('/test/:id', async(req, res) => {
    const id = req.params.id;

    try {
        let query = 'SELECT * FROM public."Customer"';
        const result = await pool.query(query);

        Logs.http(`Response being sent:  ${JSON.stringify(result.rows)}`);
        res.json({ message: result.rows });
    } catch(error) {
        res.status(500).json({ error: error.message });
        Logs.error(`Response being sent: ${error.message}`);
    }
});

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