## Docker file to start with poetry for python and node for frontend

python:3.8-slim and poetry 1.1.6, node 14. Can be changed in dockerfile

    e.g. can install wagtail 1.2 on python 3.5 useful for long upgrades. it's a bit slow for poetry getting depenencies! and wagtail django versions are a pain
    wagtail 1.10+ is OK

## Fresh Install
Were you can add python dependencies and node dependencies

Skip this if poetry files and node files already exist
```
docker-compose up -d python node
```

Python/poetry
```
docker-compose exec python bash
```

something lkie

```
poetry init
poetry add django
```

Node/npm
```
docker-compose exec node bash
```

something like

```
npm init
npm install gulp
```

## Development
Run the app container

```
docker-compose up -d app
```

Will run app and db container and compile requirements.txt ready for running pip install

### enter the app container

```
docker-compose exec app bash
```
Run somthing like
```
django-admin startproject app .
```

Run the app for development, like
```
./manage.py runserver 0.0.0.0:8000
```

## Add an existing app:

    alter docker file PYSETUP_PATH and VENV_PATH to suit the app root
    alter POETRY_VERSION and NODE_VERSION to suit

## Postgres is available

Set your connection env vars in app

## Sqlite3 to postgres

https://github.com/nickmoreton/sqlite3-to-postgres