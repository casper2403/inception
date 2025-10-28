FROM debian:bullseye

RUN apt update && apt install -y php php-fpm php-mysql wget curl tar
RUN apt update && apt install -y php-cli

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzf latest.tar.gz && mv wordpress/* . && rm -rf wordpress latest.tar.gz

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php
RUN chown -R www-data:www-data /run/php
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

EXPOSE 9000

CMD ["setup.sh"]
