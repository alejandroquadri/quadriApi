import express from 'express';
import { db } from '../../../db';
import { sql } from '../../../dbHelper';
import moment from 'moment';

const router = express.Router();

const balanceSQL = sql(__dirname, './balance.sql');
const resultadosSQL = sql(__dirname, './resultados.sql');

router.get('/balance', function(req, res, next) {
  const today = moment();
  let hasta = today.format('YYYYMMDD');
  let desde = today.subtract(12, 'months').format('YYYYMMDD');
  db.any(balanceSQL, {fechaDesde:desde, fechaHasta:hasta })
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

router.get('/balanceFecha/:fechaHasta', function(req, res, next) {
  const today = moment();
  let hasta = moment(req.params.fechaHasta).format('YYYYMMDD');
  let desde = today.subtract(12, 'months').format('YYYYMMDD');

  db.any(balanceSQL, {fechaDesde:desde, fechaHasta:hasta })
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

router.get('/resultados', function(req, res, next) {
  const today = moment();
  let hasta = today.format('YYYYMMDD');
  let desde = today.subtract(12, 'months').format('YYYYMMDD');
  db.any(resultadosSQL, {fechaDesde:desde, fechaHasta:hasta })
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