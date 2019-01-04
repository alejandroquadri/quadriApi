'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var googleAuth = require('google-auth-library');

var SCOPES = ['https://www.googleapis.com/auth/spreadsheets']; //you can add more scopes according to your permission need. But in case you chang the scope, make sure you deleted the ~/.credentials/sheets.googleapis.com-nodejs-quickstart.json file
var TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE) + '/.credentials/'; //the directory where we're going to save the token
// const TOKEN_PATH = TOKEN_DIR + 'sheets.googleapis.com-nodejs-quickstart.json'; //the file which will contain the token

var TOKEN_PATH = TOKEN_DIR + 'sheets.googleapis.json'; //the file which will contain the token

var Authentication = function () {
  function Authentication() {
    _classCallCheck(this, Authentication);
  }

  _createClass(Authentication, [{
    key: 'getClientSecret',
    value: function getClientSecret() {
      return require('./credentialsSheetsApi.json');
    }
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
          // oAuth2Client.credentials = token;
          // this.storeToken(token);
          resolve(token);
        });
      });
    }
  }]);

  return Authentication;
}();

module.exports = new Authentication();