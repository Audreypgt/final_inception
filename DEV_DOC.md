Website:  
https://localhost:443/  
https://apeuget.42.fr/


# 1st step DOCKER: 
- install Docker (check Docker documentation)
- start docker `sudo systemctl start docker` or make start

# 2nd step NGINX: 
- write dockerfile for NGINX  
CMD: instruction to be executed everytime the RUN (meaning docker run I think) command is executed, only if no argument is passed with RUN, otherwise, it is overidden by the arguments
ex:
    ENTRYPOINT ["echo", "Hello from"]
    CMD ["Docker"]
        -->  Hello from Docker
    docker run myimage World
        --> Hello from World
- dockerfile, script and configuration file
- check website, there should be a 404 or 403 (or another one I don't remember) 

# 3rd step MARIADB:
- docker file and configuration file
- .env and secret files

# 4th step WORDPRESS:
- docker file, script (to create wp-config.php, 2nd user and install theme) and skip the "famous 5 min installation process", www.conf (modify listen line to the correct port), theme (zip file)

#### Install a theme
- Download the theme files on your host machine, unzip it and take the folder inside it out and rezip this folder
- Add this zipped folder to your files (I put it in the tools folder of the container)
- COPY it to your container in the var/www/wordpress/wp-content/themes folder
- Add the correct commands to the bash configuration script (wp theme install) --> you need this command twice to dezip and install the theme and then to activate it

# As you go (when needed):
- docker-compose file
- change your localhost IP to domain name
- docker volumes
- .env file
- docker secrets (optional)

#### Change your localhost IP to your domain name
- Go to file /etc/hosts
- Add following line : "127.0.0.1 domain_name"
- Also change the IP address in /etc/resolv.cnf file to 8.8.8.8
#### Set up Docker volumes
- Create 2 folders at `/home/your_login/data/` : `wordpress` and `mariadb` (you can make it automatic if needed by creating a bash script that will run on your host machine, and running it with make)
- Create a volumes section at the end of your docker-compose file
    - Device is the place on your local machine o: bind is to specify that you're not really making a volume, but a bind-mount
    - Driver defines the docker driver to be used, can be local for data stored on the host machine, cloud or network for shared storage data
    - Driver opts lets you customize where and how the volume is stored on the host
    - Type specifies the filesystem type (eg ext4, tmpfs, or none for bind mounts)
    - O specifies the mount options (eg bind for bind mounts, ro for read-only, size=1G for tmpfs)
    - Device is for the path to the host device directory or special value (eg tmpfs for in-memory storage), where data will be stored on host machine
- Create a volumes section for each container that needs it in the services section
    - The structure is "local host folder: container folder", so for our volume: "the volume you created: the folder of your container it copies"
    - To mount and copy files from your local host to your container without creating a volume, use the same structure and add `:x/r/w` at the end to choose what rights you give the container on the given file
#### Set up Docker secrets
- In docker-compose.yaml, create a `secrets` section at the end of your file and add all the variables with the path to each corresponding file
    - Driver: bridge is the default, it creates a network where only the containers inside it can communicate completely isolated from the host machine's network (opposite is mode host)
- Add a `secrets` variable to your service image in `services` and add only the variables your container needs 
- At the top of the file where you need your secret variables, declare your variables as follow / DB_VAR=$(cat /run/secrets/db_var), run/secrets in the place on your container where the secrets are stored
- In your .txt file, you can either put the secret directly or format it as SECRET="secret"
- Note that you don't need to declare an "env_file" variable in your service image in the services section if you use only docker secrets

# Useful commands
- `docker-compose ps` to find docker conts in that docker compose environment
- `docker image ls` to check images
- `docker run --name [name] [img_name]` to start image
- `docker run -it --name nginx bash` to run a container
- `docker ps -a` to see started and stoppped conts
- `docker container prune` to delete all conts even stopped ones, see whole command in makefile
- `nginx -s reload` if you modify your container after running it or just docker compose up it again with make up
- `service --status-all` check all running services in a container (use docker exec -it to go inside the cont)
- `mkdir -p` creates all folders recursively, for ex /etc/nginx/ssl will create the parents etc and its 2 childs
- `chown -R`: changes a file/folder's owner and group rights recursively (R)
- `chown user:group` to modify both at the same time

### Test Mariadb is correctly setup
check the DB:
- go into container `docker exec -it mariadb bash`
- `mariadb-check -A` (-A == all databases)
- check the DB is launched `mariadb-admin ping`
- log into DB `mariadb -u root -p`
- try these commands:
    - `SHOW DATABASES;`
    - `SELECT user, host FROM mysql.user;` (you should see the users we created and the % under host)
    - `SHOW GRANTS FOR 'db_user'@'%';`
- if this fails go back to your container and check your env variables were correctly set:
    - `echo $DB_NAME`
    - `echo $DB_USER`
    - `echo $DB_PASSWORD`
    - `echo $DB_ROOT_PASSWORD`

### Check if container restart policy is as written in compose file (yes the container can disobey you apparently)
`docker inspect cont_name --format="{{.HostConfig.RestartPolicy.Name}}"`

### Check container logs
Use `docker logs [cont name]`


# Error handling/fixing:

### Error logs:
In case something does not work as expected, you might find out the reason in `access.log` and `error.log` files in the directory `/usr/local/cont_name/logs` or `/var/log/cont_name`

### Permission denied when make up:
https://www.hostinger.com/tutorials/how-to-fix-docker-permission-denied-error
Don't forget to reboot so changes take affect, use `id -nG` (target wordpress: failed to solve: process "/bin/sh -c apt-get update -y && apt-get install -y php php-mysql php-fpm wget && rm -rf /var/lib/apt/lists/*" did not complete successfully: exit code: 100 to check)
If you already added your user to docker group, try changing rights of ~/.docker folder from root to your user

**If it was working before, try executing your command in srcs without using make up (then you can just make clean and try make up again)**

### Network is unreachable:
"target mariadb: failed to solve: debian:bookworm: failed to resolve source metadata for docker.io/library/debian:bookworm: failed to do request: Head "https://registry-1.docker.io/v2/library/debian/manifests/bookworm": dial tcp [2600:1f18:2148:bc00:c80c:3676:30dd:a616]:443: connect: network is unreachable"  
-> change IP address in file etc/resolv.conf to 8.8.8.8 (DNS) to prevent being blocked

### Problem with env variables:
Check they were correctly setup with:
- `env` (you should only see variables from .env in plain text, and a path for the variables from secrets)

Or check just one with echo like:
- `echo $DB_NAME`
- `echo $DB_USER`
- `echo $DB_PASSWORD`
- `echo $DB_ROOT_PASSWORD`

Or in /run/secrets/ in your container if you're using docker secrets

### Check nginx sees wordpress files:
- get in the container with docker exec
- go to /var/www/html
- use `ls`
- if needed, check /var/log/nginx/error.log

### 502 bad gateway:
Nginx can't communicate with php or the upstream host or the docker container
How to fix it:
- i think the issue was that i didnt have a cmd or entrepoint command in my wordpress dockerfile, so i added this : CMD ["/usr/sbin/php-fpm8.2", "-F"] (this can be removed when the wp-config.php creation script is launched with entrypoint as the script has this command)
- could be that you refreshed the website too fast and the 5 sleep before the wordpress script starts hasn't ended yet

### Error establishing a database connection:
Error caused by a bad wp-config.php file or by a connection problem between wordpress and mariadb, in my case it was caused by a connection problem
In wordpress container's terminal:
- check if wordpress can communicate with mariadb: `ping mariadb`, if you get something, this means networking is fine and the containers can communicate, or skip this step if ping isn't available on the container and you don't want to install it
- check `nc -zv mariadb 3306` or `echo > /dev/tcp/mariadb/3306 && echo 'PORT OPEN' || echo 'PORT CLOSED'` if nc isn't available
In mariadb containers's terminal:
- check if mariadb (the database, the process, not the container) is running with `ps aux`
- here i modified the launch command for mariadb from `mysqld_safe` to `mysqld_safe &`, then ps aux again but nothing changed
- check the mariadb logs with docker logs (here i had this errors : mysqld_safe Logging to syslog.  mysqld_safe Starting mariadbd daemon with databases from /var/lib/mysql)
- check the rights on the /var/lib/mysql folder with `ls -la`, here my rights are okay, but i had a lot of .pid files from previous containers
- clean those pid files and check for a stale socket with `rm -f /var/lib/mysql/*.pid && rm -f /run/mysqld/mysqld.sock` and restart the container with docker restart
- if this didn't fix it, run mysql with logs going to the output `mysqld --user=mysql 2>&1 | head -50`
- try to find solutions according to the errors seen
- in my case, the problem is that the volume folder (data) on the local host is never cleaned even when containers are deleted --> I added the rm commands in my makefile for this
- after fixing the issues, check the previous steps (test port 3306, check the available processes in the mariadb container, check the error logs) and check the database connection from the mariadb container `mariadb -h mariadb -u user -p1234 mariadb`
- if you don't see anything that seems wrong, check the website


# Glossary:
- Docker-compose: file to automate the build of images and launch of containers
    - container_name: note that compose does not scale a service beyond one container if the compose file specifies a container_name (which is what we do)
    - ports: defines the accessible ports by the host machine
    - restart unless-stopped: better than on-failure as it handles more cases where the container needs restart, such as a lost network connexion, being blocked following an internal error which isn't detected as an error by the system. Unless-stopped is similar to always but it won't restart when stopped manually on-failure will restart only when there is an exit code other than 0
    - depends-on: order = database -> wordpress -> nginx 
        - wordpress needs to find its database to start, otherwise it will raise errors, and nginx, our server, needs to find the service it's made to connect to, otherwise it will raise a "502 Bad Gateway" error
        - image: we build a house with the foundations (DB), the walls (WordPress), then the door (NGINX)

- Dockerfile: where we define our service's image
    - FROM: allows us to tell Docker which image to get based on, in this project, using FROM debian, we basically have an empty shell container
    - RUN apt-get update -y: updates list of available packages and their versions ; upgrade: installs newer versions
        - -y : apt will ask if we want to continue with installation, -y allows us to answer before hand so it doesn't stop to get our input
    - RUN apt-get install -y nginx openssl: this is when our container becomes a the actual service we want, in this nginx
    - RUN rm -rf /var/lib/apt/lists/*: deletes temp files used for installation of services
    - EXPOSE: sed when making the network, allows us to choose to expose a port to the other conts ; 443 is the port to access https

- **Nginx**: free and open source HTTP web server that can also be used as reverse proxy, content cache, load balancer, TCP/UDP proxy server and mail proxy server

- TLS: cryptographic protocol providing communication security over an internet network
- OpenSSL: tool for handling and creating SSL certificates

- www-data: user and group created by debian by default because the security convention is that a web server shouldn't run on root, this role and group are then created for that, which is a role priviledged only to run web pages, and restricted from anything else on the system (eg dl softwares, read psswds...)

- **MariaDB**: open source relational database, fork of mySQL that is opensource and community developped

- **Wordpress**: free and open source web content management system (software used to manage the creation and modification of digital content), written in PHP and used with mySQL or MariaDB, provides website authoring, collaboration, and administration tools that help users with little knowledge of web programming or markup languages create and manage website content

- Fpm: used to hook wp cont to nginx, by configuring some php supports so nginx knows how to run php when it receives a request from the browser (this is the location ~ \.php$ part in our nginx config file), it allows communication between a web server and php through the FastCGI protocol (interface specification allowing external apps to interact with web servers)

- Volumes / Bind mounts: volumes store data on your host machine, Docker handles everything itself, the data stored on the host machine is not destined to be modified, this is what bind mounts are for  
In this project, we are asked for a volume that acts like a bind mount
    - Notes: They don't only allow you to copy your service's files from the container to the host, but also to allow your server to see your wordpress files, therefore, without our wordpress volume, nginx can't access the website's files and therefore we get a 404 error if we try opening it on a web browser

- Bind-mounts: bind mounts allow you to share a folder with your container basically, you can modify in real time the files on your local host and changes will be applied in your container, it's like opening a direct portal between your host and container, this is ideal for dev environments where you need real-time file access and sharing, you also have to handle it yourself, and give a specific path on the host machine

- Docker network: process where containers connect to and communicate with each others and non-Docker network services

- Docker secrets: blob of data (psswrd, username, SSH private key, TLS certificates,...) that shouldn't be transmitted over a network or stored unencrypted in any accessible file, allows you to securely transmit these data only to containers that need it, secrets are encrypted during transmit and stay in a Docker swarm  (one or more nodes: physical or virtual machines running docker engine) during the container is running only
