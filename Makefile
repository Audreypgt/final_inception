start:
	@systemctl start docker

stop:
	@systemctl stop docker

check:
	@docker ps

up:
	@docker compose -f ./srcs/docker-compose.yaml up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yaml down

re:
	@docker compose -f ./srcs/docker-compose.yaml build --no-cache && docker compose -f ./srcs/docker-compose.yaml up -d --build

fclean:
	@cd ./srcs && docker compose down;\
 	docker system prune -a --volumes -f;\
	sudo rm -rf /home/apeuget42/data/mariadb/*;\
	sudo rm -rf /home/apeuget42/data/wordpress/*;\

.PHONY: start stop up down re fclean