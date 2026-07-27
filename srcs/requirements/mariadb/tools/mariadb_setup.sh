#!/bin/bash

DB_ROOT_PASSWORD=$(cat run/secrets/db_root_password)
DB_USER_PASSWORD=$(cat run/secrets/db_user_password)
# run is a temporary folder inside the dockerfile while it is running, containing secrets

# debug : get commands output in terminal
# set -x
# stops immediately if exit other than 0
# set -e

chown -R mysql:mysql /var/lib/mysql 
chmod -R +x /var/lib/mysql
mkdir -p /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld

mariadbd --user=mysql --innodb-use-native-aio=0 &
# mariadbd is the mariadb daemon, we run it in background so
# that we can run commands on it

# wait for server to be ready before running mariadb commands
until mariadb-admin ping --silent; do
    sleep 1
done

mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS ${DB_DATABASE};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

wait

# alter user modifies root user's password when connected through host machine (local host) as opposed to 'root'@'%', % meaning
# everywhere
# \' \' used to escape database names or tables (useful if it contains special characters) or any of these
# so-called "identifiers" objects
# EOF allows shell to read all commands at the same time, this prevents me getting error "Access denied for user 'root'@'localhost' (using password: NO)"
# since the alter user command changes the root password and would need me to authenticate again