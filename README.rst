CS-Cart Docker Environment
==========================


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

``%DATE%`` is replaced with today's date (``YYYYMMDD``), falling back to yesterday if not found.
Multiple files can be comma-separated: ``db.%DATE%.sql.zst,media.%DATE%.sql.gz``


Make Commands
-------------

Setup
~~~~~

================  ===================================================================
Command           Description
================  ===================================================================
``make install``  First-time setup: copy configs, clone repo, init DB, generate SSL
``make init``     Create DB, add local_conf.php, generate SSL certificates
================  ===================================================================

Docker Lifecycle
~~~~~~~~~~~~~~~~

================  ===================================================================
Command           Description
================  ===================================================================
``make run``      Build and start containers, update /etc/hosts
``make stop``     Stop containers, clean up /etc/hosts
================  ===================================================================

Database
~~~~~~~~

=====================================  =========================================
Command                                Description
=====================================  =========================================
``make mysql``                           Connect to MySQL CLI as root
``make db``                              Alias for ``make mysql``
``make db-bash``                         Open bash shell in MySQL container
``make mr file=<path>``                  Restore MySQL from SQL file
``make mm file=<name>``                  Restore from ``app/www/.migrations/<name>``
``make show_migration_files``            List migration files
``make update-database-from-live``       Download and restore DB from live server
=====================================  =========================================

Shell Access
~~~~~~~~~~~~

================  ===================================================================
Command           Description
================  ===================================================================
``make nginx``    Open shell in Nginx container
``make bash``     Alias for ``make nginx``
``make php``      Open bash in PHP 7.4 container (default)
``make cli-7.3``  Open bash in PHP 7.3 container
``make cli-7.4``  Open bash in PHP 7.4 container
``make cli-8.0``  Open bash in PHP 8.0 container
================  ===================================================================

Sphinx Search
~~~~~~~~~~~~~

========================  =====================================================
Command                   Description
========================  =====================================================
``make sphinx``           Open shell in Sphinx container
``make sphinx-indexer``   Run Sphinx indexer with ``--all --rotate``
========================  =====================================================

Logs
~~~~

========================  ===================================================
Command                   Description
========================  ===================================================
``make php_logs``           Show last 50 lines of PHP container logs
``make nginx_logs``         Show last 30 lines of Nginx container logs
========================  ===================================================

Other
~~~~~

================================  ===================================================
Command                           Description
================================  ===================================================
``make migrate``                    Run CS-Cart migration (PHP 7.4)
``make generate_logs_table``        Create cscart_logs table if missing
``make regenerate-ssl``             Regenerate SSL certificates for configured domains
``make clear_cscache``              Clear CS-Cart cache (``app/www/var/cache/``)
================================  ===================================================


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
    # REMOVE_BCK_TYPE=curl|scp
    # REMOVE_BCK_URL=https://example.com/backups/
    # REMOVE_BCK_USER=user
    # REMOVE_BCK_PWD=password
    # REMOVE_BCK_FILES=dbname.%DATE%.sql.zst,dbname2.%DATE%.sql.gz

