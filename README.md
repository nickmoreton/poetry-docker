# Docker starter

A setup to start your app with poetry for python and node for frontend

    python:3.6-slim
    poetry 1.1.7
    node 14
    Can be changed in dockerfile

*Note to self if dealing with older versions of apps, you can install wagtail 1.2 on python 3.5 useful for long upgrades. it's a bit slow for poetry getting depenencies! and wagtail django versions are a pain
wagtail 1.10+ is OK*

The aim here is really to help setup a project with only docker as the required dependency on your local machine. This way different python versions/node verions can be used without jumping  through many hoops to get them working locally.

The docker files use multistage builds to keep none production dependencies out of the final image.

## Fresh Install (first time only)
Skip this if poetry files and node files already exist.

So you can add python dependencies and node dependencies. You can always update packages and versions inside the containers once they are created.

```bash
docker-compose up -d python node
```

Python/poetry
```bash
docker-compose exec python bash
```

something like

```bash
poetry init
poetry add wagtail *(you can start with a specific version)*
```

Node/npm
```bash
docker-compose exec node bash
```

something like

```bash
npm init
npm install gulp
```

STOP THE SETUP CONTAINERS: `docker-compose down -v`

# Development
Running the app container. Will run app and db container and compile requirements.txt ready for running pip install inside the final container.

```bash
docker-compose up -d app
```

**Enter the app container**

```bash
docker-compose exec app bash
```

You can then set up your app with something like...

```bash
wagtail start app .
```

Run the app with something like...
```bash
./manage.py runserver 0.0.0.0:8000
```

# Change the python dependecies

Enter the requirements container to use the poetry command to make changes. Changes are refelected in your local pyproject.toml and poetry.lock

You'll need to start you containers again using --build to get dependency changes in place.

```bash
docker-compose up -d requirements
docker-compose exec requirements bash
```



## Sqlite3 to postgres

https://github.com/nickmoreton/sqlite3-to-postgres
