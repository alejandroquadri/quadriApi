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
    user: 'presupuestos@quadri.com.ar',
    pass: 'Quadri384',
  },
});

router.post('/', function(req, res, next) {

  const pspData = req.body;
  let date = moment(pspData.date, "YYYY/MM/DD").format('DD/MM/YYYY');

  let iibb;
  pspData.iibb === 0 ? iibb = '0' : iibb = decimal(Number(pspData.iibb), 0);

  let psp = {
    to: pspData.to,
    cc: pspData.cc,
    number: pspData.number,
    obs: pspData.obs,
    razSoc: pspData.razSoc,
    date: date,
    salesRep: pspData.salesRep,
    total: decimal(Number(pspData.total), 0),
    iva: decimal(Number(pspData.iva), 0),
    iibb: iibb,
    final: decimal(Number(pspData.final), 0),
    payment: pspData.items[0].tipo_pago,
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

      const mailOptions = {
        from: `"Quadri" <${pspData.currentEmail}>`,
        sender: pspData.currentEmail,
        replyTo: pspData.currentEmail,
        cc: [pspData.currentEmail, psp.cc || ''],
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
  let bonificacion, prBon;
  if (Number(item.importe_bonificado) !== 0) {
    bonificacion = item.importe_bonificado/(item.cantidad*item.precio);
    prBon = item.precio * (1- bonificacion)
  } else {
    bonificacion = 0;
    prBon = item.precio;
  }

  let itemRow = `
  <tr>
    <td style="width: 220px;">
      ${item.conceptocomercial}
    </td>
    <td align="center">
      ${decimal(item.cantidad, 2)}
    </td>
    <td align="center">
      ${item.unidad}
    </td>
    <td align="center">
      ${decimal(item.precio, 1)}
    </td>
    <td align="center">
      ${decimal(bonificacion*100, 1) || 0} %
    </td>
    <td align="center">
      ${decimal(prBon, 1)}
    </td>
    <td align="center">
      ${decimal(item.total_importe, 0)}
    </td>
  </tr>
  `;
  return itemRow;
}

module.exports = router;