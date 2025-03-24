#!make

# run|default -- start docker, add domains
# stop -- stop docker, remove domains
# mysql -- connect to mysql cli
# nginx -- connect to nginx cli
# mr file=name -- restore mysql from file
# mm file=name -- restore mysql from project ./.db/ file
# init -- clone git, create DB, download and restore mysql backup, add ssl, cs-cart routine, run

-include .env || true

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

db-bash:
	docker exec -it ${MYSQL_REMOTE_HOST} bash

# nginx connect
nginx:
	docker exec -it $(NGINX_CONTAINER_NAME) /bin/sh

bash:
	make nginx;

# mysql restore
mr:
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --file_name $(file)
# ./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --file_name $(file) 2>/dev/null

# mysql migraions from project folder
mm:
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --file_name ../app/www/.db/migrations/$(file)
# ./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --file_name ../app/www/.db/migrations/$(file) 2>/dev/null

# mysql migraions from project folder
show_migration_files:
	ls -altA ./app/www/.db/migrations/

# sphinx
sphinx:
	docker exec -it ${CONTAINER_PREFIX}sphinx /bin/sh

sphinx-indexer:
	docker exec -it ${CONTAINER_PREFIX}sphinx indexer --all --rotate

regenerate-ssl:
	./config/scripts/reinit_ssl --domain_list $(DOMAIN_LIST) --nginx_container_name $(NGINX_CONTAINER_NAME)

<<<<<<< HEAD
=======
update-database-from-live:
	./config/scripts/update_database_from_live

>>>>>>> f90efc7 (update_database_from_live)
cli-7.3:
	docker exec -it ${CONTAINER_PREFIX}php7.3 bash

cli-7.4:
	docker exec -it ${CONTAINER_PREFIX}php7.4 bash

cli-8.0:
	docker exec -it ${CONTAINER_PREFIX}php8.0 bash

php:
	make cli-7.4

# init
init:
# create db
	./config/scripts/mysql_restore --root_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB)  --not_cscart $(NOT_CSCART) --additional_check Y 2>/dev/null
# add local_conf, ssl
	./config/scripts/init_scripts --db_pass ${MYSQL_ROOT_PASSWORD} --remote_host $(MYSQL_REMOTE_HOST) --db_name $(MYSQL_DB) --domain_list $(DOMAIN_LIST) --nginx_container_name $(NGINX_CONTAINER_NAME) --not_cscart $(NOT_CSCART)

install:
	./config/scripts/install