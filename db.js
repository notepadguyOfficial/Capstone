const { Pool } = require('pg');
const Logs = require('./Logs');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

pool.on('connect', () => Logs.database('A new client has connected.'));
pool.on('remove', () => Logs.database('A client has been removed.'));
pool.on('error', (error) => Logs.error(`An Error has Occured. More Details: ${error}`));

const Connect = async(channels = []) => {
    const client = await pool.connect();

    try {
        Logs.database('Database connected successfully.');

        for(const channel of channels) {
            await client.query(`LISTEN ${channel}`);
            Logs.database(`Listening to ${channel} channel`);
        }

        client.on('notification', (message) => {
            Logs.database(`Received notification on channel ${msg.channel}: ${msg.payload}`);

            //ToDo:
            // handle notification payload to send to clients

        });
    }
    catch(error) {
        Logs.critical(`Failed to connect to the database: ${error}`);
        process.exit(1);
    }
    
    return client;
};

const Stop = async(channel) => {
    const client = new pool.connect();

    try {
        await client.query(`UNLISTEN ${channel}`);
        Logs.database(`Stopped listening to ${channel} channel`);
        client.release();
    }
    catch(error) {
        Logs.error(`Error stopping the listener on ${channel}: ${error}`);
        client.release();
    }
};

module.exports = {
    pool,
    Connect,
    Stop
}