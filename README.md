# Django Template

## Instructions

- This is a template to create a containerized Django application with PostgreSQL as a database, from development environment.

1. Need to have install python install on your machine, create a virtual environment and run the following command:

    ```bash
        pip install -r requirements.txt
    ```

    **Do not forget to get the you agree with the version on the requirements, if not you can change it or update afterwards and refreeze.**

2. Create a new Django application running the following command change the core:

    ```bash
        django-admin startproject core .
    ```

    **Update core in .flake8 and docker-compose.yml**

3. Update settings.py file:

    - Update imports on the top of the file:

        ```py
            import os
            from pathlib import Path
            import environ
        ```

    - Update BASE_DIR, SECRET_KEY, DEBUG, ALLOW_HOSTS:

        ```py
            BASE_DIR = Path(__file__).resolve().parent.parent
            env = environ.Env()

            SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY")
            DEBUG = True if os.environ.get("DJANGO_DEBUG") else False
            ALLOWED_HOSTS = ["*"]

            if DEBUG:
                ALLOWED_HOSTS = ["*"]
            else:
                ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=["example.com"])  # type: ignore
        ```

    - Update DATABASES:

        ```py
            DATABASES = {
                "default": {
                    "ENGINE": "django.db.backends.postgresql",
                    "NAME": os.environ.get("POSTGRES_NAME"),
                    "USER": os.environ.get("POSTGRES_USER"),
                    "PASSWORD": os.environ.get("POSTGRES_PASSWORD"),
                    "HOST": os.environ.get("POSTGRES_HOST"),
                    "PORT": 5432,
                }
            }
            DATABASES["default"]["ATOMIC_REQUESTS"] = True
            DATABASES["default"]["CONN_MAX_AGE"] = env.int("CONN_MAX_AGE", default=60)  # type: ignore
        ```

    - Add LOGGING, LOGIN_REDIRECT_URL, LOGOUT_REDIRECT_URL:

        ```py
            LOGGING = {
                "version": 1,
                "disable_existing_loggers": False,
                "handlers": {
                    "console": {"class": "logging.StreamHandler"},
                },
                "loggers": {
                    "": {  # 'catch all' loggers by referencing it with the empty string
                        "handlers": ["console"],
                        "level": "DEBUG",
                    },
                },
            }
            LOGIN_REDIRECT_URL = "/"
            LOGOUT_REDIRECT_URL = "/"
            CELERY_BROKER_URL = os.environ.get("CELERY_BROKER_URL", "redis://redis:6379/0")
            CELERY_RESULT_BACKEND = os.environ.get("REDIS_BACKEND", "redis://redis:6379/0")
        ```

4. Run the following command:

    ```bash
        cp .env.example .env
    ```

    and update accordingly

5. Create celery.py in settings folder and copy the following:

    ```py
        import os

        from celery import Celery

        os.environ.setdefault("DJANGO_SETTINGS_MODULE", os.environ.get("DJANGO_SETTINGS_MODULE"))  # type: ignore
        app = Celery("app")
        app.config_from_object("django.conf:settings", namespace="CELERY")
        app.autodiscover_tasks()
    ```

    **Update core to correct name**

6. To run locally, you need to have docker install. You must run the following command:

    ```bash
        docker compose -f docker-compose.yml up -d --build
    ```

    and go to localhost:8000

7. To run django commands, such as the ones listed below, you can do it inside the DJANGO container or first the following command:

    ```bash
        docker exec -it CONTAINERNAME /bin/sh
    ```

    - To create a new super user:

    ```bash
        python manage.py createsuperuser
    ```

    - To run tests:

    ```bash
        python manage.py test
    ```

- To stop running the app run the following commands
Development

```bash
    docker compose -f docker-compose.yml stop
```

- To delete containers run the following commands
Development

```bash
    docker compose -f docker-compose.yml down
```
