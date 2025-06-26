from django.urls import path
from .views import solve_problem_view

urlpatterns = [
    path('solve/<str:problem_id>/', solve_problem_view, name='solve_problem'),
]
