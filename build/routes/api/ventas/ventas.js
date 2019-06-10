'use strict';

var _db = require('../../../db');

var _dbHelper = require('../../../dbHelper');

var router = require('express').Router();
var moment = require('moment');

var facturacion = (0, _dbHelper.sql)(__dirname, './facturacion.sql');
var psp = (0, _dbHelper.sql)(__dirname, './presupuestos.sql');
var docs = (0, _dbHelper.sql)(__dirname, './docsVtas.sql');
var precios = (0, _dbHelper.sql)(__dirname, './lista-precios-stock.sql');
var docsImp = (0, _dbHelper.sql)(__dirname, './docs-imp.sql');
var citiVentas = (0, _dbHelper.sql)(__dirname, './citi-ventas.sql');

router.get('/', function (req, res, next) {
  var today = moment();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(facturacion, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved sales'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/facturacion/:start/:end', function (req, res, next) {
  // cambio
  var start = req.params.start;
  var finish = req.params.end;
  // console.log(start, finish);
  var today = moment();
  var hasta = today.format(finish);
  var desde = today.format(start);
  // let desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(facturacion, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved sales'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/psp', function (req, res, next) {
  var today = moment();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(12, 'months').format('YYYYMMDD');
  _db.db.any(psp, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved sales'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/docs', function (req, res, next) {
  var today = moment();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(docs, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved docs'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/precios', function (req, res, next) {
  _db.db.any(precios).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved precios'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/docs-imp', function (req, res, next) {
  console.log('llega a la consulta');
  _db.db.any(docsImp).then(function (data) {
    console.log('vuelve de db');
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved docs'
    });
  }).catch(function (err) {
    console.log('error en db', err);
    return next(err);
  });
});

router.get('/citi-ventas/:month', function (req, res, next) {

  var dateMonth = moment(req.params.month);
  var hasta = dateMonth.endOf('month').format('YYYYMMDD');
  var desde = dateMonth.startOf('month').format('YYYYMMDD');

  _db.db.any(citiVentas, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved citi ventas data'
    });
  }).catch(function (err) {
    return next(err);
  });
});

module.exports = router;