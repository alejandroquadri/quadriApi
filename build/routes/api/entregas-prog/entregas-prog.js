'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var google = require('googleapis');
var authentication = require("../../../googleApi");

var router = _express2.default.Router();

router.get('/', function (req, res, next) {
	authentication.authenticate().then(function (auth) {
		var sheets = google.sheets('v4');
		sheets.spreadsheets.values.get({
			auth: auth,
			spreadsheetId: '1K6oG_mpR2Cb8YXtTw3LjVg0T0QnSscoHhYWB8xz8Ph0',
			range: 'Programador!A1:AZ'
			// spreadsheetId: '1CrCwSy37MHjg_arblsO6lAdhQFW9GhxN0U-se2SYQVQ',
			// range: 'Hoja 1!A1:10', //Change Sheet1 if your worksheet's name is something else
		}, function (error, response) {
			if (error) {
				console.log('error en funcion google', error);
				return next(error);
			}
			res.status(200).json({
				status: 'success',
				message: 'Data from SS',
				data: response.values
			});
		});
	});
});

module.exports = router;