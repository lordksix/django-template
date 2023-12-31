#!/bin/sh

echo 'Waiting for postgres...'
echo 'POSTGRES_HOST...'
echo $POSTGRES_HOST
echo 'POSTGRES_PORT...'
echo $POSTGRES_PORT

while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
    sleep 0.1
done

echo 'PostgreSQL started'

echo 'Making migrations...'
python manage.py makemigrations
echo 'Running migrations...'
python manage.py migrate

echo 'Collecting static files...'
chmod -R 755 /usr/src/app/staticfiles
python manage.py collectstatic --no-input
chmod -R 755 /usr/src/app/staticfiles

echo 'Super user creation...'
python manage.py superuser || true

echo 'Starting server...'
uvicorn core.asgi:application --host 0.0.0.0 --port 8080 --workers 4 --log-level debug --reload
echo 'Server initiated... '

exec "$@"
