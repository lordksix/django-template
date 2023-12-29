FROM python:3.11-alpine AS base
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV COLUMNS 80
ENV HOME=/usr/src
ENV APP_HOME=/usr/src/app
RUN mkdir "$APP_HOME"
RUN mkdir "$APP_HOME"/staticfiles
RUN mkdir "$APP_HOME"/mediafiles
WORKDIR "$APP_HOME"
COPY ./django/requirements.txt "$APP_HOME"
RUN addgroup -S appgroup && adduser -S user -G appgroup
RUN apk update && \
    apk add gcc python3-dev musl-dev postgresql-dev && \
    rm -rf /var/cache/apk/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt --no-cache-dir
COPY .env "$APP_HOME"

FROM base AS development
COPY ./django/entrypoint-dev.sh "$APP_HOME"
RUN sed -i 's/\r$//g' "$APP_HOME"/entrypoint-dev.sh
RUN chmod +x "$APP_HOME"/entrypoint-dev.sh
COPY ./django/ "$APP_HOME"
USER user
ENTRYPOINT ["/usr/src/app/entrypoint-dev.sh"]

FROM base AS production
COPY ./django/entrypoint-prod.sh "$APP_HOME"
RUN sed -i 's/\r$//g' "$APP_HOME"/entrypoint-prod.sh
RUN chmod +x "$APP_HOME"/entrypoint-prod.sh
COPY ./django "$APP_HOME"
USER user
ENTRYPOINT ["/usr/src/app/entrypoint-prod.sh"]
