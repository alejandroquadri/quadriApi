'use strict';

var router = require('express').Router();

router.get('/', function (req, res) {
  res.status(200).send('API Quadri').end();
});
router.use('/ventas', require('./ventas/ventas'));
router.use('/despachos', require('./despachos/despachos'));
router.use('/stock', require('./stock/stock'));
router.use('/np', require('./npPendientes/npPendientes'));
router.use('/entregas', require('./entregas-prog/entregas-prog'));
router.use('/finanzas', require('./finanzas/finanzas'));
router.use('/contabilidad', require('./contabilidad/contabilidad'));

router.use('/google-auth', require('./google-auth'));
router.use('/email', require('./email/email-psp'));
router.use('/query-quadri', require('./web/contact-quadri'));
router.use('/query-queo', require('./web/contact-queo'));

module.exports = router;