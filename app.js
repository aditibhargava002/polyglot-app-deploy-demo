//code Demo
const PDFDocument = require('pdfkit');
const faker = require('faker');
const getStream = require('get-stream');

//RDS proxy Demo
let AWS = require('aws-sdk');
var mysql2 = require('mysql2'); //https://www.npmjs.com/package/mysql2
let fs  = require('fs');

var mysql = require('mysql');
var connection = mysql.createConnection({
    host: "rdsproxydemo.proxy-c63hpm5p2jol.ap-south-1.rds.amazonaws.com",
    user: "admin",
    password: "AdminAma123",
    database: "mydb",
});

//exports.lambdaHandler = async (event, context, callback) => {
exports.lambdaHandler = (event, context, callback) => {

    // const doc = new PDFDocument();

    // const randomName = faker.name.findName();

    // doc.text(randomName, { align: 'right' });
    // doc.text(faker.address.streetAddress(), { align: 'right' });
    // doc.text(faker.address.secondaryAddress(), { align: 'right' });
    // doc.text(faker.address.zipCode() + ' ' + faker.address.city(), { align: 'right' });
    // doc.moveDown();
    // doc.text('Dear ' + randomName + ',');
    // doc.moveDown();
    // for(let i = 0; i < 3; i++) {
    //     doc.text(faker.lorem.paragraph());
    //     doc.moveDown();
    // }
    // doc.text(faker.name.findName(), { align: 'right' });
    // doc.end();

    // pdfBuffer = await getStream.buffer(doc);
    // pdfBase64 = pdfBuffer.toString('base64');

    // const response = {
    //     statusCode: 200,
    //     headers: {
    //         'Content-Length': Buffer.byteLength(pdfBase64),
    //         'Content-Type': 'application/pdf',
    //         'Content-disposition': 'attachment;filename=test.pdf'
    //     },
    //     isBase64Encoded: true,
    //     body: pdfBase64
    // };
    
    //RDS proxy code
    connection.query('show tables', function (error, results, fields) {
        if (error) {
            connection.destroy();
            throw error;
        } else {
            // connected!
            console.log('connected as id ' + connection.threadId);
            console.log(results);
            callback(error, results);
            connection.end(function(error, results) {
					  if(error){
					    return "error";
					  }
					  // The connection is terminated now 
					  console.log("Connection ended\n");
			
				});
        }
    });
    //return response;

};
