FROM python:3
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV COLUMNS 80
WORKDIR /usr/src/app
COPY requirements.txt /usr/src/app/
RUN addgroup --system user && adduser --system --group user
RUN apt-get update -y && \
    apt-get install -y netcat-traditional && \
    apt-get install -y gcc python3-dev postgresql-dev musl-dev libmagic1 libffi-dev libzmq3-dev git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt
COPY ./entrypoint.sh /usr/src/app/
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

COPY . /usr/src/app/
USER user
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
