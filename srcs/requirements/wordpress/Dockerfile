FROM debian:bookworm

EXPOSE 9000

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-curl \
    php8.2-gd \
    php8.2-zip \
    && rm -rf /var/lib/apt/lists/*
# wget used to install stuffs, just like curl does

RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && mkdir -p /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/config_script.sh /usr/local/bin/config_script.sh
RUN chmod +x /usr/local/bin/config_script.sh

ENTRYPOINT ["/usr/local/bin/config_script.sh"]