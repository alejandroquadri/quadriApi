var router = require('express').Router();
var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
var connectionString = 'postgres://calipso:calipso@192.168.0.205:5432/Quadriprueba1';
var db = pgp(connectionString);

router.get('/facturacion', function(req, res, next) {
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
});

console.log('llega api ventas');

// router.use('/ventas', require('./ventas'));

router.get('/pruebaVentas', function(req, res, next) {
  res.send("Hi to all from ventas");
});

module.exports = router;