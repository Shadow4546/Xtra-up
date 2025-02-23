FROM python:3.9.2-slim-buster

# Install system dependencies required for hashlib and other libraries
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    gcc libffi-dev musl-dev ffmpeg aria2 python3-pip poppler-utils libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the application code and set the working directory
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Verify the pdftoppm installation
RUN pdftoppm -v

# Check hashlib availability (test command)
RUN python3 -c "import hashlib; print(hashlib.sha256('test'.encode()).hexdigest())"

# Start the app using gunicorn as the main process

CMD gunicorn app:app & python3 main.py
