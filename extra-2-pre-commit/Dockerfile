# No multi-stage! We're back to a single stage build.
FROM python:3.11
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app

# Copy only the requirements.txt file
COPY ./requirements.txt ./

RUN pip install --require-hashes -r requirements.txt
COPY . .
RUN pip install . --no-deps
CMD ["gunicorn", "pre_commit.main:app"]
