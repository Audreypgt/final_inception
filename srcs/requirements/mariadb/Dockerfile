FROM debian:bookworm

EXPOSE 3306

RUN apt-get update -y \
    && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy script to bin folder and add exec rights to be able to execute it
COPY ./tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh

ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]