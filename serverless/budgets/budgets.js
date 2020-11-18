'use strict'

const AWS = require('aws-sdk');
const uuid = require('uuid');
const qs = require('querystring')
AWS.config.update({region: process.env.AWS_REGION}); 
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.BUDGETS_TABLE;

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
                budgets: result.Items[0].budgets
            })
        }
    },
    post: async(event, context) => {
        let buff = Buffer.from(event.body, "base64");
        let eventBodyStr = buff.toString('UTF-8');
        const data = qs.parse(eventBodyStr);
        const userId = event.requestContext.authorizer.claims.sub;
        
        if (data.amount === undefined || data.category === undefined) {
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
        const categories = ['family', 'vacation', 'saving'];
        if (categories.indexOf(data.category) === -1) {
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: "Missing parameters."
                })
            }
        }

        const params = {
            TableName,
            Key:{
                "userId": userId,
            },
            UpdateExpression: "set budgets[" + categories.indexOf(data.category) + "].amount = :i",
            ExpressionAttributeValues:{
                ":i": parseFloat(data.amount)
            },
            ReturnValues:"UPDATED_NEW"
        };
        let result = {};

        try {
            result = await db.update(params).promise();
        } catch (error) {
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