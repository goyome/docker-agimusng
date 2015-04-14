#!/bin/bash

set -e

#start elasticsearch
mkdir -p /persistant/data-es
chown elasticsearch: /persistant/data-es
gosu root "/etc/init.d/elasticsearch" "start"

#start kibana
gosu root "/etc/init.d/kibana" "start"

sleep 8
# create template logstash
echo "Create elasctisearch template for logstash index"
code=$(curl -sL -w "%{http_code}" -XPUT "http://localhost:9200/_template/logs_agimus?pretty" -d "@/dockerData/es_template_logstash.json")
if [[ $code != "200" ]]
	then
	echo "ERROR : Create elasctisearch template for logstash index"
fi

# create template ldap
echo "Create elasctisearch template for LDAP index"
code=$(curl -sL -w "%{http_code}" -XPUT "http://localhost:9200/_template/ldap?pretty" -d "@/dockerData/es_template_ldap.json")
if [[ $code != "200" ]]
	then
	echo "ERROR : Create elasctisearch template for LDAP index"
fi

# create logstash index
indexName="logstash-$(date +"%Y.%m.%d")"
TODAYIndex=$(curl -sL -w "%{http_code}" -XHEAD "http://localhost:9200/${indexName}"); 
if [[ $TODAYIndex == "200" ]]
  then
	echo "Index \"${indexName}\" already exist"
  else
	echo "Create elasctisearch index for \"${indexName}\""
	curl -XPUT "http://localhost:9200/${indexName}?pretty" -d '{}'
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"