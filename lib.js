const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const type_enum = [
    0,
    1,
    2,
    3
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