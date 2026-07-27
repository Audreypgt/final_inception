*This activity has been created as part of the 42 curriculum by apeuget*

# Inception

## Description
This activity consists in the creation of a virtual machine with a graphical interface and the use of Docker to create 3 containers for 3 services: NGINX, MariaDB and Worpress. Images for these containers will be made from the penultimate stable version of the chosen OS, therefore, making the images from scratch. Docker Compose with a Makefile will be used to automate the image building and launching of the whole project.

An explanation of the use of Docker is available in the DEV_DOC.md file.

### Virtual Machines vs Docker
Docker is a virtualization software just like a virtual machine, but is way less heavy and doesn't require its own OS. It packages apps in a container with all necessary dependencies, configurations, system tools and runtime, librairies, environment configurations, and makes it really easy to share and distribute, with just one command to deploy a whole project.
DOcker virtualizes the OS app layer only, while VMs virtualizes the whole OS with the kernel.

### Secrets vs Environment Variables
Secrets allow you to securely transmit confidential data only to containers that need it, they are encrypted during transmit and stay in the container's files while it is running only, whereas environment variables are usually stored in .env file where there is no encryption and a risk of pushing this file on github, the data also stays in the container when it's not running

### Docker Network vs Host Network
Docker network allows containers to connect to and communicate with each others and non-Docker network services isolated from the host machine, whereas host networks allows containers to share the same network as the local host, the containers then don't get their own IP addresses, that can be useful to optimize performance or in situations where a container needs to handle a range of ports

### Docker Volumes vs Bind Mounts
Volumes store data on your host machine, Docker handles everything itself, the data stored on the host machine is not destined to be modified, this is what bind mounts are for, bind mounts allow you to share a folder with your container basically, you can modify in real time the files on your local host and changes will be applied in your container, you also have to handle it yourself and give a specific path on the host machine  
--> In this project, we are asked for a volume that acts like a bind mount

### Technical choices
I chose to use Debian as I had already used it for Born2BeRoot, therefore it was an OS I knew how to operate.

I took the liberty to download and use wp-cli to make the wordpress configuration file easier and clearer. This also allowed me to install Wordpress, create users and change the website's theme very easily.

## Instructions
Prerequesites: Docker, Make, VirtualBox and a Virtual Machine

- Use `make start` to start Docker
- Use `make up` to build and launch the project, check every container properly started with `make check`
- Go to https://apeuget.42.fr/ or to https://localhost:443/, if you get a 502 bad getway error, wait a 5 seconds and refresh, wordpress might not have finished starting up

## Resources

### Inception guide
- [Guide 42](https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671)

### Youtube Tutorials
- [Docker Setup Wordpress, no MariaDB](https://www.youtube.com/watch?v=GG2k-La5t3o)
- [Nginx/MariaDB/Wordpress, no Docker](https://www.youtube.com/watch?v=_VEooTNOvew)

### Docker
- [Install Docker](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
- [Docker-compose up vs docker-compose run](https://stackoverflow.com/questions/33066528/should-i-use-docker-compose-up-or-run)

### Setting up mariadb
- [Setting up mariadb](https://oneuptime.com/blog/post/2026-01-16-docker-mysql-mariadb/view)

### Nginx
- [Certificate user info](https://www.ibm.com/docs/en/ibm-mq/7.5.0?topic=certificates-distinguished-names)
- [Write nginx config file](https://nginx.org/en/docs/beginners_guide.html#conf_structure)
- [Nginx daemon off](https://labex.io/questions/what-is-the-purpose-of-the-nginx-g-daemon-off-command-in--871954)
- [Nginx dockerfile example](https://github.com/ADILRAQ/Inception-42-cursus/blob/main/srcs/requirements/nginx/Dockerfile)
- [Understand nginx conf](https://www.nicelydev.com/nginx/comprendre-nginx-conf)
- [Doc](https://nginx.org/en/docs/)

### Wordpress and wp-config
- [Config create usage](https://make.wordpress.org/cli/handbook/references/config/)
- [Config create usage](https://developer.wordpress.org/cli/commands/config/create/)
- [Core install usage](https://developer.wordpress.org/cli/commands/core/install/)
- [Tuto install wordpress and wp-cli](https://xtom.com/blog/how-to-install-wp-cli-on-debian-12-and-setup-a-new-wordpress-website-via-ssh/)
- [Tuto install wordpress and wp-cli](https://helpdocs.hostmyservers.fr/en/docs/cloud/linux/applications/wordpress-wpcli-install/)
- [Theme install](https://developer.wordpress.org/cli/commands/theme/install/)
- [Theme install, more complete](https://www.undefined.fr/snippets-wordpress/types/wp-cli/themes-wp-cli/)

### Volumes
- [Local driver meaning](https://www.codestudy.net/blog/docker-compose-volumes-driver-local-meaning/)

### Network
- [Bridge explanation](https://www.nicelydev.com/docker/reseau-host-bridge)
- [Docker doc](https://docs.docker.com/engine/network/)
- [Docker host network](https://docs.docker.com/engine/network/drivers/host/)

### Secrets
- [How-to](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/secrets/)

Some AI was used to help debug when peers weren't available or didn't know how to fix it

HUGE thanks to Benjamin and [Marie](https://github.com/Marieh25) who absolutely carried me for this project