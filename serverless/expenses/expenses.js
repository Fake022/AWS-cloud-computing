'use strict'

const AWS = require('aws-sdk');
const uuid = require('uuid');
const qs = require('querystring')
AWS.config.update({region: process.env.AWS_REGION});
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.RECEIPTS_TABLE;

module.exports = {
    get: async(event, context) => {
        const userId = event.requestContext.authorizer.claims.sub;
        const params = {
            KeyConditionExpression: "#uid = :uid",
            ExpressionAttributeNames:{
                "#uid": "userId"
            },
            ExpressionAttributeValues: {
                ":uid": userId
            },
            TableName
        }
        let result = {};
        try {
            result = await db.query(params).promise();
        } catch (error) {
            console.log("An error occurred.", error);
            return {
                statusCode: 500
            }
        }
        return {
            statusCode: 200,
            body: JSON.stringify({
                receipts: result.Items[0].receipts
            })
        }
    },
    post: async(event, context) => {
        let buff = Buffer.from(event.body, "base64");
        let eventBodyStr = buff.toString('UTF-8');
        const data = qs.parse(eventBodyStr);
        const userId = event.requestContext.authorizer.claims.sub;

        if (data.name === undefined || data.amount === undefined || data.category === undefined) {
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: "Missing parameters."
                })
            }
        }
        const isNumeric = (str) => {
            if (typeof str != "string") return false;
            return !isNaN(str) && !isNaN(parseFloat(str));
        }
        if (!isNumeric(data.amount)) {
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: "Missing parameters."
                })
            }
        }

        const item = {
            id: uuid.v4(),
            name: data.name,
            amount: parseFloat(data.amount),
            category: data.category,
            date: new Date().getTime()
        }
        const params = {
            TableName,
            Key:{
                "userId": userId,
            },
            UpdateExpression: "set #attrName = list_append(#attrName, :i)",
            ExpressionAttributeNames : {
                "#attrName" : "receipts"
            },
            ExpressionAttributeValues:{
                ":i": [item]
            },
            ReturnValues:"UPDATED_NEW"
        };

        let result = {};

        try {
            result = await db.update(params).promise();
        } catch(error) {
            console.log("oh. An error occured.", error);
            return {
                statusCode: 500
            }
        }
        return {
            statusCode: 200
        }
    }
}