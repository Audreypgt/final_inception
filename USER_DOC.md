## Provided services
### Nginx
HTTP web server, software that includes several parts that control how web users access hosted files, it understands URLs (web addresses) and HTTP (the protocol browsers use to view webpages), it can be accessed through the domain names of the websites it stores, and it delivers the content of these hosted websites to the end user's device

### MariaDB
Open source relational database, based on MySQL

### Wordpress
Web content management system (software used to manage the creation and modification of digital content) providing website authoring, collaboration, and administration tools that help users with little knowledge of web programming or markup languages create and manage website content

*Check the glossary section in the dev doc for more in depth documentation*

## Detailed instructions
Prerequesites: Docker, Make, VirtualBox and a Virtual Machine

- Change your VM's localhost IP to the domain name
    - Go to file /etc/hosts
    - Add following line : "127.0.0.1 login.42.fr"
    - Also change the IP address in /etc/resolv.cnf file to 8.8.8.8
- Git clone the repository in your home folder
- Create 2 folders at `/home/your_login/data/` : `wordpress` and `mariadb` and, in the Makefile and the docker-compose.yaml file, change the paths from `/home/apeuget42/data/` to `/home/your_login/data/`
- cd inside the cloned repository
- Use `make start` to start Docker
- Use `make up` to build and launch the project, check every container properly started with `make check` (container should all show "up")
- Go to https://login.42.fr/ or to https://localhost:443/, if you get a 502 bad getway error, wait 5 seconds and refresh, wordpress might not have finished starting up
- For the administration panel, go to https://apeuget.42.fr/wp-admin/

- Use `make down` to stop containers and `make fclean` to delete everything, including volumes in the container and in the localhost (data folder)
- If you change anything to the files, use `make fclean` and `make re` to start clean and not reuse any cache from previous containers

## Locate and manage credentials
- For obvious security reasons, any credentials and environment variables are not provided in this repository
- At its root, create a folder named "secrets" and create one txt file for each username and each password, you should have only ONE information by txt file, for example db_root_password.txt contains "rootpassword1234" and db_user.txt contains "username42"
    - You need 7 of these files, the names should be:
        - db_user.txt
        - db_password.txt
        - db_root_password.txt
        - db_2nd_user.txt
        - db_2nd_user_password.txt
        - db_admin.txt
        - db_admin_password.txt
- In the srcs folder, create a file called .env and add this and replace the values with whatever you want:  
DB_NAME=adatabasename  
ADMIN_EMAIL=email@email.fr  
DOMAIN_NAME=login.42.fr
