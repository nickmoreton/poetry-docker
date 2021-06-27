###############################################
# Base Image
###############################################
FROM python:3.8-slim as python-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.6 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/app" \
    VENV_PATH="/app/.venv" \
    NODE_VERSION=14

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

###############################################
# Utils Image
###############################################
FROM python-base as utils-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH

###############################################
# Node Image
###############################################
# FROM python-base as node-base
# RUN apt-get update \
#     && apt-get install --no-install-recommends -y \
#     curl \
#     build-essential

# # install poetry - respects $POETRY_VERSION & $POETRY_HOME
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install -y nodejs
# # copy project requirement files here to ensure they will be cached.
# WORKDIR $PYSETUP_PATH
# # install npm dependancies
# WORKDIR /app
# COPY . .
# RUN npm install
# RUN npm run sass 
# RUN npm run scripts

###############################################
# Builder Image
###############################################
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --no-dev

COPY package.json package-lock.json ./
RUN npm install 
# run npm commands here like npm start. The compiled stuff should come across to production in the app

###############################################
# Production Image
###############################################
FROM python-base as production
EXPOSE 8000
COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH
WORKDIR $PYSETUP_PATH
# COPY . . ?
CMD gunicorn app.app.wsgi:application --bind 0.0.0.0:8000