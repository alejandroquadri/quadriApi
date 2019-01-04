'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var google = require('googleapis');
var authentication = require("../../googleApi");

var router = _express2.default.Router();

router.get('/get-link', function (req, res, next) {
  console.log('llega');
  var url = authentication.getLink().then(function (url) {
    res.status(200).send('el link es ' + url).end();
  });
});

router.get('/paste-link', function (req, res, next) {
  var code = req.query.code;
  console.log('el codigo es', code);
  authentication.getTokenManually(code).then(function (auth) {
    res.status(200).send('autorizado ' + auth).end();
  });
});

module.exports = router;