const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const os = require('os');
const axios = require('axios');
const WebSocket = require('ws');
const Logs = require('./utils/Logs');
const { type_enum, GenerateToken, channels } = require('./utils/lib');
const cors = require('cors');
const routes = require('./endpoints/routes.js');
require('dotenv').config();

// const port = 3000;
const port = process.env.SERVER_PORT;

const app = express();
const sockets = new WebSocket.Server({ noServer: true });

app.use(cors());

app.use(bodyParser.json());

/**
 * Middleware function to log HTTP requests.
 * 
 * @param {Object} req - The request object.
 * @param {string} req.method - The HTTP method of the request.
 * @param {string} req.url - The URL of the request.
 * @param {Object} res - The response object.
 * @param {function} next - The next middleware function in the application's request-response cycle.
 * @returns {void}
 */
app.use((req, res, next) => {
    Logs.http(`${req.method} ${req.url}`);
    next();
});

/**
 * Handles WebSocket connections and manages notifications from PostgreSQL.
 * 
 * @param {WebSocket} socket - The WebSocket connection object.
 * @returns {void}
 * 
 * @listens WebSocket#connection
 * @listens pool#notification
 * @listens WebSocket#close
 * 
 * @description
 * This function sets up event listeners for WebSocket connections. It logs when a client
 * connects, forwards PostgreSQL notifications to the client, and handles client disconnections.
 * When all clients disconnect, it stops listening to PostgreSQL channels.
 */
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

app.use('/', routes);

// #region Main Entry Point
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

// #endregion