const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const type_enum = [
    0, //Admin
    1, //Customer
    2, //Water Refilling Owner
    3 // Staff
];

const channels = [
    'LOGIN',
    'REGISTER',
    'CUSTOMER',
    'PRODUCT',
    'STAFF',
    'OWNER',
    'REFILLINGSTATION',
    'SALES'
]

/**
 * Generates a random secret key using cryptographically strong pseudo-random data.
 * 
 * @param {number} size - The number of bytes to generate.
 * @param {string} encoding - The encoding to use for the output string (e.g., 'hex', 'base64').
 * @returns {string} A string representation of the generated secret key in the specified encoding.
 */
function SecretKey(size, encoding) {
    return crypto.randomBytes(size).toString(encoding);
}


/**
 * Generates a JSON Web Token (JWT) for authentication purposes.
 * 
 * @param {string|number} id - The unique identifier of the user.
 * @param {number} type - The user type, corresponding to the index in the type_enum array.
 * @returns {string} A signed JWT containing the user's id and type, valid for 1 hour.
 */
function GenerateToken(id, type) {
    const payload = {id, type};
    return jwt.sign(payload, SecretKey(32, 'hex'), {expiresIn: '1h'});
}


module.exports = {
    type_enum,
    GenerateToken,
    channels
}