'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _nodemailer = require('nodemailer');

var _nodemailer2 = _interopRequireDefault(_nodemailer);

var _styliner = require('styliner');

var _styliner2 = _interopRequireDefault(_styliner);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var router = _express2.default.Router();
var styliner = new _styliner2.default(__dirname);

var mailTransport = _nodemailer2.default.createTransport({
  service: 'gmail',
  auth: {
    user: 'presupuestos@quadri.com.ar',
    pass: 'Quadri384'
  }
});

router.post('/', function (req, res, next) {

  var consulta = req.body;
  var interest = void 0;
  consulta.interest ? interest = consulta.interest : interest = '';

  var mailOptions = {
    from: '"Presupuestos" <presupuestos@queo.com.ar>',
    to: "info@queo.com.ar",
    subject: 'Queo - Consulta ' + interest,
    text: consulta.name + ' - ' + consulta.email + ' - ' + consulta.telephone + '\n \n' + consulta.query
  };

  console.log(mailOptions);

  return mailTransport.sendMail(mailOptions).then(function () {
    console.log('Psp sent');
    res.status(200).send('query sent');
  }).catch(function (error) {
    console.error('There was an error while sending the email:', error);
  });
});

module.exports = router;