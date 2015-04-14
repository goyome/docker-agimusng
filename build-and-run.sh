#!/bin/sh

CONTAINER_NAME=agimus-ng
PERSISTANT_PATH=/home/docker/local-persistent
ES_LOCAL_PORT=9200
KB_LOCAL_PORT=5601

docker build  -t ${CONTAINER_NAME} . 

sleep 5

echo ""
echo ""
echo ""

docker run -i -p ${ES_LOCAL_PORT}:9200 -p ${KB_LOCAL_PORT}:5601 -v ${PERSISTANT_PATH}:/persistant -t ${CONTAINER_NAME} /bin/bash