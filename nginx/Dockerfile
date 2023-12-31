FROM nginx:stable-alpine

RUN mkdir -p /etc/nginx/conf.d/
RUN rm /etc/nginx/conf.d/*
COPY ./nginx/default.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

