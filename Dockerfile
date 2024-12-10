FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-venv \
    python3.9-dev \
    python3-pip \
    build-essential \
    libssl-dev \
    libffi-dev

# Set the LANG environment variable
ENV LANG=C.UTF-8

# Create and activate a virtual environment with Python 3.9
RUN python3.9 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip within the virtual environment
RUN pip install --upgrade pip

# Install pipenv within the virtual environment
RUN pip install pipenv

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock /app/
WORKDIR /app

# Ensure pipenv uses the correct Python interpreter
RUN pipenv install --python /opt/venv/bin/python3.9 --deploy --ignore-pipfile

# Copy the rest of the application code
COPY . /app

# Set the entrypoint for the container
CMD ["pipenv", "run", "flask", "run", "--host=0.0.0.0"]