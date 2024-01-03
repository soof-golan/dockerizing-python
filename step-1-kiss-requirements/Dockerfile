# We start with the python3.11 base image.
FROM python:3.11

# Create the /app (this is where we will store our application code)
WORKDIR /app

# Copy all of the files from the current directory into the /app directory
COPY . .

# Install the dependencies from requirements.txt
RUN pip install -r requirements.txt

# Run the application
CMD ["gunicorn", "kiss.main:app"]
