var router = require('express').Router();

console.log('llega api index reload');

router.use('/ventas', require('./ventas/ventas'));
router.use('/despachos', require('./despachos/despachos'));

module.exports = router;