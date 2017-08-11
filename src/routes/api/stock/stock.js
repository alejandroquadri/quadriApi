import express from 'express';
import { db } from '../../../db';
import moment from 'moment';
import { sql } from '../../../dbHelper';

const router = express.Router();

const stockSQL = sql(__dirname, './stock.sql');

const today = moment(new Date());
let hasta = today.format('YYYYMMDD');
let desde = today.subtract(6, 'months').format('YYYYMMDD');

router.get('/', function(req, res, next) {
 db.any(stockSQL, {fechaDesde:desde, fechaHasta:hasta })
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