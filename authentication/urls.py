from django.urls import path, include
from . import views

urlpatterns = [
    path('register/', views.register_page, name='register_page'),
    path('login/', views.login_page, name='login_page'),
    path('login_api/', views.login_api, name='login_api'),
    path('dashboard/', views.dashboard_view, name='dashboard_view'),
    path('logout/', views.logout_view, name='logout_view'),
    path('problem/<int:problem_id>/', views.problem_detail_view, name='problem_detail'),
]
