'use strict';

var _db = require('../../../db');

var _dbHelper = require('../../../dbHelper');

var router = require('express').Router();

var moment = require("moment");

var ivaVentas = (0, _dbHelper.sql)(__dirname, './iva-ventas.sql');
var ivaCompras = (0, _dbHelper.sql)(__dirname, './iva-compras.sql');

router.get('/ivaventas/:start/:end', function (req, res, next) {
  var start = req.params.start;
  var finish = req.params.end;

  var today = moment();
  var hasta = today.format(finish);
  var desde = today.format(start);

  _db.db.any(ivaVentas, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved iva ventas'
    });
  }).catch(function (err) {
    return next(err);
  });
});

router.get('/ivacompras/:start/:end', function (req, res, next) {
  var start = req.params.start;
  var finish = req.params.end;

  var today = moment();
  var hasta = today.format(finish);
  var desde = today.format(start);

  _db.db.any(ivaCompras, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved iva compras'
    });
  }).catch(function (err) {
    return next(err);
  });
});

module.exports = router;