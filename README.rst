Clone repository
make install
edit config (Min Required: CONTAINER_PREFIX, DOMAIN_LIST)
?enter git url

if didn't enter git
    go to app/www
    copy outside local_conf.php (git clone block to non empty folder)
    copy project
    return local_conf.php

DB backup
    mkdir ./bck/
    cp %directory%/file.sql ./bck/
    make mr file=file.sql



.env config
# =============================
# Required
# =============================

# Prefix for all container names. Must be unique per project to avoid conflicts
CONTAINER_PREFIX=test

# Comma-separated list of local domains added to /etc/hosts
DOMAIN_LIST=demo.cscart.local,demo2.cscart.local

# =============================
# Optional (derived from CONTAINER_PREFIX)
# =============================

# MYSQL_DB -- default: ${CONTAINER_PREFIX}
# MYSQL_REMOTE_HOST -- default: ${CONTAINER_PREFIX}Mysql
# NGINX_CONTAINER_NAME -- default: ${CONTAINER_PREFIX}Nginx

# =============================
# Optional (with hardcoded defaults)
# =============================

# HTTP_REMOTE_PORT -- default: 8080
# HTTPS_REMOTE_PORT -- default: 443
# MYSQL_ROOT_PASSWORD -- default: root
# MYSQL_REMOTE_PORT -- default: 33306
# PHPMYADMIN_PORT -- default: 8081
# NOT_CSCART -- default: N
# SPHINX_SphinxQL -- default: 9306
# SPHINX_SphinxAPI -- default: 9312



