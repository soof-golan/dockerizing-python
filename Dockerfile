# Use the official Python image. no -slim or -alpine here!
FROM python:3.11

# Configure Python to behave well inside the container.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set the working directory to /app.
WORKDIR /app

# Copy only the (auto-generated) requirements.txt file
COPY ./requirements.txt ./

# Install dependencies (with caching).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --require-hashes -r requirements.txt

# Copy the rest of the codebase into the image.
COPY . .

# Install the "root" application (with caching).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install . --no-deps

# Start the production server.
CMD ["gunicorn", "dockerizing_python.main:app"]
