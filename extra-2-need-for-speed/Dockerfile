# We're not compiling anything here, so we can use a -slim image for the export stage.
FROM python:3.11-slim as poetry-export

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install poetry==1.7.0

WORKDIR /app
COPY poetry.lock pyproject.toml ./
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

FROM python:3.11 as server
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
COPY --from=poetry-export /app/requirements.txt ./

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --require-hashes -r requirements.txt

# Pre-compile "all" Python files in the PYTHONPATH to bytescode (10 levels deep)
RUN python -m compileall $(python -c "import sys; print(' '.join(sys.path), end='')") -r 10

COPY . .

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install . --no-deps

# Pre-compile our own source code
RUN python -m compileall -r 10

CMD ["gunicorn", "need_for_speed.main:app"]
