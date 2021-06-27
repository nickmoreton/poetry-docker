## Docker file to start with poetry for python and node for frontend

python:3.8-slim and poetry 1.1.6, node 14. Can be changed in dockerfile

    e.g. can install wagtail 1.2 on python 3.5 useful for long upgrades. it's a bit slow for poetry getting depenencies! and wagtail django versions are a pain
    wagtail 1.10+ is OK

### Start an initial project

Utils Base (python and node)

```
docker-compose up -d utils --build
docker-compose exec utils bash
```

Then set up your python app and node builders for front end

### Develop

```
docker-compose up -d --build
docker-compose exec app bash
```

Then run the app, like

```
./manage.py runserver 0.0.0.0:8000
```

Stop all
```
docker-compose down -v
```

## Add an existing app:

    alter docker file PYSETUP_PATH and VENV_PATH to suite the app root
    alter POETRY_VERSION and NODE_VERSION to suite

## Postgres is available

Set your connection env vars in app

## Sqlite3 to postgres

https://github.com/nickmoreton/sqlite3-to-postgres