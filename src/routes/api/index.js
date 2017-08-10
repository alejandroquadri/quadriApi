var router = require('express').Router();

console.log('llega api index reload');

router.use('/ventas', require('./ventas'));

module.exports = router;