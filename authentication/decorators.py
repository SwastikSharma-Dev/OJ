from django.http import JsonResponse
from .utils import decode_jwt_token

def jwt_required(view_func):
    def wrapper(request,*args,**kwargs):
        auth_header = request.META.get('HTTP_AUTORIZATION')
        if not auth_header or not auth_header.startswith('Bearer '):
            return JsonResponse({'error': 'Authorization Header Missing'}, status=401)
        
        token = auth_header.split(' ')[1]
        payload = decode_jwt_token(token)
        if not payload:
            return JsonResponse({'error':'Invalid or Expired Token'}, status=401)

        request.user_payload = payload
        return view_func(request,*args, **kwargs)
    
    return wrapper