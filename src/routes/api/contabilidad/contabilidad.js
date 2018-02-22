const router = require('express').Router();
import { db } from '../../../db';
import { sql } from '../../../dbHelper';
const moment = require("moment");

const ivaVentas = sql(__dirname, './iva-ventas.sql');
const ivaCompras = sql(__dirname, './iva-compras.sql');

router.get('/ivaventas/:start/:end', function(req, res, next) {
  let start = req.params.start;
  let finish = req.params.end;

  let today = moment();
  let hasta = today.format(finish);
  let desde = today.format(start);  

  db.any(ivaVentas, {fechaDesde:desde, fechaHasta:hasta })
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved iva ventas'
      });
  })
  .catch(function (err) {
    return next(err);
  });
});

router.get('/ivacompras/:start/:end', function(req, res, next) {
  let start = req.params.start;
  let finish = req.params.end;

  let today = moment();
  let hasta = today.format(finish);
  let desde = today.format(start);  

  db.any(ivaCompras, {fechaDesde:desde, fechaHasta:hasta })
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'Retrieved iva compras'
      });
  })
  .catch(function (err) {
    return next(err);
  });
});

module.exports = router;