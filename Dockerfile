FROM python:3.9.21-alpine3.21

RUN pip install --upgrade pip

# Install pipenv within the virtual environment
RUN pip install pipenv

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock /app/
WORKDIR /app

# Ensure pipenv uses the correct Python interpreter
RUN pipenv install 

# Copy the rest of the application code
COPY . /app

# Set the entrypoint for the container
CMD ["pipenv", "run", "flask", "run", "--host=0.0.0.0"]