CS-Cart Docker Environment
==========================


Quick Start
-----------

::

    git clone <repo-url>
    make install

1. Edit ``.env`` (min required: ``CONTAINER_PREFIX``, ``DOMAIN_LIST``)
2. Optionally enter git URL when prompted

If you skipped git clone during install::

    cd app/www
    # save local_conf.php (git clone requires empty folder)
    # copy your project files
    # restore local_conf.php


DB Backup Restore
-----------------

::

    mkdir ./bck/
    cp /path/to/file.sql ./bck/
    make mr file=file.sql


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

Other
~~~~~

========================  ===================================================
Command                   Description
========================  ===================================================
``make migrate``            Run CS-Cart migration (PHP 7.4)
``make regenerate-ssl``     Regenerate SSL certificates for configured domains
``make clear_cscache``      Clear CS-Cart cache (``app/www/var/cache/``)
========================  ===================================================


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
    # HTTP_REMOTE_PORT=8080
    # HTTPS_REMOTE_PORT=443
    # MYSQL_ROOT_PASSWORD=root
    # MYSQL_REMOTE_PORT=33306
    # PHPMYADMIN=N
    # PHPMYADMIN_PORT=8081
    # NOT_CSCART=N
    # SPHINX_SphinxQL=9306
    # SPHINX_SphinxAPI=9312

