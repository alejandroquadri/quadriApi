'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _db = require('../../../db');

var _dbHelper = require('../../../dbHelper');

var _moment = require('moment');

var _moment2 = _interopRequireDefault(_moment);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var router = _express2.default.Router();

var npSQL = (0, _dbHelper.sql)(__dirname, './npPendientes.sql');

router.get('/', function (req, res, next) {
  _db.db.any(npSQL).then(function (data) {
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