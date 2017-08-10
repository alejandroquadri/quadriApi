const router = require('express').Router();
import { db, pgp } from '../../../db';
const moment = require("moment");

const path = require('path');

// Helper for linking to external query files:
function sql(file) {
    const fullPath = path.join(__dirname, file);
    return new pgp.QueryFile(fullPath, {minify: true});
}

const facturacion = sql('./remitos.sql');

const today = moment(new Date());
let hasta = today.format('YYYYMMDD');
let desde = today.subtract(6, 'months').format('YYYYMMDD');

router.get('/remitos', function(req, res, next) {
 db.any(facturacion, {fechaDesde:desde, fechaHasta:hasta })
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

module.exports = router;