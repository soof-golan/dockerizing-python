FROM python:3.11
# Pin poetry version to avoid breaking changes
RUN pip install poetry==1.7.0

WORKDIR /app

# Only install dependencies without the "root" package
COPY poetry.lock pyproject.toml ./
RUN poetry install --no-root --with prod

# Install the "root" package after copying the rest of the code
COPY . .
RUN poetry install

CMD ["poetry", "run", "gunicorn", "basic_improvements.main:app"]
