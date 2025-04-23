import os
import json
import boto3
import jwt

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Orders')
JWT_SECRET = os.environ["JWT_SECRET"]

def lambda_handler(event, context):
    try:
        # ✅ JWT Validation
        auth_header = event["headers"].get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            raise Exception("Missing or malformed Authorization header")
        
        token = auth_header.split(" ")[1]
        decoded = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])

        if decoded.get("role") != "admin":
            raise Exception("Unauthorized: not admin")

        # ✅ Extract order_id from path
        order_id = event["pathParameters"]["order_id"]
        response = table.get_item(Key={"order_id": order_id})

        if "Item" not in response:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Order not found"})
            }

        return {
            "statusCode": 200,
            "body": json.dumps(response["Item"])
        }

    except jwt.ExpiredSignatureError:
        return {"statusCode": 401, "body": json.dumps({"error": "Token expired"})}
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}
    except Exception as e:
        return {"statusCode": 403, "body": json.dumps({"error": str(e)})}
