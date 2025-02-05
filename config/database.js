const knex = require('knex');
const Logs = require('../utils/Logs');

require('dotenv').config();

/**
 * Initializes and configures a Knex database connection instance.
 * 
 * This function sets up a connection to a PostgreSQL database using environment variables
 * for connection details. It also configures a connection pool and sets up error logging
 * for new connections.
 *
 * @param {Object} config - The configuration object for Knex.
 * @param {string} config.client - The database client (set to 'pg' for PostgreSQL).
 * @param {Object} config.connection - Database connection parameters.
 * @param {string} config.connection.host - The database host (from environment variable DB_HOST).
 * @param {string} config.connection.user - The database user (from environment variable DB_USER).
 * @param {string} config.connection.password - The database password (from environment variable DB_PASSWORD).
 * @param {string} config.connection.database - The database name (from environment variable DB_NAME).
 * @param {number} config.connection.port - The database port (from environment variable DB_PORT).
 * @param {Object} config.pool - Connection pool configuration.
 * @param {number} config.pool.min - Minimum number of connections in the pool.
 * @param {number} config.pool.max - Maximum number of connections in the pool.
 * @param {Function} config.pool.afterCreate - Function to run after creating a new connection.
 * @returns {Object} A configured Knex instance connected to the specified database.
 */
const db = knex({
    client: 'pg',
    connection: {
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        port: process.env.DB_PORT,
    },
    pool: {
        min: 2,
        max: 10,
        afterCreate: (conn, done) => {
            Logs.database('A new client connection was established.');

            conn.on('error', (error) => Logs.error(`Connection error: ${error}`));

            done(null, conn);
        },
    },
});

db.withSchema('public');


/**
 * Establishes a connection to the database and sets up listeners for specified channels.
 * 
 * This function connects to the database, starts listening to the specified channels,
 * and sets up a notification listener. It logs the connection status and any received
 * notifications. If the connection fails, it logs a critical error and exits the process.
 *
 * @async
 * @param {string[]} [channels=[]] - An array of channel names to listen to.
 * @returns {Promise<void>} A promise that resolves when the connection is established
 *                          and listeners are set up.
 * @throws {Error} If there's an error connecting to the database or setting up listeners.
 */
const Connect = async (channels = []) => {
    try {
        Logs.database('Database connected successfully.');

        // Start listening to specified channels
        const listenPromises = channels.map(async (channel) => {
            await db.raw(`LISTEN ${channel}`);
            Logs.database(`Listening to ${channel} channel`);
        });

        await Promise.all(listenPromises);

        // Set up notification listener
        const client = await db.client.acquireConnection(); // Acquire a raw pg client
        client.on('notification', (msg) => {
            Logs.database(`Received notification on channel ${msg.channel}: ${msg.payload}`);

            // ToDo: Handle notification payload to send to clients
        });
        await db.client.releaseConnection(client); // Release the connection back to the pool
    } catch (error) {
        Logs.critical(`Failed to connect to the database: ${error}`);
        process.exit(1);
    }
};


/**
 * Stops listening to a specified database notification channel.
 * 
 * This function attempts to stop listening to the given channel by executing
 * an 'UNLISTEN' SQL command. It logs the success or failure of this operation.
 *
 * @async
 * @param {string} channel - The name of the channel to stop listening to.
 * @returns {Promise<void>} A promise that resolves when the operation is complete.
 *                          The function doesn't return any value directly.
 * @throws {Error} If there's an error while stopping the listener, it's caught
 *                 and logged, but not rethrown.
 */
const Stop = async (channel) => {
    try {
        await db.raw(`UNLISTEN ${channel}`);
        Logs.database(`Stopped listening to ${channel} channel`);
    } catch (error) {
        Logs.error(`Error stopping the listener on ${channel}: ${error}`);
    }
};

module.exports = {
    db,
    Connect,
    Stop,
};