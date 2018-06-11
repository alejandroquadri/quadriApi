import express from 'express';
import moment from 'moment';
import fs from 'fs';
import Handlebars from 'handlebars';
import nodemailer from 'nodemailer';
import Styliner from 'styliner';

const router = express.Router();
const styliner = new Styliner(__dirname);

const mailTransport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'alejandroquadri@quadri.com.ar',
    pass: 'vamoscuba1304',
  },
});

router.post('/', function(req, res, next) {

  const pspData = req.body;
  let date = moment(pspData.date, "YYYY/MM/DD").format('DD/MM/YYYY');

  let psp = {
    to: pspData.to,
    cc: pspData.cc,
    number: pspData.number,
    obs: pspData.obs,
    razSoc: pspData.razSoc,
    date: date,
    salesRep: pspData.salesRep,
    total: decimal(Number(pspData.total), 0)
  }

  let items = '';

  for (let i=0; i < pspData.items.length; i ++) {
    let item = htmlItem(pspData.items[i]);
    items += item;
  }
  psp['items'] = items;

  fs.readFile(__dirname + '/psp-email.html', 'utf8', (err, data) => {
    if (err) {
      console.log('error desdpues del fs' ,err)
      return ;
    }

    let template = Handlebars.compile(data);
    let JSresult = template(psp);

    styliner.processHTML(JSresult)
    .then( processedSource => {

      // let template = Handlebars.compile(processedSource);
      // let result = template(psp);
      const mailOptions = {
        from: '"Quadri" <info@quadri.com.ar>',
        cc: psp.cc || '',
        to: psp.to,
        subject: `Quadri - Presupuesto ${psp.number}`,
        text: 'Version texto',
        html: processedSource
      };

        return mailTransport.sendMail(mailOptions).then(() => {
          console.log('Psp sent');
          res.status(200)
          .json({
            html: processedSource
          })
        }).catch(error => {
          console.error('There was an error while sending the email:', error);  
        });
  
    })
    .catch( reason => {
      console.log('error en styliner' , reason)
    })
  });
    
});

function decimal(value, fractionSize) {
  // console.log('decimal',value, fractionSize);
  const DECIMAL_SEPARATOR = ".";
  const THOUSANDS_SEPARATOR = ",";
  const PADDING = "000000";

  if (value) {
    let [ integer, fraction = "" ] = (value || "").toString().split(DECIMAL_SEPARATOR);

    fraction = (fractionSize > 0) ? DECIMAL_SEPARATOR + (fraction + PADDING).substring(0, fractionSize) : "";

    integer = integer.replace(/\B(?=(\d{3})+(?!\d))/g, THOUSANDS_SEPARATOR);
    return integer + fraction;
  }
}

function htmlItem(item) {
  let cantidad = decimal(item.cantidad, 1);
  console.log(item.cantidad, cantidad);
  let itemRow = `
  <tr>
    <td style="width: 220px;">
      ${item.conceptocomercial}
    </td>
    <td align="center">
      ${decimal(item.cantidad, 1)}
    </td>
    <td align="center">
      ${decimal(item.precio, 1)}
    </td>
    <td align="center">
      ${decimal((item.importe_bonificado/(item.cantidad*item.precio)*100), 1)}%
    </td>
    <td align="center">
      ${decimal(item.precio, 1)}
    </td>
    <td align="center">
      ${decimal(item.total_importe, 0)}
    </td>
  </tr>
  `;
  console.log(itemRow);
  return itemRow;
}

module.exports = router;

// cc
// :
// "alejandroquadri@quadri.com.ar"
// currentEmail
// :
// "alejandroquadri@quadri.com.ar"
// date
// :
// "2018/06/06"
// items
// :
// (2) [{…}, {…}]
// number
// :
// "00010885"
// obs
// :
// ""
// razSoc
// :
// "CONSTRUMEX S.A."
// salesRep
// :
// "Tarruella Alberto Horacio "
// to
// :
// "alejandroquadri@quadri.com.ar"
// total
// :
// 556410