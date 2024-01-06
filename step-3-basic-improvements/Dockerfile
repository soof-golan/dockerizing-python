FROM python:3.11

# Pin poetry version to avoid breaking changes
RUN pip install poetry==1.7.0

WORKDIR /app

# Copy only the files needed for installing dependencies
COPY poetry.lock pyproject.toml ./

# Only install external dependencies
RUN poetry install --no-root --with prod

# Copy the rest of the code
COPY . .

# Install our own project
RUN poetry install

CMD ["poetry", "run", "gunicorn", "basic_improvements.main:app"]

