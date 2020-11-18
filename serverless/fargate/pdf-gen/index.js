const nodemailer = require('nodemailer');
const receipts = JSON.parse(process.env.USER_DATA);
const mailTo = process.env.USER_EMAIL;

function sendMail(msg) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
               user: 'bankin.cloud@gmail.com',
               pass: '8jFWx4D9b'
           }
    });
    const mailOptions = {
        from: 'bankin.cloud@gmail.com', // sender address
        to: mailTo, // list of receivers
        subject: 'Receipts from your account', // Subject line
        html: '<p>'+msg+'</p>'// plain text body
    };

    transporter.sendMail(mailOptions, function (err, info) {
        if(err)
          console.log("An error occured (mail): "+err)
        else
          console.log(info);
     });
}


if (receipts.length === 0) {
    sendMail("No data on your account.");
} else {
    let html = "<ul>";
    receipts.forEach(receipt => {
        html += "<li>" + receipt.name + " - " + receipt.amount + "€</li>";
    });
    html += "</ul>";
    sendMail(html);
}