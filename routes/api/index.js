var router = require('express').Router();

console.log('llega api index');

router.use('/ventas', require('./ventas'));

module.exports = router;