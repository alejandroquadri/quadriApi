'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _db = require('../../../db');

var _dbHelper = require('../../../dbHelper');

var _moment = require('moment');

var _moment2 = _interopRequireDefault(_moment);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var router = _express2.default.Router();

var balanceSQL = (0, _dbHelper.sql)(__dirname, './balance.sql');
var resultadosSQL = (0, _dbHelper.sql)(__dirname, './resultados.sql');
var resultadosExtSQL = (0, _dbHelper.sql)(__dirname, './resultadosExtended.sql');

router.get('/balance', function (req, res, next) {
  var today = (0, _moment2.default)();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(12, 'months').format('YYYYMMDD');
  _db.db.any(balanceSQL, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved sales'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/balanceFecha/:fechaHasta', function (req, res, next) {
  var today = (0, _moment2.default)();
  var hasta = (0, _moment2.default)(req.params.fechaHasta).format('YYYYMMDD');
  console.log('fecha hasta', hasta);
  var desde = today.subtract(12, 'months').format('YYYYMMDD');

  _db.db.any(balanceSQL, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved balance'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/resultados', function (req, res, next) {
  var today = (0, _moment2.default)();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(12, 'months').format('YYYYMMDD');
  _db.db.any(resultadosSQL, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved resultados'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/resultadosExt', function (req, res, next) {
  var today = (0, _moment2.default)();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(12, 'months').format('YYYYMMDD');
  _db.db.any(resultadosExtSQL, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved resultados ext'
    });
  }).catch(function (err) {
    return next(err);
  });
});

module.exports = router;