#!/bin/bash

# Exit on any error
set -e

echo "🔥 Starting HeatCode application..."

# Wait for database to be ready (if using external database)
if [ "$POSTGRES_DB" ]; then
    echo "Waiting for PostgreSQL database..."
    python << END
import sys
import time
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mainWebsite.settings')
import django
django.setup()

max_tries = 30
tries = 0
while tries < max_tries:
    try:
        from django.db import connection
        connection.ensure_connection()
        print("✅ Database is ready!")
        break
    except Exception as e:
        tries += 1
        print(f"⏳ Database not ready yet, retrying in 2 seconds... ({tries}/{max_tries})")
        time.sleep(2)
else:
    print("❌ Could not connect to database after 30 attempts")
    sys.exit(1)
END
else
    echo "📁 Using SQLite database"
fi

# Run database migrations
echo "🔄 Running database migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Create superuser if environment variables are provided and no superuser exists
echo "👤 Creating superuser if needed..."
python manage.py create_superuser

# Collect static files
echo "📦 Collecting static files..."
python manage.py collectstatic --noinput

# Create sample data if needed
echo "🎯 Creating sample data..."
python manage.py shell << 'END'
from authentication.models import Problem, TestCase, Tag, Company

# Create sample problems if none exist
if Problem.objects.count() == 0:
    print("Creating sample problems...")
    
    # Create tags
    array_tag, _ = Tag.objects.get_or_create(name="Array")
    math_tag, _ = Tag.objects.get_or_create(name="Math")
    string_tag, _ = Tag.objects.get_or_create(name="String")
    
    # Create companies
    google, _ = Company.objects.get_or_create(name="Google")
    amazon, _ = Company.objects.get_or_create(name="Amazon")
    
    # Problem 1: Two Sum
    if not Problem.objects.filter(problem_id="1").exists():
        problem1 = Problem.objects.create(
            problem_id="1",
            title="Two Sum",
            description="Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target. You may assume that each input would have exactly one solution, and you may not use the same element twice.",
            constraints="2 <= nums.length <= 10^4\n-10^9 <= nums[i] <= 10^9\n-10^9 <= target <= 10^9\nOnly one valid answer exists.",
            difficulty="Easy"
        )
        problem1.tags.add(array_tag, math_tag)
        problem1.companies.add(google, amazon)
        
        # Add test cases
        TestCase.objects.create(
            problem=problem1,
            input_data="[2,7,11,15]\n9",
            expected_output="[0,1]",
            is_hidden=False
        )
        TestCase.objects.create(
            problem=problem1,
            input_data="[3,2,4]\n6",
            expected_output="[1,2]",
            is_hidden=False
        )
        TestCase.objects.create(
            problem=problem1,
            input_data="[3,3]\n6",
            expected_output="[0,1]",
            is_hidden=True
        )
    
    # Problem 2: Add Two Numbers
    if not Problem.objects.filter(problem_id="2").exists():
        problem2 = Problem.objects.create(
            problem_id="2",
            title="Add Two Numbers",
            description="You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.",
            constraints="The number of nodes in each linked list is in the range [1, 100].\n0 <= Node.val <= 9\nIt is guaranteed that the list represents a number that does not have leading zeros.",
            difficulty="Medium"
        )
        problem2.tags.add(math_tag)
        problem2.companies.add(amazon)
        
        # Add test cases
        TestCase.objects.create(
            problem=problem2,
            input_data="[2,4,3]\n[5,6,4]",
            expected_output="[7,0,8]",
            is_hidden=False
        )
        TestCase.objects.create(
            problem=problem2,
            input_data="[0]\n[0]",
            expected_output="[0]",
            is_hidden=False
        )
    
    # Problem 3: Longest Substring Without Repeating Characters
    if not Problem.objects.filter(problem_id="3").exists():
        problem3 = Problem.objects.create(
            problem_id="3",
            title="Longest Substring Without Repeating Characters",
            description="Given a string s, find the length of the longest substring without repeating characters.",
            constraints="0 <= s.length <= 5 * 10^4\ns consists of English letters, digits, symbols and spaces.",
            difficulty="Medium"
        )
        problem3.tags.add(string_tag)
        problem3.companies.add(google)
        
        # Add test cases
        TestCase.objects.create(
            problem=problem3,
            input_data="abcabcbb",
            expected_output="3",
            is_hidden=False
        )
        TestCase.objects.create(
            problem=problem3,
            input_data="bbbbb",
            expected_output="1",
            is_hidden=False
        )
        TestCase.objects.create(
            problem=problem3,
            input_data="pwwkew",
            expected_output="3",
            is_hidden=True
        )
    
    print("✅ Sample problems created successfully!")
else:
    print("📋 Sample problems already exist.")
END

echo "🚀 Starting Django development server..."

# Start the application
exec python manage.py runserver 0.0.0.0:8000
