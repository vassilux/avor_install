#!/bin/bash
#########################################################################################
#											
#											
#											
#											
#											
# Description : avor application installation				
# Author : vassilux
# Last modified : 2014-09-19 11:18:27 
########################################################################################## 

source /usr/src/scripts/common

#database user
ASTERISK_USER="asterisk";
ASTERISK_DB_PW="asterisk";
MYSQL_ROOT_PW=lepanos


SCRIPTPATH=$(cd "$(dirname "$0")"; pwd)

function dprint()
{
  tput setb 1
  level="$1"
  dtype="$2"
  value="$3"
  echo -e "\e[00;31m $dtype:$level $value \e[00m" >&2
}

function install_redis()
{
	apt-get install redis-server
	dprint 0 INFO "Redis server installed"
}

function install_mongodb()
{
	apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
	apt-get update
	apt-get install -y mongodb-org=2.6.1 mongodb-org-server=2.6.1 mongodb-org-shell=2.6.1 mongodb-org-mongos=2.6.1 mongodb-org-tools=2.6.1
	dprint 0 INFO "Mongodb server installed"
	mongoimport --db revor --collection users --file ${SCRIPTPATH}/mongo/users.json

}

function install_sql_part()
{
	cd ${SCRIPTPATH}/sql
	apt-get install libmyodbc
	dprint 0 INFO "MySql ODBC packages installed"
	#
	echo "CREATE DATABASE IF NOT EXISTS asteriskcdrdb;" | mysql -u root -p${MYSQL_ROOT_PW} -h127.0.0.1
	#
	mysql -u${ASTERISK_USER} -p${ASTERISK_DB_PW} -h127.0.0.1 asteriskcdrdb < ${SCRIPTPATH}/sql/create_cdr_table.sql
	mysql -u${ASTERISK_USER} -p${ASTERISK_DB_PW} -h127.0.0.1 asteriskcdrdb < ${SCRIPTPATH}/sql/create_cel_table.sql
	echo "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO ${ASTERISK_USER}@127.0.0.1 IDENTIFIED BY '${ASTERISK_DB_PW}';" | mysql -u root -p${MYSQL_ROOT_PW} -h127.0.0.1
}

function install_configuration_files()
{
	dprint 0 INFO "Installing the configurations files for asterisk and odbc..."
	DATE_STAMP=$(date +%Y%m%d-%H%M%S)
	cd ${SCRIPTPATH}/asterisk
	cp /etc/asterisk/cdr.conf /etc/asterisk/cdr.conf.${DATE_STAMP}.bkp
	cp etc_asterisk_cdr.conf.sample /etc/asterisk/cdr.conf
	#
	cp /etc/asterisk/cdr_mysql.conf /etc/asterisk/cdr_mysql.${DATE_STAMP}.bkp
	cp etc_asterisk_cdr_mysql.conf.sample /etc/asterisk/cdr_mysql.conf
	#
	cp /etc/asterisk/cdr_odbc.conf /etc/asterisk/cdr_odbc.${DATE_STAMP}.bkp
	cp etc_asterisk_cdr_odbc.conf.sample /etc/asterisk/cdr_odbc.conf
	#
	cp /etc/asterisk/cel.conf /etc/asterisk/cel.${DATE_STAMP}.bkp
	cp etc_asterisk_cel.conf.sample /etc/asterisk/cel.conf
	#
	cp /etc/asterisk/cel_odbc.conf /etc/asterisk/cel_odbc.${DATE_STAMP}.bkp
	cp etc_asterisk_cel_odbc.conf.sample /etc/asterisk/cel_odbc.conf
	#
	cp /etc/asterisk/res_odbc.conf /etc/asterisk/res_odbc.${DATE_STAMP}.bkp
	cp etc_asterisk_res_odbc.conf.sample /etc/asterisk/res_odbc.conf
	#
	cp /etc/odbc.ini /etc/odbc.ini.${DATE_STAMP}.bkp
	cp etc_odbc.ini.sample /etc/odbc.ini
	#
	cp /etc/odbcinst.ini /etc/odbcinst.${DATE_STAMP}.bkp
	cp etc_odbcinst.ini.sample /etc/odbcinst.ini
	dprint 0 INFO "Configurations files installed."
	dprint 0 INFO "I check mysql odbc connectivity...";
	isql -v mysql-asterisk asterisk asterisk
	dprint 0 INFO "So far so good. Please check the response of the isql executed command.";
}

function main()
{
	echo "SCRIPTPATH ${SCRIPTPATH}"
	dprint 0 INFO "avor installation started."
	dprint 0 INFO "Please if the target system has an internet access ?."
	dprint 0 INFO "Do you want to continue)? [y/N]";
	read prompt

	if [[ ${prompt} =~ [yY](es)* ]]; then
		echo ""
	else
  			dprint 0 INFO "Bye see you next time...";
  			exit 0
  	fi
  	#
	dprint 0 INFO "Do you want install redis server (optional)? [y/N]";
	read prompt
	if [[ ${prompt} =~ [yY](es)* ]]; then
  			install_redis
  	fi
  	#
  	dprint 0 INFO "Do you want install mongodb server (optional)? [y/N]";
	read prompt
	if [[ ${prompt} =~ [yY](es)* ]]; then
  			install_mongodb
  	fi

  	#old part
	install_sql_part
	install_configuration_files
	dprint 0 INFO "avor installation finished."
	dprint 0 INFO "Please restart asterisk application."
	dprint 0 INFO "Live well."
}

main






