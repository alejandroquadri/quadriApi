import express from 'express';
let google = require('googleapis');
let authentication = require("../../googleApi");

const router = express.Router();

router.get('/get-link', function(req, res, next) {
  console.log('llega');
  let url = authentication.getLink()
  .then( url => {
    res.status(200).send(`el link es ${url}`).end();
  })
  
});

router.get('/paste-link', function(req, res, next) {
  let code = req.query.code;
  console.log('el codigo es', code);
  authentication.getTokenManually(code)
  .then( auth => {
    res.status(200).send(`autorizado ${auth}`).end();
  })
});


module.exports = router;