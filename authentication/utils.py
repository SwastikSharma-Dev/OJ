import jwt
from django.conf import settings
from datetime import datetime, timedelta

def generate_jwt_token(user):
    payload = {
        'user_id': user.id,
        'username': user.username,
        'exp': datetime.now().astimezone() + timedelta(seconds=settings.JWT_EXP_DELTA_SECONDS)
    }
    return jwt.encode(payload,settings.JWT_SECRET_KEY, algorithm=['HS256'])

def decode_jwt_token(token):
    try:
        return jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=['HS256'])
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None