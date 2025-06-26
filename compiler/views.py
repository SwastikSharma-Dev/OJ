import os
import subprocess
from django.shortcuts import render, get_object_or_404
from authentication.models import Problem
from django.conf import settings
from django.contrib.auth.decorators import login_required

@login_required
def solve_problem_view(request, problem_id):
    problem = get_object_or_404(Problem, problem_id=problem_id)
    output = ""
    
    if request.method == 'POST':
        code = request.POST.get('code')
        language = request.POST.get('language')
        user_code_dir = os.path.join(settings.BASE_DIR, 'compiler', 'user_code')
        os.makedirs(user_code_dir, exist_ok=True)

        # Define filenames
        file_path = ''
        run_cmd = []

        try:
            if language == 'python':
                file_path = os.path.join(user_code_dir, 'user_input.py')
                with open(file_path, 'w') as f:
                    f.write(code)
                run_cmd = ['python', file_path]

            elif language == 'c':
                file_path = os.path.join(user_code_dir, 'user_input.c')
                output_file = os.path.join(user_code_dir, 'user_input_c')
                with open(file_path, 'w') as f:
                    f.write(code)
                try:
                    compile_result = subprocess.run(
                        ['gcc', file_path, '-o', output_file],
                        capture_output=True,
                        text=True,
                        check=True  # this raises CalledProcessError if compilation fails
                    )
                except subprocess.CalledProcessError as e:
                    output = f"Compilation Error:\n{e.stderr or e.stdout or str(e)}"
                    return render(request, 'compiler/solve.html', {
                        'problem': problem,
                        'output': output,
                        'code': code,
                        'language': language,
                    })


            elif language == 'cpp':
                file_path = os.path.join(user_code_dir, 'user_input.cpp')
                output_file = os.path.join(user_code_dir, 'user_input_cpp')
                with open(file_path, 'w') as f:
                    f.write(code)
                subprocess.run(['C:/msys64/mingw64/bin/g++.exe', file_path, '-o', output_file], check=True)
                run_cmd = [output_file]

            elif language == 'java':
                file_path = os.path.join(user_code_dir, 'UserInput.java')
                with open(file_path, 'w') as f:
                    f.write(code)
                subprocess.run(['javac', file_path], check=True)
                run_cmd = ['java', '-cp', user_code_dir, 'UserInput']

            # Run compiled/interpreted code
            result = subprocess.run(
                run_cmd,
                capture_output=True,
                text=True,
                timeout=5,
                cwd=user_code_dir  # important for java
            )
            output = result.stdout or result.stderr

        except subprocess.CalledProcessError as e:
            output = f"Compilation Error:\n{e.stderr or str(e)}"
        except subprocess.TimeoutExpired:
            output = "Execution timed out."
        except Exception as e:
            output = f"Unexpected Error: {str(e)}"

    return render(request, 'compiler/solve.html', {
        'problem': problem,
        'output': output,
        'code': request.POST.get('code', ''),
        'language': request.POST.get('language', 'python'),
    })
