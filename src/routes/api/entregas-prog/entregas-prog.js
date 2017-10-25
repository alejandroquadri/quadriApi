import express from 'express';
let google = require('googleapis');
let authentication = require("../../../googleApi");

const router = express.Router();

router.get('/', function(req, res, next) {
	authentication.authenticate().then((auth)=>{
    var sheets = google.sheets('v4');
	  sheets.spreadsheets.values.get({
	    auth: auth,
	    spreadsheetId: '1K6oG_mpR2Cb8YXtTw3LjVg0T0QnSscoHhYWB8xz8Ph0',
      range: 'Programador!A1:AZ'
	    // spreadsheetId: '1CrCwSy37MHjg_arblsO6lAdhQFW9GhxN0U-se2SYQVQ',
	    // range: 'Hoja 1!A1:10', //Change Sheet1 if your worksheet's name is something else
	  }, (error, response) => {
	  	if (error) {
	  		console.log('error en funcion google', error);
	  		return next(error);
	    }
	  	res.status(200)
			.json({
		    status: 'success',
		    message: 'Data from SS',
		    data: response.values
		  });
	  });
	});
});

module.exports = router;

