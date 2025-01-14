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

function SecretKey(size, encoding) {
    return crypto.randomBytes(size).toString(encoding);
}

function GenerateToken(id, type) {
    const payload = {id, type};
    return jwt.sign(payload, SecretKey(32, 'hex'), {expiresIn: '1h'});
}

module.exports = {
    type_enum,
    GenerateToken,
    channels
}