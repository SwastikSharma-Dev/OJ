from django.db import models

# Create your models here.

class Company(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name

class Tag(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name

class Problem(models.Model):
    problem_id = models.CharField(max_length=20, unique=True)
    title  = models.CharField(max_length=255)
    description = models.TextField()
    constraints = models.TextField()
    difficulty = models.CharField(max_length=10, choices=[('Easy','Easy'),('Medium','Medium'),('Hard','Hard')])
    companies = models.ManyToManyField(Company, blank=True)
    tags = models.ManyToManyField(Tag, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"(self.problem_id) - {self.title}"
    
class TestCase(models.Model):
    problem = models.ForeignKey(Problem, on_delete=models.CASCADE, related_name='testcases')
    input_data = models.TextField()
    expected_output = models.TextField()
    is_hidden = models.BooleanField(default=False)

    def __str__(self):
        return f"TestCase for {self.problem.title} ({'Hidden' if self.is_hidden else 'Visible'})"
