#!/usr/bin/env bash
CURRENTDIR=`pwd`
echo ${CURRENTDIR}

cd $TOMCAT_HOME

sh ./bin/shutdown.sh

cd ${CURRENTDIR}

exit 0
