CS-Cart Docker Environment
==========================


Prerequisites
-------------

Required (for installation)::

    sudo apt install docker.io docker-compose-v2 make pv

Optional (for database backups)::

    sudo apt install gzip unzip zstd curl openssh-client


Quick Start
-----------

::

    git clone <repo-url>
    make install
    cd app/www
    # copy your project files
    cp ../../config/files/local_conf.php ./
    mkdir -m777 ./var/cache


DB Backup Restore
-----------------

::

    mkdir ./bck/
    cp /path/to/file.sql ./bck/
    make mr file=file.sql


Update Database from Live
-------------------------

Download and restore a database backup from a remote server.

1. Add ``REMOVE_BCK_*`` variables to ``.env`` (see below)
2. Run ``make update-database-from-live``

**curl mode** (default) — download via HTTP basic auth::

    REMOVE_BCK_TYPE=curl
    REMOVE_BCK_URL=https://example.com/backups/
    REMOVE_BCK_USER=user
    REMOVE_BCK_PWD=password
    REMOVE_BCK_FILES=dbname.%DATE%.sql.zst

**scp mode** — download via SSH (uses ssh keys)::

    REMOVE_BCK_TYPE=scp
    REMOVE_BCK_URL=myhost:/var/www/db_bak/mydb/
    REMOVE_BCK_FILES=mydb.%DATE%.sql.zst

**ssh_dump mode** — run mysqldump on remote server via SSH, download result directly::

    REMOVE_BCK_TYPE=ssh_dump
    REMOVE_BCK_URL=user@host
    REMOVE_BCK_SSH_DB=dbname
    REMOVE_BCK_SSH_DB_USER=mysql_user
    REMOVE_BCK_SSH_DB_PASS=mysql_password
    REMOVE_BCK_IGNORE_TABLES=table1,table2
    REMOVE_BCK_STRUCTURE_ONLY=table3,table4

``%DATE%`` is replaced with today's date (``YYYYMMDD``), falling back to yesterday if not found.
Multiple files can be comma-separated: ``db.%DATE%.sql.zst,media.%DATE%.sql.gz``


.. include:: COMMANDS.rst


.env Config
-----------

Required
~~~~~~~~

::

    CONTAINER_PREFIX=test
    DOMAIN_LIST=demo.cscart.local,demo2.cscart.local

Optional (with defaults)
~~~~~~~~~~~~~~~~~~~~~~~~

::

    # MYSQL_DB=${CONTAINER_PREFIX}
    # MYSQL_USER=root
    # HTTP_REMOTE_PORT=8080
    # HTTPS_REMOTE_PORT=443
    # MYSQL_ROOT_PASSWORD=root
    # MYSQL_REMOTE_PORT=33306
    # PHPMYADMIN=N
    # PHPMYADMIN_PORT=8081
    # NOT_CSCART=N
    # SPHINX_SphinxQL=9306
    # SPHINX_SphinxAPI=9312
    # REMOVE_BCK_TYPE=curl|scp|ssh_dump
    # REMOVE_BCK_URL=https://example.com/backups/
    # REMOVE_BCK_USER=user
    # REMOVE_BCK_PWD=password
    # REMOVE_BCK_FILES=dbname.%DATE%.sql.zst,dbname2.%DATE%.sql.gz
    # REMOVE_BCK_SSH_DB=dbname
    # REMOVE_BCK_SSH_DB_USER=mysql_user
    # REMOVE_BCK_SSH_DB_PASS=mysql_password
    # REMOVE_BCK_IGNORE_TABLES=table1,table2
    # REMOVE_BCK_STRUCTURE_ONLY=table3,table4

