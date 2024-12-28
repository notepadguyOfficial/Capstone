const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const type_enum = [
    'Customer',
    'Owner',
    'Staff'
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

function SecretKey(size, type) {
    return crypto.randomBytes(size).toString(type);
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