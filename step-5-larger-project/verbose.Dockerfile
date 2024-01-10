# Stage 1: Use `poetry export` to generate a `requirements.txt` file
# With SHA-256 hashes
FROM python:3.11 as poetry-export

# Install poetry
RUN pip install poetry==1.7.0

# Create the /app directory
WORKDIR /app

# Copy only the files needed for generating the requirements.txt file
COPY poetry.lock pyproject.toml ./

# Run poetry export to generate the requirements.txt file
# NOTE: We use --without dev to exclude development dependencies and
# --with prod to include production dependencies.
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

# Stage 2: Build the production image
FROM python:3.11 as server

# Configure Python to behave well inside the container.
# Do not write .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Do not buffer stdout and stderr
ENV PYTHONUNBUFFERED=1
# Display the Python stacktrace on error
ENV PYTHONFAULTHANDLER=1
# Do not check for pip updates
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Set the working directory to /app.
WORKDIR /app

# Copy only the requirements.txt file from Stage 1
COPY --from=poetry-export /app/requirements.txt ./

# Install dependencies.
RUN pip install --require-hashes -r requirements.txt

# Copy the rest of the codebase into the image.
# NOTE: .dockerignore determines what is (not) copied.
COPY . .

# Install our own project
RUN pip install . --no-deps

# Start the production server.
CMD ["gunicorn", "larger_project.main:app"]
