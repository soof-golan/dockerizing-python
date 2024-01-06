# We start with the python3.11 base image.
FROM python:3.11

# Create the /app directory
WORKDIR /app

# Copy all of our code into the /app directory
COPY . .

# Install our dependencies
RUN pip install -r requirements.txt

# Run the production server
CMD ["gunicorn", "kiss.main:app"]

