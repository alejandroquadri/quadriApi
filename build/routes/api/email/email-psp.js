'use strict';

var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _moment = require('moment');

var _moment2 = _interopRequireDefault(_moment);

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _handlebars = require('handlebars');

var _handlebars2 = _interopRequireDefault(_handlebars);

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

  var pspData = req.body;
  var date = (0, _moment2.default)(pspData.date, "YYYY/MM/DD").format('DD/MM/YYYY');

  var iibb = void 0;
  pspData.iibb === 0 ? iibb = '0' : iibb = decimal(Number(pspData.iibb), 0);

  var psp = {
    to: pspData.to,
    cc: pspData.cc,
    number: pspData.number,
    obs: pspData.obs,
    razSoc: pspData.razSoc,
    date: date,
    salesRep: pspData.salesRep,
    total: decimal(Number(pspData.total), 0),
    iva: decimal(Number(pspData.iva), 0),
    iibb: iibb,
    final: decimal(Number(pspData.final), 0),
    payment: pspData.items[0].tipo_pago
  };

  var items = '';

  for (var i = 0; i < pspData.items.length; i++) {
    var item = htmlItem(pspData.items[i]);
    items += item;
  }
  psp['items'] = items;

  _fs2.default.readFile(__dirname + '/psp-email.html', 'utf8', function (err, data) {
    if (err) {
      console.log('error desdpues del fs', err);
      return;
    }

    var template = _handlebars2.default.compile(data);
    var JSresult = template(psp);

    styliner.processHTML(JSresult).then(function (processedSource) {

      var mailOptions = {
        from: '"Quadri" <' + pspData.currentEmail + '>',
        sender: pspData.currentEmail,
        replyTo: pspData.currentEmail,
        cc: [pspData.currentEmail, psp.cc || ''],
        to: psp.to,
        subject: 'Quadri - Presupuesto ' + psp.number,
        text: 'Version texto',
        html: processedSource
      };

      return mailTransport.sendMail(mailOptions).then(function () {
        console.log('Psp sent');
        res.status(200).json({
          html: processedSource
        });
      }).catch(function (error) {
        console.error('There was an error while sending the email:', error);
      });
    }).catch(function (reason) {
      console.log('error en styliner', reason);
    });
  });
});

function decimal(value, fractionSize) {
  // console.log('decimal',value, fractionSize);
  var DECIMAL_SEPARATOR = ".";
  var THOUSANDS_SEPARATOR = ",";
  var PADDING = "000000";

  if (value) {
    var _toString$split = (value || "").toString().split(DECIMAL_SEPARATOR),
        _toString$split2 = _slicedToArray(_toString$split, 2),
        integer = _toString$split2[0],
        _toString$split2$ = _toString$split2[1],
        fraction = _toString$split2$ === undefined ? "" : _toString$split2$;

    fraction = fractionSize > 0 ? DECIMAL_SEPARATOR + (fraction + PADDING).substring(0, fractionSize) : "";

    integer = integer.replace(/\B(?=(\d{3})+(?!\d))/g, THOUSANDS_SEPARATOR);
    return integer + fraction;
  }
}

function htmlItem(item) {
  var bonificacion = void 0,
      prBon = void 0;
  if (Number(item.importe_bonificado) !== 0) {
    bonificacion = item.importe_bonificado / (item.cantidad * item.precio);
    prBon = item.precio * (1 - bonificacion);
  } else {
    bonificacion = 0;
    prBon = item.precio;
  }

  var itemRow = '\n  <tr>\n    <td style="width: 220px;">\n      ' + item.conceptocomercial + '\n    </td>\n    <td align="center">\n      ' + decimal(item.cantidad, 2) + '\n    </td>\n    <td align="center">\n      ' + item.unidad + '\n    </td>\n    <td align="center">\n      ' + decimal(item.precio, 1) + '\n    </td>\n    <td align="center">\n      ' + (decimal(bonificacion * 100, 1) || 0) + ' %\n    </td>\n    <td align="center">\n      ' + decimal(prBon, 1) + '\n    </td>\n    <td align="center">\n      ' + decimal(item.total_importe, 0) + '\n    </td>\n  </tr>\n  ';
  return itemRow;
}

module.exports = router;