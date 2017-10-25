import express from 'express';
import { db } from '../../../db';
import { sql } from '../../../dbHelper';
import moment from 'moment';

const router = express.Router();

const despachosSQL = sql(__dirname, './remitos.sql');

const today = moment();
let hasta = today.format('YYYYMMDD');
let desde = today.subtract(6, 'months').format('YYYYMMDD');

router.get('/', function(req, res, next) {
 db.any(despachosSQL, {fechaDesde:desde, fechaHasta:hasta })
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved despachos'
        });
    })
    .catch(function (err) {
      return next(err);
    });
});

module.exports = router;