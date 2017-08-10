const promise = require('bluebird');

const options = {
  // Initialization Options
  promiseLib: promise
};

const pgp = require('pg-promise')(options);

const config = {
    host: '192.168.0.205',
    port: 5432,
    database: 'quadriBD',
    user: 'calipso',
    password: 'calipso'
};

// !! lo de abajo es si usara un connectionString en lugar del objeto de arriba
// const connectionString = 'postgres://calipso:calipso@192.168.0.205:5432/Quadriprueba1';


const db = pgp(config);

module.exports = {
    pgp, db
};