ARG PYTHON=3.6-slim

# *******************************
# BASE
FROM python:$PYTHON AS base

ENV \
    # build like wget:
    BUILD_ONLY_PACKAGES='' \ 
    # python:
    PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 \
    # pip:
    PIP_NO_CACHE_DIR=off PIP_DISABLE_PIP_VERSION_CHECK=on PIP_DEFAULT_TIMEOUT=100 \
    # poetry:
    POETRY_VERSION=1.1.7 POETRY_NO_INTERACTION=1 POETRY_VIRTUALENVS_CREATE=false POETRY_CACHE_DIR='/var/cache/pypoetry' PATH="$PATH:/root/.poetry/bin" \
    # node and npm
    NODE_VERSION=14 \
    # app root
    APP_ROOT='/app'


# *******************************
# PYTHON DEPENDENCIES
FROM base as pydep
RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    # Defining build-time-only dependencies:
    $BUILD_ONLY_PACKAGES \
    # Installing `poetry` package manager:
    && curl -sSL 'https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py' | python

WORKDIR $APP_ROOT

# *******************************
# NODE DEPENDENCIES
FROM base as nodedep
RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    # Defining build-time-only dependencies:
    $BUILD_ONLY_PACKAGES \
    # Installing `node` package manager:
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs

WORKDIR $APP_ROOT

# *******************************
# PYTHON REQUIREMENTS
FROM pydep as requirements
WORKDIR $APP_ROOT
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt -o $APP_ROOT/requirements.txt --without-hashes

# *******************************
# PRODUCTION
FROM base AS production
WORKDIR $APP_ROOT
COPY --from=requirements $APP_ROOT/requirements.txt $APP_ROOT
RUN pip install -r requirements.txt
COPY . .
# assuming an app is created in $APP_ROOT
# do something like
WORKDIR $APP_ROOT/app
CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]