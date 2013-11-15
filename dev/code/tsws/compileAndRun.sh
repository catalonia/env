#!/usr/bin/env bash
CURRENTDIR=`pwd`
echo ${CURRENTDIR}
cd ${CURRENTDIR}
ant;

cd $TOMCAT_HOME

sh ${TOMCAT_HOME}/bin/shutdown.sh

#exit 0

rm $TOMCAT_HOME/logs/tslogs/*.log*;

cd ${CURRENTDIR}

ant deployWar

sh ${TOMCAT_HOME}/bin/startup.sh

#wait for a few seconds!
waitTime=1
while [ ${waitTime} -le 9 ]; do
echo "waitTime=${waitTime}"
((waitTime++))
sleep $waitTime
done

sh ${TOMCAT_HOME}/bin/shutdown.sh

#copy p6spy file
#cp ${HOME}/git/p6spy/p6spy/target/p6spy-2.0-SNAPSHOT.jar $TOMCAT_HOME/webapps/tsws/WEB-INF/lib/.
cp /Users/webonline/git/p6spy_config/p6spy-2.0-SNAPSHOT.jar $TOMCAT_HOME/webapps/tsws/WEB-INF/lib/.

cd $TOMCAT_HOME

sh ${TOMCAT_HOME}/bin/startup.sh

cd ${CURRENTDIR}