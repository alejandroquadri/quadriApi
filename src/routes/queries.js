var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
// var connectionString = 'postgres://localhost:5432/puppies';
var connectionString = 'postgres://calipso:calipso@192.168.0.205:5432/Quadriprueba1';
var db = pgp(connectionString);

function prueba(req, res, next) {
  db.any('select * from trfacturaventa limit 10')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved sales'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function facturacion(req, res, next) {
  db.any('select * from trfacturaventa limit 10')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved sales'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

// add query functions

module.exports = {
  prueba: prueba,
  facturacion: facturacion
};

// connection string
// postgres://username:password@host:port/database?ssl=false&application_name=name
// &fallback_application_name=name&client_encoding=encoding