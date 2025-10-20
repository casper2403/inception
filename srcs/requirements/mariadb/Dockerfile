FROM debian:bullseye

RUN apt update && apt install -y mariadb-server
RUN sed -i 's|bind-address\s*=.*|bind-address = 0.0.0.0|' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 3306

CMD ["/tmp/setup.sh"]
