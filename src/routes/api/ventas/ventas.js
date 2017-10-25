const router = require('express').Router();
import { db } from '../../../db';
import { sql } from '../../../dbHelper';
const moment = require("moment");

const facturacionSQL = sql(__dirname, './facturacion.sql');

// const today = moment(new Date());
const today = moment();
let hasta = today.format('YYYYMMDD');
let desde = today.subtract(6, 'months').format('YYYYMMDD');

router.get('/', function(req, res, next) {
 db.any(facturacionSQL, {fechaDesde:desde, fechaHasta:hasta })
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