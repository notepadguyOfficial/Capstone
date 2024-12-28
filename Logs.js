const winston = require('winston');
const fs = require('fs');
const path = require('path');
const DailyRotateFile = require('winston-daily-rotate-file');

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

const directory = path.join(__dirname, 'Logs');
if (!fs.existsSync(directory)) {
    fs.mkdirSync(directory);
}

const filter = (level) => winston.format((info) => {
    if (info.level === level
        || (Array.isArray(level)
        && level.includes(info.level))) {
        return info;
    }
    return false;
})();

const INFO = new DailyRotateFile({
    filename: path.join(directory, 'App_%DATE%.log'),
    datePattern: 'YYYY-MM-DD',
    zippedArchive: true,
    maxSize: '20m',
    maxFiles: '14d',
    handleExceptions: true,
    humanReadableUnhandledException: true,
    level: 'debug',
    format: winston.format.combine(
        filter(['alert', 'debug', 'verbose', 'info']),
        winston.format.timestamp({
            format: 'YYYY-MM-DD hh:mm:ss.SSS A',
        }),
        winston.format.align(),
        winston.format.printf(
            (info) => `[${info.level}] [${info.timestamp}]: ${info.message}`
        )
    ),
});

const ERROR = new DailyRotateFile({
    filename: path.join(directory, 'Error_%DATE%.log'),
    datePattern: 'YYYY-MM-DD',
    zippedArchive: true,
    maxSize: '20m',
    maxFiles: '14d',
    handleExceptions: true,
    humanReadableUnhandledException: true,
    level: 'error',
    format: winston.format.combine(
        filter(['critical', 'warn', 'error']),
        winston.format.timestamp({
            format: 'YYYY-MM-DD hh:mm:ss.SSS A',
        }),
        winston.format.align(),
        winston.format.printf(
            (info) => `[${info.level}] [${info.timestamp}]: ${info.message}`
        )
    ),
});

const DATABASE = new DailyRotateFile({
    filename: path.join(directory, 'DB_%DATE%.log'),
    datePattern: 'YYYY-MM-DD',
    zippedArchive: true,
    maxSize: '20m',
    maxFiles: '14d',
    handleExceptions: true,
    humanReadableUnhandledException: true,
    level: 'database',
    format: winston.format.combine(
        filter('database'),
        winston.format.timestamp({
            format: 'YYYY-MM-DD hh:mm:ss.SSS A',
        }),
        winston.format.align(),
        winston.format.printf(
            (info) => `[${info.level}] [${info.timestamp}]: ${info.message}`
        )
    ),
    silent: false,
});

const HTTP = new DailyRotateFile({
    filename: path.join(directory, 'HTTP_%DATE%.log'),
    datePattern: 'YYYY-MM-DD',
    zippedArchive: true,
    maxSize: '20m',
    maxFiles: '14d',
    handleExceptions: true,
    humanReadableUnhandledException: true,
    level: 'http',
    format: winston.format.combine(
        filter('http'),
        winston.format.timestamp({
            format: 'YYYY-MM-DD hh:mm:ss.SSS A',
        }),
        winston.format.align(),
        winston.format.printf(
            (info) => `[${info.level}] [${info.timestamp}]: ${info.message}`
        )
    ),
    silent: false,
});

const Logs = winston.createLogger({
    levels: LOG_LEVEL.levels,
    level: 'database',
    transports: [
        new winston.transports.Console({
            format: winston.format.combine(
                winston.format.colorize({ all: true }),
                winston.format.timestamp({
                    format: 'YYYY-MM-DD hh:mm:ss.SSS A',
                }),
                winston.format.align(),
                winston.format.printf(
                    (info) => `[${info.level}] [${info.timestamp}]: ${info.message}`
                )
            ),
        }),
        INFO,
        ERROR,
        DATABASE,
        HTTP
    ],
});

module.exports = Logs;
