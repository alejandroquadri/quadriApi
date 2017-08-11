var router = require('express').Router();

router.use('/ventas', require('./ventas/ventas'));
router.use('/despachos', require('./despachos/despachos'));
router.use('/stock', require('./stock/stock'));

module.exports = router;