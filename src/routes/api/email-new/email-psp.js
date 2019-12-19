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

  const answer = req.body;
  let date = moment(answer.date, "YYYY/MM/DD").format('DD/MM/YYYY');

  let iibb;
  answer.iibb === 0 ? iibb = '0' : iibb = decimal(Number(answer.iibb), 0);

  let psp = {
    to: answer.to,
    cc: answer.cc,
    number: answer.number,
    obs: answer.obs,
    razSoc: answer.razSoc,
    date: date,
    salesRep: answer.salesRep,
    total: decimal(Number(answer.total), 0),
    iva: decimal(Number(answer.iva), 0),
    iibb: iibb,
    final: decimal(Number(answer.final), 0),
    payment: answer.payment,
  }

  let items = '';

  for (let i=0; i < answer.items.length; i ++) {
    let item = htmlItem(answer.items[i]);
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
        from: `"Quadri" <${answer.currentEmail}>`,
        sender: answer.currentEmail,
        replyTo: answer.currentEmail,
        cc: [answer.currentEmail, psp.cc || ''],
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

router.post('/answer', function(req, res, next) {

  const answer = req.body;

  const mailOptions = {
    from: `"Quadri" <${answer.from}>`,
    sender: answer.from,
    replyTo: answer.from,
    cc: [answer.from, ...answer.cc || ''],
    to: answer.to,
    subject: `Quadri - ${answer.interest || ''}`,
    text: 'Version texto',
    html: answer.text.replace(/\n/g, "<br>")
  };

  return mailTransport.sendMail(mailOptions)
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

  if (!item.currency) item.currency = 'Pesos';

  return `
  <tr>
    <td style="width: 200px;">
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
      ${item.currency}
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