var express = require('express');
var router = express.Router();

var db = require('./queries');

/* GET home page. */
// router.get('/', function(req, res, next) {
//   res.render('index', { title: 'Quadri' });
// });

router.get('/api/prueba', db.prueba);
router.get('/api/facturacion', db.facturacion);


module.exports = router;
