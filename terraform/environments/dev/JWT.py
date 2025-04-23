import jwt
from datetime import datetime, timedelta

payload = {
    "sub": "admin@onepassapparel.com",
    "role": "checkout_access",
    "exp": datetime.utcnow() + timedelta(minutes=30)
}

secret = "onepass_super_secret_key"  # Must match what’s in your Lambda
token = jwt.encode(payload, secret, algorithm="HS256")

print("Bearer " + token)
