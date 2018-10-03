import express from 'express';
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

  const consulta = req.body;
  let interest;
  consulta.interest? interest = consulta.interest : interest = '';

  const mailOptions = {
    from: `"Presupuestos" <presupuestos@queo.com.ar>`,
    to: "info@queo.com.ar",
    subject: `Queo - Consulta ${interest}`,
    text : `${consulta.name} - ${consulta.email} - ${consulta.telephone}\n \n${consulta.query}`
  };

  console.log(mailOptions);

  return mailTransport.sendMail(mailOptions).then(() => {
    console.log('Psp sent');
    res.status(200).send('query sent')
  }).catch(error => {
    console.error('There was an error while sending the email:', error);  
  });

});

module.exports = router;