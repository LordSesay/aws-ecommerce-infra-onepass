import json

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    body = json.loads(event.get("body", "{}"))

    # Simulate processing (e.g. save to DB)
    response = {
        "message": "Order received!",
        "order": body
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response)
    }
