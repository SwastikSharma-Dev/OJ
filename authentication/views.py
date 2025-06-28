from django.shortcuts import render, redirect
from django.contrib.auth import authenticate
from django.http import JsonResponse, HttpRequest
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from django.contrib.auth import login
from .utils import generate_jwt_token
from .decorators import jwt_required
import json
from . import forms
# Create your views here.
from .models import Problem

@csrf_exempt
def login_api(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')

        user = authenticate(username=username, password=password)

        if user:
            token = generate_jwt_token(user)
            return JsonResponse({'token':token})
        return JsonResponse({'error':'Invalid Credentials'}, status = 401)
    
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import render, redirect

def login_page(request):
    if request.user.is_authenticated:
        return redirect('dashboard_view')
    
    if request.method == 'POST':
        form = forms.LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']

            user = authenticate(username=username, password=password)
            if user:
                login(request, user)  # SESSION LOGIN
                return redirect('dashboard_view')
            else:
                return render(request, 'authentication/login.html', {
                    'form': form,
                    'error': 'Invalid credentials'
                })
    else:
        form = forms.LoginForm()

    return render(request, 'authentication/login.html', {'form': form})

   

def register_page(request):
    if request.user.is_authenticated:
        return redirect('dashboard_view')

    if request.method == 'POST':
        form = forms.RegisterForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password1']

            if User.objects.filter(username=username).exists():
                return render(request, 'authentication/register.html', {'form':form, 'error': 'Username Already Exists'})

            User.objects.create_user(username=username, email=email, password=password)
            return redirect('login_page')

    else:
        form = forms.RegisterForm()

    return render(request, 'authentication/register.html',{'form':form})

from django.contrib.auth.decorators import login_required

@login_required
def dashboard_view(request):
    problems = Problem.objects.all()
    return render(request, 'authentication/dashboard.html', {'problems': problems})
                  

def logout_view(request):
    logout(request)
    return redirect('login_page')

@login_required
def problem_detail_view(request, problem_id):
    problem = Problem.objects.get(id=problem_id)
    return render(request, 'authentication/problem.html', {'problem': problem})
