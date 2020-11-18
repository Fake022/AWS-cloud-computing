'use strict'

const AWS = require('aws-sdk');
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
                budgets: result.Items[0].budgets,
                receipts: result.Items[0].receipts
            })
        }
    }
}