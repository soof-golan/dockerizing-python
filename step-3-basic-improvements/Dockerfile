FROM python:3.11
# Pin poetry version to avoid breaking changes
RUN pip install poetry==1.7.0

WORKDIR /app

# Only install external dependencies without the our own code.
COPY poetry.lock pyproject.toml ./
RUN poetry install --no-root --with prod

# Install the our own package after copying the rest of the code
COPY . .
RUN poetry install

CMD ["poetry", "run", "gunicorn", "basic_improvements.main:app"]
