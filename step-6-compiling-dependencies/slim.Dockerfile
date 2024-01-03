FROM python:3.11-slim as poetry-export
RUN pip install poetry==1.7.0
WORKDIR /app
COPY poetry.lock pyproject.toml ./
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

# The -slim image is missing some build dependencies
FROM python:3.11-slim as server

# Install build dependencies for psycopg2
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
COPY --from=poetry-export /app/requirements.txt ./
RUN pip install --require-hashes -r requirements.txt
COPY . .
RUN pip install . --no-deps
CMD ["gunicorn", "compiling_depenedencies.main:app"]
