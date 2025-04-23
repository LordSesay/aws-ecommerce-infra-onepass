import os
import json
import boto3
import jwt

ses = boto3.client('ses')
SUPPORT_EMAIL = os.environ["SUPPORT_EMAIL"]
JWT_SECRET = os.environ["JWT_SECRET"]

def lambda_handler(event, context):
    try:
        # 🔐 JWT validation
        auth_header = event["headers"].get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            raise Exception("Missing or malformed Authorization header")

        token = auth_header.split(" ")[1]
        decoded = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])

        # Accept any authenticated user
        if decoded.get("role") not in ["user", "admin"]:
            raise Exception("Unauthorized role")

        body = json.loads(event.get("body", "{}"))
        name = body.get("name")
        email = body.get("email")
        message = body.get("message")

        # Optional: forward via SES
        ses.send_email(
            Source=SUPPORT_EMAIL,
            Destination={"ToAddresses": [SUPPORT_EMAIL]},
            Message={
                "Subject": {"Data": f"New Contact Form from {name}"},
                "Body": {
                    "Text": {
                        "Data": f"From: {name} <{email}>\n\n{message}"
                    }
                }
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Thank you for contacting us!"})
        }

    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}
    except Exception as e:
        return {"statusCode": 403, "body": json.dumps({"error": str(e)})}
