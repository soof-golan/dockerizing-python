# We're now using multi-stage builds!
# https://docs.docker.com/build/building/multi-stage/
FROM python:3.11 as stage-1-poetry-export
RUN pip install poetry==1.7.0

WORKDIR /app

# Copy dependency files
COPY poetry.lock pyproject.toml ./

# Generate a requirements.txt from our lock file
RUN poetry export \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

FROM python:3.11 as stage-2-server

# Configure Python things to play nicely with the container host
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Copy the dependencies from the poetry-export stage
COPY --from=stage-1-poetry-export /app/requirements.txt ./
RUN pip install --require-hashes -r requirements.txt

# Copy the rest of the code
COPY . .

# Install the "root" package
RUN pip install . --no-deps

CMD ["gunicorn", "nontrivial.main:app"]
