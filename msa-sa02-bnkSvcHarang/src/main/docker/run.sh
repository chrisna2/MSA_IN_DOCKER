#!/bin/sh
echo "********************************************************"
echo "Waiting for the eureka server to start on port $BNKREGSERVER_PORT"
echo "********************************************************"
while ! `nc -z bnkregserver $BNKREGSERVER_PORT`; do sleep 3; done
echo "******* Eureka Server has started"


echo "********************************************************"
echo "Waiting for the MARIADB database server to start on port $MARIADB_PORT"
echo "********************************************************"
while ! `nc -z mariadb $MARIADB_PORT`; do sleep 3; done
echo "******** MARIADB Database Server has started "

echo "********************************************************"
echo "Waiting for the configuration server to start on port $CONFIGSERVER_PORT"
echo "********************************************************"
while ! `nc -z bnkconfigsvr $BNKCONFIGSVR_PORT`; do sleep 3; done
echo "*******  Configuration Server has started"

echo "********************************************************"
echo "Waiting for the zookeeper server to start on port $KAFKASERVER_PORT"
echo "********************************************************"
while ! `nc -z zookeeper $KAFKASERVER_PORT`; do sleep 10; done
echo "*******  zookeeper Server has started"

echo "********************************************************"
echo "Waiting for the REDIS server to start  on port $REDIS_PORT"
echo "********************************************************"
while ! `nc -z redis $REDIS_PORT`; do sleep 10; done
echo "******* REDIS has started"


echo "********************************************************"
echo "Starting License Server with Configuration Service via Eureka :  $BNKREGSERVER_URI" ON PORT: $SERVER_PORT;
echo "License service will use $AUTHSERVER_URI for URI"
echo "Using Kafka Server: $KAFKASERVER_URI"
echo "Using ZK    Server: $ZKSERVER_URI"
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom -Dserver.port=$SERVER_PORT   \
     -Deureka.client.service-url.defaultZone=$BNKREGSERVER_URI             \
     -Dspring.cloud.config.uri=$BNKCONFIGSVR_URI                          \
     -Dsecurity.oauth2.resource.user-info-uri=$BNKAUTHSERVER_URI               \
     -Dspring.profiles.active=$PROFILE -jar /usr/local/harang/@project.build.finalName@.jar
