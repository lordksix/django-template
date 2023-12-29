# Django Template by lordksix

## Instructions

- This is a template to create a containerized Django application with PostgreSQL as a database, Celery and Rabbit MQ to handle and schedule tasks, Channels for WebSockets, Uvicorn for ASGI, Redis as a cache and final result for tasks, and Nginx as a reverse proxy.

1. Need to have install python install on your machine, create a virtual environment and run the following command:

    ```bash
        pip install -r requirements.txt
    ```

    **Do not forget to get the you agree with the version on the requirements, if not you can change it or update afterwards and refreeze.**

2. Run the following command and update accordingly:

    ```bash
        cp .env.example .env
    ```

    - Update COMPOSE_FILE accordingly:
        For production

        ```bash
            ./.docker/docker-compose.yml:./.docker/docker-compose.prod.yml
        ```

        For development

         ```bash
                ./.docker/docker-compose.yml:./.docker/docker-compose.dev.yml
        ```

3. Update Dockerfile and docker-compose files accordingly

4. Run the following command:

    ```bash
        cp .env.example .env
    ```

    and update accordingly

5. To run locally, you need to have docker install. You must run the following command from the root directory:

    ```bash
        docker compose up -d --build
    ```

    and go to localhost:8000

6. To run django commands, such as the ones listed below, you can do it inside the DJANGO container or first the following command:

    ```bash
        docker exec -it django-template-backend /bin/sh
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

    ```bash
        docker compose stop
    ```

- To delete containers run the following commands

    ```bash
        docker compose down
    ```
