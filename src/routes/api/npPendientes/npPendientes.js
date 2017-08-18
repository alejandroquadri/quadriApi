import express from 'express';
import { db } from '../../../db';
import { sql } from '../../../dbHelper';
import moment from 'moment';

const router = express.Router();

const npSQL = sql(__dirname, './npPendientes.sql');

router.get('/', function(req, res, next) {
 db.any(npSQL)
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved sales'
        });
    })
    .catch(function (err) {
      return next(err);
    });
});

module.exports = router;