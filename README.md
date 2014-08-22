# Virtuoso Transaction Log Parsing based rsine complement 

## Overview

This project aims to set up a testing environment to compare subscription and notifications services. 

The Subscription and Notification Services (SNS) considered are those that allow to the user to subscribe for notifications on specific changes to triples in an RDF Store. 

We are interested in performance test considering the following metrics:

* **Query response time**: Depending on the implementation of the Service may impact the performance of the RDF Store. Thus, a list of arbitrary queries are prepared to be able to test Store query response time.
* **Notification response time**: We want to know how quick the Service will notify the user of a given subscription.

## Installation 

### Prepare Python Environment to run the Transaction Log Parser
* ensure the python package manager ``pip`` is installed

    [sudo] easy_install pip 

* verify that ``python-dateutil`` and ``watchdog`` are installed

    pip list | grep -E "watchdog|dateutil"

* install if neccessary
	
	[sudo] pip install watchdog
	[sudo] pip install python-dateutil

### Prepare Your Virtuoso Instance

* enable ``CheckpointAuditTrail`` in the virtuosos.ini file of your database
    * set ``CheckpointAuditTrail`` to a non zero value see [Virtuoso Documentation for details](http://docs.openlinksw.com/virtuoso/backup.html)
* add the log dir to ``DirsAllowed``so that virtuoso can read the transaction log files
* install the stored procedure from ``trx_procedures.sql`` (you might need to adapt port, user and password in the isql call according to your environment)

    	$ cd <path to Virtuoso>
    	$ ./bin/isql 1111 dba dba < <path to subnot-testing>/trx_parse/trx_procedures.sql

## Usage

    python try_parser.py --help 

Above command gives usage information:

	Usage: python trx_parser.py -i <virt_isql_path> -l <virt_log_path> -s <virt_server_port> -u <virt_dba_user> -w <virt_dba_passwd> -r <rsine_host> -p <rsine_port>

	Options:
	  -h, --help            show this help message and exit
	  -i VIRT_ISQL_PATH, --virt_isql_path=VIRT_ISQL_PATH
	                        The path of the isql executable. Defaults to
	                        ./bin/isql
	  -l VIRT_LOG_PATH, --virt_log_path=VIRT_LOG_PATH
	                        The path where virtuoso transaction logs are written.
	                        Defaults to ./var/lib/virtuoso/db/
	  -s VIRT_SERVER_PORT, --virt_server_port=VIRT_SERVER_PORT
	                        The virtuoso server port. Defaults to 1111
	  -u VIRT_DBA_USER, --virt_dba_user=VIRT_DBA_USER
	                        The dba user. Defaults to dba
	  -w VIRT_DBA_PASSWD, --virt_dba_passwd=VIRT_DBA_PASSWD
	                        The dba password. Defaults to dba
	  -r RSINE_HOST, --rsine_host=RSINE_HOST
	                        The hostname of the server where the rsine service is
	                        running. Defaults to 127.0.0.1
	  -p RSINE_PORT, --rsine_port=RSINE_PORT
	                        The port the rsine services listens on. Defaults to
	                        2221

## ToDos

* add option ( -g, --graphs URI[,URI[,...]] ) to limit notifications to a list of graphs
* code refactoring
