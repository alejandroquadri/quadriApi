'use strict';

var _db = require('../../../db');

var _dbHelper = require('../../../dbHelper');

var router = require('express').Router();

var moment = require("moment");
var google = require('googleapis');
var authentication = require("../../../googleApi");

var facturacionSQLOk = (0, _dbHelper.sql)(__dirname, './facturacion.sql');
var psp = (0, _dbHelper.sql)(__dirname, './presupuestos.sql');
var docs = (0, _dbHelper.sql)(__dirname, './docsVtas.sql');
var precios = (0, _dbHelper.sql)(__dirname, './lista-precios-stock.sql');

router.get('/', function (req, res, next) {
  var today = moment();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(facturacionSQLOk, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
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
  var start = req.params.start;
  var finish = req.params.end;
  console.log(start, finish);
  var today = moment();
  var hasta = today.format(finish);
  var desde = today.format(start);
  // let desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(facturacionSQLOk, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
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

router.get('/objetivos', function (req, res, next) {
  authentication.authenticate().then(function (auth) {
    var sheets = google.sheets('v4');
    sheets.spreadsheets.values.get({
      auth: auth,
      spreadsheetId: '1pQvRE_o81Td4w9c6ZRf1lot5GzAv_WPVv7XXrUgyAxM',
      range: 'ObjComisiones!C1:C2'
    }, function (error, response) {
      if (error) {
        console.log('error en funcion google', error);
        return next(error);
      }
      res.status(200).json({
        status: 'success',
        message: 'Data from SS objectives',
        data: response.values
      });
    });
  });
});

module.exports = router;