'use strict';

var AWS = require('aws-sdk');

module.exports.lex_setBudget = (event, context, callback) => {
    try {
        if (event.body !== null && event.body !== undefined) {
            let buff = Buffer.from(event.body, "base64");
            let eventBodyStr = buff.toString('UTF-8');
            let check = JSON.parse(eventBodyStr);
            if (check !== null && check !== undefined) {
                AWS.config.update({region: 'eu-west-2'});
                var lexruntime = new AWS.LexRuntime();
                
                const params = {
                    botName: "BudgetBud",
                    botAlias: "$LATEST",
                    inputText: check.inputText,
                    userId: check.userId,
                };
                console.log('debug : ' + check.inputText);

                lexruntime.postText(params, function(err, data) {
                    var response_success = {
                        "statusCode": 200,
                        "body": JSON.stringify(data),
                        "isBase64Encoded": false
                    };
                    if (err) {
                        var response_error = {
                            "statusCode": 500,
                            "body": JSON.stringify(err),
                            "isBase64Encoded": false
                        };
                        console.log(response_error);
                        callback(null, response_error);
                    } else {
                        console.log(response_success);
                        callback(null, response_success);     
                    }      
                });
    
            } else {
                var response_error = {
                    "statusCode": 500,
                    "body": JSON.stringify("Error : body missing in request"),
                    "isBase64Encoded": false
                };
                callback(response_error);
            }
        } else {
            var response_error = {
                "statusCode": 500,
                "body": JSON.stringify("Error : nothing in body request"),
                "isBase64Encoded": false
            };
            callback(response_error);
        }
    } catch(err) {
        callback(err);       
    };
};
