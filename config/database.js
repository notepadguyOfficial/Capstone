const knex = require('knex');
const Logs = require('../utils/Logs');

require('dotenv').config();

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