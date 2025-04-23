import os
import json
import boto3
import uuid
import jwt  # PyJWT
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
ses = boto3.client('ses')
table = dynamodb.Table('Orders')

SENDER         = os.environ["SENDER"]
ORDER_NOTIFY   = os.environ["ORDER_NOTIFY"]
SUPPORT_NOTIFY = os.environ["SUPPORT_NOTIFY"]
JWT_SECRET     = os.environ["JWT_SECRET"]

def lambda_handler(event, context):
    try:
        # ✅ Verify JWT
        auth_header = event["headers"].get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            raise Exception("Missing or malformed Authorization header")
        
        token = auth_header.split(" ")[1]
        decoded = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
        
        # ✅ Proceed with order flow
        body = json.loads(event.get("body", "{}"))
        order_id = str(uuid.uuid4())

        item = {
            "order_id":   order_id,
            "name":       body.get("name"),
            "email":      body.get("email"),
            "product":    body.get("product"),
            "size":       body.get("size"),
            "created_at": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        # Email to customer
        ses.send_email(
            Source=SENDER,
            Destination={"ToAddresses": [item["email"]]},
            Message={
                "Subject": {"Data": "Your OnePass Apparel Order"},
                "Body": {
                    "Text": {
                        "Data": f"Thanks {item['name']}! Your order ID is {order_id}."
                    }
                }
            }
        )

        # Email to orders@...
        ses.send_email(
            Source=SENDER,
            Destination={"ToAddresses": [ORDER_NOTIFY]},
            Message={
                "Subject": {"Data": f"New Order: {order_id}"},
                "Body": {
                    "Text": {
                        "Data": json.dumps(item, indent=2)
                    }
                }
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Order processed", "order_id": order_id})
        }

    except jwt.ExpiredSignatureError:
        return {"statusCode": 401, "body": json.dumps({"error": "Token expired"})}
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
