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
``make update-database-from-live``       Download and restore DB from live server (``skip_download=1`` to skip download)
=====================================  =========================================

Shell Access
~~~~~~~~~~~~

================  ===================================================================
Command           Description
================  ===================================================================
``make nginx``    Open shell in Nginx container
``make bash``     Alias for ``make nginx``
``make php``      Open bash in PHP 8.2 container (default)
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
``make migrate``                    Run CS-Cart migration (PHP 8.2)
``make generate_logs_table``        Create cscart_logs table if missing
``make regenerate-ssl``             Regenerate SSL certificates for configured domains
``make clear_cscache``              Clear CS-Cart cache (``app/www/var/cache/``)
``make info``                       Show this commands reference
================================  ===================================================
