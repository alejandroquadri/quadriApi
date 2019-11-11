const promise = require('bluebird');

const options = {
  // Initialization Options
  promiseLib: promise
};

const pgp = require('pg-promise')(options);

const config = {
    host: '192.168.0.205',
    port: 5432,
    database: 'QR20191108',
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


const db = pgp(config);

module.exports = {
    pgp, db
};