#!/bin/bash

# script to create wp-config-sample.php (rename, inject variables (database name, user...), generate security keys)
# we make a script since the wp-config file is erased at every stop of the container

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_root_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)


until (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do sleep 1; done
# make sure database is ready

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    wp core download --path=/var/www/wordpress/ --allow-root

    wp config create --allow-root \
        --dbname=$DB_DATABASE \
        --dbuser=$DB_USER \
        --dbpass=$DB_USER_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'

    wp core install --allow-root \
        --url=https://$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress'

    wp user create --allow-root $WP_USER $WP_USER_EMAIL \
        --role=author --user_pass=$WP_USER_PASSWORD \
        --path='/var/www/wordpress'

    wp theme install --allow-root \
        https://downloads.wordpress.org/theme/twenty8teen.20250303.zip \
        --path=/var/www/wordpress
    
    wp theme activate --allow-root twenty8teen --path=/var/www/wordpress
fi

exec /usr/sbin/php-fpm8.2 -F
# starts php


# we can modify the example script given by wordpress:
# https://kaiten.design/how-to-automate-wordpress-and-wp-config-php-creation/
# or use wp-cli to create one, here we used wp-cli:
# https://make.wordpress.org/cli/handbook/guides/quick-start/


# really complex and thorough version to use one day maybe who knows
# https://blog.noah.hearle.com/wordpress-installer/