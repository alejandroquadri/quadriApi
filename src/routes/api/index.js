var router = require('express').Router();

router.get('/', (req, res) => {
  res.status(200).send('API Quadri').end();
});
router.use('/ventas', require('./ventas/ventas'));
router.use('/despachos', require('./despachos/despachos'));
router.use('/stock', require('./stock/stock'));
router.use('/np', require('./npPendientes/npPendientes'));
router.use('/entregas', require('./entregas-prog/entregas-prog'));
router.use('/finanzas', require('./finanzas/finanzas'));
router.use('/contabilidad', require('./contabilidad/contabilidad'));

module.exports = router;