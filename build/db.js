'use strict';

var promise = require('bluebird');

var options = {
    // Initialization Options
    promiseLib: promise
};

var pgp = require('pg-promise')(options);

var config = {
    host: '192.168.0.205',
    port: 5432,
    database: 'QP20190325',
    user: 'calipso',
    password: 'calipso'
};

// const config = {
//     host: '192.168.0.205',
//     port: 5432,
//     database: 'QUADRIBDN',
//     user: 'calipso',
//     password: 'calipso'
// };

// con direccion de bd desde internet
// const config = {
//     host: 'quadriserver.ddns.net',
//     port: 5432,
//     database: 'QUADRIBDN',
//     user: 'calipso',
//     password: 'calipso'
// };

// !! lo de abajo es si usara un connectionString en lugar del objeto de arriba
// const config = 'postgres://calipso:calipso@quadriserver.ddns.net:5432/Quadriprueba1';
// const config = 'postgres://calipso:calipso@quadriserver.ddns.net:5432/QUADRIBDN';


var db = pgp(config);

module.exports = {
    pgp: pgp, db: db
};