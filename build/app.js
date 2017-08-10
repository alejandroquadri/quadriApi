'use strict';

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

var db = require('./db'); // your db module

// esto para que asigne correctamente los headers
app.use(cors());

// view engine setup
// !! esto lo saque, entiendo que es por si usara views
// app.set('views', path.join(__dirname, 'views'));
// app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

// Configs de express
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// app.use('/', require('./routes/index'));  // !!  esto lo saco, era de lo que venia seteado
app.use(require('./routes'));
// app.use(require('./routes'));

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function (err, req, res, next) {
    res.status(err.code || 500).json({
      status: 'error',
      message: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
  res.status(err.status || 500).json({
    status: 'error',
    message: err.message
  });
});

// arranca el servidor
var server = app.listen(process.env.PORT || 3100, function () {
  console.log('Listening on port ' + server.address().port);
});