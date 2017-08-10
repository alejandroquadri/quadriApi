var router = require('express').Router();

console.log('llega');

router.use('/api', require('./api'));

// var db = require('./queries'); // lo saco, del anterior

/* GET home page. */
// router.get('/', function(req, res, next) {
//   res.render('index', { title: 'Quadri' });
// });

// router.get('/api/prueba', db.prueba); 	// lo saco, del anterior
// router.get('/api/facturacion', db.facturacion); 	// lo saco, del anterior


module.exports = router;
