#!/bin/sh

echo 'Waiting for postgres...'

while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
    sleep 0.1
done

echo 'PostgreSQL started'

echo 'Running migrations...'
python manage.py migrate

echo 'Collecting static files...'
chmod -R 755 /usr/src/app/staticfiles
python manage.py collectstatic --no-input

exec "$@"
