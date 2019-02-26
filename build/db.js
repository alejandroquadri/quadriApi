'use strict';

var promise = require('bluebird');

var options = {
    // Initialization Options
    promiseLib: promise
};

var pgp = require('pg-promise')(options);

// const config = {
//     host: '192.168.0.205',
//     port: 5432,
//     database: 'QUADRIBDN',
//     user: 'calipso',
//     password: 'calipso'
// };

var config = {
    host: 'quadriserver.ddns.net',
    port: 5432,
    database: 'QUADRIBDN',
    user: 'calipso',
    password: 'calipso'
};

// !! lo de abajo es si usara un connectionString en lugar del objeto de arriba
// const connectionString = 'postgres://calipso:calipso@192.168.0.205:5432/Quadriprueba1';
// const config = 'postgres://calipso:calipso@quadriserver.ddns.net:5432/QUADRIBDN';


var db = pgp(config);

module.exports = {
    pgp: pgp, db: db
};