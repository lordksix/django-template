FROM python:3.11
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
RUN addgroup --system user && adduser --system --group user
RUN apt-get update -y && \
    apt-get install -y netcat-traditional && \
    apt-get install -y gcc python3-dev musl-dev libmagic1 libffi-dev libzmq3-dev git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt
COPY ./entrypoint.sh "$APP_HOME"
RUN sed -i 's/\r$//g' "$APP_HOME"/entrypoint.sh
RUN chmod +x "$APP_HOME"/entrypoint.sh

COPY . "$APP_HOME"
USER user
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
