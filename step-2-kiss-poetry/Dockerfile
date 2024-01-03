FROM python:3.11

# Install poetry
RUN pip install poetry

WORKDIR /app
COPY . .

# Install dependencies with Poetry
RUN poetry install --with prod

CMD ["poetry", "run", "gunicorn", "kiss.main:app"]
