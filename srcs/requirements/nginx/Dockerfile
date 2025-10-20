FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY tools/nginx.crt /etc/nginx/ssl/nginx.crt
COPY tools/nginx.key /etc/nginx/ssl/nginx.key
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod 600 /etc/nginx/ssl/nginx.key /etc/nginx/ssl/nginx.crt

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
