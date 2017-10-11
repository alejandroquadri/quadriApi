var router = require('express').Router();

router.use('/ventas', require('./ventas/ventas'));
router.use('/despachos', require('./despachos/despachos'));
router.use('/stock', require('./stock/stock'));
router.use('/np', require('./npPendientes/npPendientes'));
router.use('/entregas', require('./entregas-prog/entregas-prog'));
router.use('/finanzas', require('./finanzas/finanzas'));

module.exports = router;