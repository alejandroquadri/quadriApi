const router = require('express').Router();
// const db = require('../../db');
// import * as db from '../../db';
import { db, pgp } from '../../../db';

const path = require('path');

// Helper for linking to external query files:
function sql(file) {
    const fullPath = path.join(__dirname, file);
    return new pgp.QueryFile(fullPath, {minify: true});
}

const facturacion = sql('./facturacion.sql');

router.get('/facturacion', function(req, res, next) {
	// db.any(`
 //    select * from trfacturaventa 
 //    limit 10
 //    `)
 db.any(facturacion, {q:10})
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