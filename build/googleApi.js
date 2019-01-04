'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var fs = require('fs');
var readline = require('readline');
var googleAuth = require('google-auth-library');

var SCOPES = ['https://www.googleapis.com/auth/spreadsheets']; //you can add more scopes according to your permission need. But in case you chang the scope, make sure you deleted the ~/.credentials/sheets.googleapis.com-nodejs-quickstart.json file
var TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE) + '/.credentials/'; //the directory where we're going to save the token
var TOKEN_PATH = TOKEN_DIR + 'sheets.googleapis.com-nodejs-quickstart.json'; //the file which will contain the token

var Authentication = function () {
  function Authentication() {
    _classCallCheck(this, Authentication);
  }

  _createClass(Authentication, [{
    key: 'authenticate',
    value: function authenticate() {
      var _this = this;

      return new Promise(function (resolve, reject) {
        var credentials = _this.getClientSecret();
        var authorizePromise = _this.authorize(credentials);
        authorizePromise.then(resolve, reject);
      });
    }
  }, {
    key: 'getClientSecret',
    value: function getClientSecret() {
      return require('./credentials.json');
    }
  }, {
    key: 'authorize',
    value: function authorize(credentials) {
      var _this2 = this;

      var clientSecret = credentials.installed.client_secret;
      var clientId = credentials.installed.client_id;
      var redirectUrl = credentials.installed.redirect_uris[0];
      var auth = new googleAuth();
      var oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

      return new Promise(function (resolve, reject) {
        // Check if we have previously stored a token.
        fs.readFile(TOKEN_PATH, function (err, token) {
          if (err) {
            _this2.getNewToken(oauth2Client).then(function (oauth2ClientNew) {
              resolve(oauth2ClientNew);
            }, function (err) {
              reject(err);
            });
          } else {
            oauth2Client.credentials = JSON.parse(token);
            resolve(oauth2Client);
          }
        });
      });
    }
  }, {
    key: 'getNewToken',
    value: function getNewToken(oauth2Client, callback) {
      var _this3 = this;

      return new Promise(function (resolve, reject) {
        var authUrl = oauth2Client.generateAuthUrl({
          access_type: 'offline',
          scope: SCOPES
        });
        console.log('Authorize this app by visiting this url: \n ', authUrl);
        var rl = readline.createInterface({
          input: process.stdin,
          output: process.stdout
        });
        rl.question('\n\nEnter the code from that page here: ', function (code) {
          rl.close();
          oauth2Client.getToken(code, function (err, token) {
            if (err) {
              console.log('Error while trying to retrieve access token', err);
              reject();
            }
            oauth2Client.credentials = token;
            _this3.storeToken(token);
            resolve(oauth2Client);
          });
        });
      });
    }
  }, {
    key: 'storeToken',
    value: function storeToken(token) {
      try {
        fs.mkdirSync(TOKEN_DIR);
      } catch (err) {
        if (err.code != 'EEXIST') {
          throw err;
        }
      }
      fs.writeFile(TOKEN_PATH, JSON.stringify(token));
      console.log('Token stored to ' + TOKEN_PATH);
    }

    // estas dos funciones las agregue yo para poder pedir el refresh token sin usar 
    // la comand line

  }, {
    key: 'getLink',
    value: function getLink() {
      var auth = new googleAuth();
      var credentials = this.getClientSecret();
      var clientSecret = credentials.installed.client_secret;
      var clientId = credentials.installed.client_id;
      var redirectUrl = credentials.installed.redirect_uris[0];

      return new Promise(function (resolve, reject) {

        var oAuth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

        var authorizeUrl = oAuth2Client.generateAuthUrl({
          access_type: 'offline',
          scope: SCOPES
        });
        console.log('Authorize this app by visiting this url: \n ', authorizeUrl);
        resolve(authorizeUrl);
      });
    }
  }, {
    key: 'getTokenManually',
    value: function getTokenManually(code) {
      var _this4 = this;

      var auth = new googleAuth();
      var credentials = this.getClientSecret();
      var clientSecret = credentials.installed.client_secret;
      var clientId = credentials.installed.client_id;
      var redirectUrl = credentials.installed.redirect_uris[0];

      return new Promise(function (resolve, reject) {

        var oAuth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

        oAuth2Client.getToken(code, function (err, token) {
          if (err) {
            console.log('Error while trying to retrieve access token', err);
            reject();
          }
          console.log(token);
          _this4.storeToken(token);
          resolve(token);
        });
      });
    }
  }]);

  return Authentication;
}();

module.exports = new Authentication();