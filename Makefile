#!make

# run|default -- start docker, add domains
# stop -- stop docker, remove domains
# mysql -- connect to mysql cli
# nginx -- connect to nginx cli
# mr file=name -- restore mysql from file
# mm file=name -- restore mysql from project ./.db/ file
# init -- clone git, create DB, download and restore mysql backup, add ssl, cs-cart routine, run

-include .env || true

ifeq ($(MYSQL_DB),)
MYSQL_DB := $(CONTAINER_PREFIX)
endif
HTTP_REMOTE_PORT ?= 8080
HTTPS_REMOTE_PORT ?= 443
MYSQL_ROOT_PASSWORD ?= root
MYSQL_REMOTE_PORT ?= 33306
PHPMYADMIN_PORT ?= 8081
PHPMYADMIN ?= N
NOT_CSCART ?= N
export CONTAINER_PREFIX
export DOMAIN_LIST
export MYSQL_DB
export HTTP_REMOTE_PORT
export HTTPS_REMOTE_PORT
export MYSQL_ROOT_PASSWORD
export MYSQL_REMOTE_PORT
export PHPMYADMIN_PORT
export NOT_CSCART

# Derived container names
MYSQL_HOST = $(CONTAINER_PREFIX)-mysql
NGINX_HOST = $(CONTAINER_PREFIX)-nginx

# phpMyAdmin service
ifeq ($(PHPMYADMIN),Y)
PMA_SERVICE = phpmyadmin
else
PMA_SERVICE =
endif

run:
	docker-compose up -d --build nginx mysql php7.4 $(PMA_SERVICE)
	./config/scripts/docker-host-remove --domain_list $(DOMAIN_LIST) --container_prefix $(CONTAINER_PREFIX)
	./config/scripts/docker-host-update --domain_list $(DOMAIN_LIST) --container_prefix $(CONTAINER_PREFIX) --phpmyadmin $(PHPMYADMIN)

stop:
	docker-compose down
	./config/scripts/docker-host-remove --domain_list $(DOMAIN_LIST) --container_prefix $(CONTAINER_PREFIX)

# mysql connect
mysql:
	mysql -u root -p${MYSQL_ROOT_PASSWORD} -h $(MYSQL_HOST)

db:
	make mysql

db-bash:
	docker exec -it $(MYSQL_HOST) bash

# nginx connect
nginx:
	docker exec -it $(NGINX_HOST) /bin/sh

bash:
	make nginx;

# mysql restore
mr:
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_HOST) --db_name $(MYSQL_DB) --file_name $(file)

# mysql migrations from project folder
mm:
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_HOST) --db_name $(MYSQL_DB) --file_name ../app/www/.migrations/$(file)

# mysql migrations from project folder
show_migration_files:
	ls -altA ./app/www/.db/migrations/

# sphinx
sphinx:
	docker exec -it $(CONTAINER_PREFIX)-sphinx /bin/sh

sphinx-indexer:
	docker exec -it $(CONTAINER_PREFIX)-sphinx indexer --all --rotate

regenerate-ssl:
	./config/scripts/reinit_ssl --domain_list $(DOMAIN_LIST) --container_prefix $(CONTAINER_PREFIX)

update-database-from-live:
	./config/scripts/update_database_from_live -dzr

cli-7.3:
	docker exec -it $(CONTAINER_PREFIX)-php7.3 bash

cli-7.4:
	docker exec -it $(CONTAINER_PREFIX)-php7.4 bash

cli-8.0:
	docker exec -it $(CONTAINER_PREFIX)-php8.0 bash

php:
	make cli-7.4

migrate:
	docker exec -it $(CONTAINER_PREFIX)-php7.4 php ./www/job_run_migration.php

# init
init:
# create db
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_HOST) --db_name $(MYSQL_DB) --not_cscart $(NOT_CSCART) --additional_check Y 2>/dev/null
# add local_conf, ssl
	./config/scripts/init_scripts --db_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_HOST) --db_name $(MYSQL_DB) --domain_list $(DOMAIN_LIST) --container_prefix $(CONTAINER_PREFIX) --not_cscart $(NOT_CSCART)

generate_logs_table:
	./config/scripts/generate_logs_table --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_HOST) --db_name $(MYSQL_DB)

install:
	./config/scripts/install

php_logs:
	@echo "\033[1;36m=== PHP $(CONTAINER_PREFIX)-php7.4 logs ===\033[0m"
	@docker logs $(CONTAINER_PREFIX)-php7.4 --tail 50 2>&1

nginx_logs:
	@echo "\033[1;32m=== Nginx $(CONTAINER_PREFIX)-nginx logs ===\033[0m"
	@docker logs $(CONTAINER_PREFIX)-nginx --tail 30 2>&1

clear_cscache:
	sudo rm -rf ./app/www/var/cache/*
