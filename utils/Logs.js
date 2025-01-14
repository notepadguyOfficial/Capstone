const winston = require('winston');
const fs = require('fs');
const path = require('path');
const DailyRotateFile = require('winston-daily-rotate-file');
require('dotenv').config();

const LOG_LEVEL = {
    levels: {
        error: 0,
        warn: 1,
        info: 2,
        http: 3,
        verbose: 4,
        debug: 5,
        critical: 6,
        alert: 7,
        database: 8
    },
    colors: {
        error: 'red',
        warn: 'red',
        info: 'green',
        http: 'blue',
        verbose: 'grey',
        debug: 'white',
        critical: 'yellow',
        alert: 'yellow',
        database: 'blue'
    },
};

winston.addColors(LOG_LEVEL.colors);

const DEFAULT_LOGS_PATH = path.join(__dirname, '../Logs');
const directory = process.env.LOGS_PATH && process.env.LOGS_PATH.trim() !== ''
    ? process.env.LOGS_PATH
    : DEFAULT_LOGS_PATH;

try {
    if (!fs.existsSync(directory)) {
        fs.mkdirSync(directory, { recursive: true });
    }
} 
catch(error) {
    console.error('Error creating log directory:', error);
}

/**
 * Creates a filter for log levels.
 * 
 * @param {string|string[]} levels - The log level(s) to filter.
 * @returns {Function} A winston format function that filters log messages based on the specified levels.
 */
const createFilter = (levels) =>
    winston.format((info) => {
        if (Array.isArray(levels) ? levels.includes(info.level) : info.level === levels) {
            return info;
        }
        return false;
    })();

/**
 * Combines multiple winston format functions into a single format function.
 * 
 * @type {Format}
 */
const formatter = winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD hh:mm:ss.SSS A' }),
    winston.format.align(),
    winston.format.printf((info) => `[${info.level}] [${info.timestamp}]: ${info.message}`)
);

/**
 * Creates a new DailyRotateFile transport for winston logger.
 * 
 * @param {string} filename - The base name of the log file.
 * @param {string} level - The log level for the transport.
 * @param {string|string[]} filtered - The log level(s) to filter.
 * @returns {DailyRotateFile} A new DailyRotateFile transport.
 */
const Transport = (filename, level, filtered) =>
    new DailyRotateFile({
        filename: path.join(directory, `${filename}_%DATE%.log`),
        datePattern: 'YYYY-MM-DD',
        zippedArchive: true,
        maxSize: '20m',
        maxFiles: '14d',
        level,
        format: winston.format.combine(createFilter(filtered), formatter),
    });

/**
 * Creates a new winston logger with specified levels and transports.
 * 
 * @type {Logger}
 */
const Logs = winston.createLogger({
    levels: LOG_LEVEL.levels,
    level: 'database',
    transports: [
        new winston.transports.Console({
            format: winston.format.combine(
                winston.format.colorize({ all: true }),
                formatter
            ),
        }),
        Transport('App', 'debug', ['alert', 'debug', 'verbose', 'info']),
        Transport('Error', 'error', ['critical', 'warn', 'error']),
        Transport('DB', 'database', 'database'),
        Transport('HTTP', 'http', 'http'),
    ],
});

module.exports = Logs;
