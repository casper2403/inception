all:
	docker-compose -f srcs/docker-compose.yml up --build -d

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down -v
	docker system prune -af

re: down clean all

.PHONY: all down clean re

# docker exec -it mariadb mysql -u root -p
# when prompted enter: wp_pass
# SHOW DATABASES;
# USE wordpress;
# SHOW TABLES;
# SELECT * FROM wp_posts;