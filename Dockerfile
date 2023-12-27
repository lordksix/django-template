FROM python:3.11-alpine
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
COPY requirements.txt "$APP_HOME"
RUN addgroup -S appgroup && adduser -S user -G appgroup
RUN apk update && \
    apk add gcc python3-dev musl-dev postgresql-dev && \
    rm -rf /var/cache/apk/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt --no-cache-dir
COPY ./entrypoint.sh "$APP_HOME"
RUN sed -i 's/\r$//g' "$APP_HOME"/entrypoint.sh
RUN chmod +x "$APP_HOME"/entrypoint.sh

COPY . "$APP_HOME"
USER user
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
