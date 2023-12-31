# pylint: disable=E1101
import os

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand, CommandError

DJANGO_SUPERUSER_PASSWORD = os.environ.get(
    "DJANGO_SUPERUSER_PASSWORD",
    "admin",
)
DJANGO_SUPERUSER_USERNAME = os.environ.get(
    "DJANGO_SUPERUSER_USERNAME",
    "12345678",
)
DJANGO_SUPERUSER_EMAIL = os.environ.get(
    "DJANGO_SUPERUSER_EMAIL",
    "admin@fake.com",
)


class Command(BaseCommand):
    help = "Create superuser"

    def handle(self, *args, **options):
        try:
            user = User(
                email=DJANGO_SUPERUSER_EMAIL,
                username=DJANGO_SUPERUSER_USERNAME,
            )
            user.set_password(DJANGO_SUPERUSER_PASSWORD)
            user.is_superuser = True
            user.is_staff = True
            user.save()
            self.stdout.write(
                self.style.SUCCESS("Superuser created successfully"),
            )
        except Exception as e:
            self.stdout.write(
                self.style.ERROR("User already exists"),
            )
            raise CommandError(e)
