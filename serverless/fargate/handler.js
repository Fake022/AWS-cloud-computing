'use strict';

const AWS = require('aws-sdk');
AWS.config.update({region: process.env.AWS_REGION});
const ECS = new AWS.ECS();
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.RECEIPTS_TABLE;

module.exports.launch = async(event, context) => {
    //DynamoDB Query
    const userId = event.requestContext.authorizer.claims.sub;
    const email = event.requestContext.authorizer.claims.email;
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

    //Run Docker
    const ECSCluster = process.env.ECS_CLUSTER;
    const ECSSecGroup = process.env.ECS_SEC_GROUP;
    const ECSSubnet = process.env.ECS_SUBNET;
    const ECSTaskArn = process.env.ECS_TASK_ARN;
    const CONTAINER_NAME = process.env.CONTAINER_NAME;

    let data;
    try {
        data = await ECS.runTask({
            cluster:ECSCluster,
            taskDefinition:ECSTaskArn,
            count:1,
            launchType:"FARGATE",
            overrides:{
                containerOverrides: [{
                    "name": CONTAINER_NAME,
                    "command": [
                        "npm",
                        "start",
                    ],
                    "environment": [
                        {
                            "name": "PDF_BUCKET",
                            "value": process.env.PDF_BUCKET
                        },
                        {
                            "name": "USER_EMAIL",
                            "value": email
                        },
                        {
                            "name": "USER_DATA",
                            "value": JSON.stringify(result.Items[0].receipts)
                        }
                    ]
                }]
            },
            networkConfiguration: {
                "awsvpcConfiguration": {
                    "subnets": [
                        ECSSubnet
                    ],
                    "securityGroups": [
                        ECSSecGroup
                    ],
                    "assignPublicIp": "ENABLED"
                }
            }
        }).promise();
        console.log(data);
    } catch(err) {
        console.log("An error occured: "+err);
        return {
            statusCode: 500
        }
    }
    return {
        statusCode: 200
    }
}