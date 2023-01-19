#!make

# run|default -- start docker, add domains
# stop -- stop docker, remove domains
# mysql -- connect to mysql cli
# nginx -- connect to nginx cli
# mr file=name -- restore mysql from file
# init -- clone git, create DB, download and restore mysql backup, add ssl, cs-cart routine, run

include .env

run:
	docker-compose up -d --build nginx mysql php7.4 phpmyadmin
	./config/scripts/docker-host-remove --domain_list $(DOMAIN_LIST) --mysql_remote_host $(MYSQL_REMOTE_HOST) --container_prefix $(CONTAINER_PREFIX)
	./config/scripts/docker-host-update --domain_list $(DOMAIN_LIST) --mysql_remote_host $(MYSQL_REMOTE_HOST) --nginx_container_name $(NGINX_CONTAINER_NAME) --container_prefix $(CONTAINER_PREFIX)

stop:
	docker-compose down
	./config/scripts/docker-host-remove --domain_list $(DOMAIN_LIST) --mysql_remote_host $(MYSQL_REMOTE_HOST) --container_prefix $(CONTAINER_PREFIX)

# mysql connect
mysql:
	mysql -u root -p${MYSQL_ROOT_PASSWORD} -h $(MYSQL_REMOTE_HOST)

db:
	make mysql

# nginx connect
nginx:
	docker exec -it $(NGINX_CONTAINER_NAME) /bin/sh

bash:
	make nginx;

# mysql restore
mr:
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --file_name $(file) 2>/dev/null

# sphinx
sphinx:
	docker exec -it ${CONTAINER_PREFIX}sphinx /bin/sh

sphinx-indexer:
	docker exec -it ${CONTAINER_PREFIX}sphinx indexer --all --rotate

# init
init:
# create db
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --additional_check Y 2>/dev/null

# add local_conf, ssl
	./config/scripts/init_scripts --db_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --domain_list $(DOMAIN_LIST) --nginx_container_name $(NGINX_CONTAINER_NAME)

cli-7.3: run
	docker exec -it php7.3 bash

cli-7.4: run
	docker exec -it php7.4 bash

cli-8.0: run
	docker exec -it php8.0 bash
