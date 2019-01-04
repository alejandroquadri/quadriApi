'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _db = require('../../../db');

var _moment = require('moment');

var _moment2 = _interopRequireDefault(_moment);

var _dbHelper = require('../../../dbHelper');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var router = _express2.default.Router();

var stockSQL = (0, _dbHelper.sql)(__dirname, './stock.sql');

router.get('/', function (req, res, next) {
  var today = (0, _moment2.default)();
  var hasta = today.format('YYYYMMDD');
  var desde = today.subtract(6, 'months').format('YYYYMMDD');
  _db.db.any(stockSQL, { fechaDesde: desde, fechaHasta: hasta }).then(function (data) {
    res.status(200).json({
      status: 'success',
      data: data,
      message: 'Retrieved sales'
    });
  }).catch(function (err) {
    return next(err);
  });
});

module.exports = router;