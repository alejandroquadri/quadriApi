import { db } from '../../../db';
import { sql } from '../../../dbHelper';
const router = require('express').Router();
const moment = require('moment');

const facturacion = sql(__dirname, './facturacion.sql');
const psp = sql(__dirname, './presupuestos.sql')
const docs = sql(__dirname, './docsVtas.sql')
const precios = sql(__dirname, './lista-precios-stock.sql')
const docsImp = sql(__dirname, './docs-imp.sql')

router.get('/', function(req, res, next) {
  let today = moment()
  let hasta = today.format('YYYYMMDD')
  let desde = today.subtract(6, 'months').format('YYYYMMDD')
  db.any(facturacion, { fechaDesde: desde, fechaHasta: hasta })
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved sales'
      })
    })
    .catch(function (err) {
    return next(err);
    })
})

router.get('/facturacion/:start/:end', function(req, res, next) {
  // cambio
  let start = req.params.start;
  let finish = req.params.end;
  // console.log(start, finish);
  let today = moment();
  let hasta = today.format(finish);
  let desde = today.format(start);  
  // let desde = today.subtract(6, 'months').format('YYYYMMDD');
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

router.get('/psp', function(req, res, next) {
  let today = moment();
  let hasta = today.format('YYYYMMDD');
  let desde = today.subtract(12, 'months').format('YYYYMMDD');
  db.any(psp, {fechaDesde:desde, fechaHasta:hasta })
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

router.get('/docs', function(req, res, next) {
  let today = moment();
  let hasta = today.format('YYYYMMDD');
  let desde = today.subtract(6, 'months').format('YYYYMMDD');
  db.any(docs, {fechaDesde:desde, fechaHasta:hasta })
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved docs'
      });
  })
  .catch(function (err) {
    return next(err);
  });
});

router.get('/precios', function(req, res, next) {
  db.any(precios)
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved precios'
      });
  })
  .catch(function (err) {
    return next(err);
  });
});

router.get('/docs-imp', function(req, res, next) {
  console.log('llega a la consulta');
  db.any(docsImp)
  .then(function (data) {
    console.log('vuelve de db');
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved docs'
      });
  })
  .catch(function (err) {
    console.log('error en db', err);
    return next(err);
  });
});

module.exports = router
