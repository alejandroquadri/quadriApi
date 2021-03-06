/* eslint-disable no-console */
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var cors = require('cors');

var isProduction = process.env.NODE_ENV === 'production';

// creo objeto de app global
var app = express();

const db = require('./db'); // your db module

// esto para que asigne correctamente los headers
app.use(cors());

// Configs de express
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(require('./routes'));

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  console.log('en dev');
  app.use(function(err, req, res, next) {
    res.status( err.code || 500 )
    .json({
      status: 'error',
      message: err
    });
  });
} else { 
  console.log('en prod');
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res) {
  res.status(err.status || 500)
  .json({
    status: 'error',
    message: err.message
  });
});

// arranca el servidor
var server = app.listen( process.env.PORT || 3100, function(){
  console.log(`Listening on port ${server.address().port}`);
});

