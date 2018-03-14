const googleAuth = require('google-auth-library');

let SCOPES = ['https://www.googleapis.com/auth/spreadsheets']; //you can add more scopes according to your permission need. But in case you chang the scope, make sure you deleted the ~/.credentials/sheets.googleapis.com-nodejs-quickstart.json file
const TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE) + '/.credentials/'; //the directory where we're going to save the token
// const TOKEN_PATH = TOKEN_DIR + 'sheets.googleapis.com-nodejs-quickstart.json'; //the file which will contain the token

const TOKEN_PATH = TOKEN_DIR + 'sheets.googleapis.json'; //the file which will contain the token

class Authentication {

  getClientSecret(){
    return require('./credentialsSheetsApi.json');
  }


  getLink() {
    let auth = new googleAuth();
    let credentials = this.getClientSecret();
    let clientSecret = credentials.installed.client_secret;
    let clientId = credentials.installed.client_id;
    let redirectUrl = credentials.installed.redirect_uris[0];

    return new Promise((resolve, reject) => {
      
      const oAuth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);
  
      const authorizeUrl = oAuth2Client.generateAuthUrl({
        access_type: 'offline',
        scope: SCOPES
      });
      console.log('Authorize this app by visiting this url: \n ', authorizeUrl);
      resolve(authorizeUrl);
    });
  }

  getTokenManually(code) {
    let auth = new googleAuth();
    let credentials = this.getClientSecret();
    let clientSecret = credentials.installed.client_secret;
    let clientId = credentials.installed.client_id;
    let redirectUrl = credentials.installed.redirect_uris[0];

    return new Promise((resolve, reject) => {

      const oAuth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

      oAuth2Client.getToken(code, (err, token) => {
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

}

module.exports = new Authentication();
