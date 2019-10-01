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
    payment: pspData.payment,
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

      return mailTransport.sendMail(mailOptions)

    })
    .then(() => {
      return res.status(200)
      .send({
        message: `Mail enviado`
      });
    })
    .catch( reason => {
      return res.status(400)
      .send({
        message: `Error, ${reason}`
      });
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

  return `
  <tr>
    <td style="width: 220px;">
      ${item.description}
    </td>
    <td align="center">
      ${decimal(item.quantity, 2)}
    </td>
    <td align="center">
      ${item.unit}
    </td>
    <td align="center">
      ${decimal(item.price, 1)}
    </td>
    <td align="center">
      ${decimal(item.discount, 1) || 0} %
    </td>
    <td align="center">
      ${decimal(item.finalPrice, 1)}
    </td>
    <td align="center">
      ${decimal(item.total, 0)}
    </td>
  </tr>
  `;
}

module.exports = router;