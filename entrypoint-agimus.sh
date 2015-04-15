#!/bin/bash

set -e

echo "--------------------------------------------------------------------------------------------------"
echo "-"
echo "-   Start docker container"
echo "-"
echo "--------------------------------------------------------------------------------------------------"


#start elasticsearch
mkdir -p /persistant/data-es
chown elasticsearch: /persistant/data-es
gosu root "/etc/init.d/elasticsearch" "start"

#start kibana
gosu root "/etc/init.d/kibana" "start"

sleep 10
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "-"
echo "-   Finalize Elasticsearch configuration"
echo "-"
echo "--------------------------------------------------------------------------------------------------"
# create template logstash
echo "Create elasctisearch template for logstash index"
curl -sL -XPUT "http://localhost:9200/_template/logs_agimus?pretty" -d "@/dockerData/es_template_logstash.json"

# create template ldap
echo "Create elasctisearch template for LDAP index"
curl -sL -XPUT "http://localhost:9200/_template/ldap?pretty" -d "@/dockerData/es_template_ldap.json"

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

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "-"
echo "-   NOTICE"
echo "-"
echo "--------------------------------------------------------------------------------------------------"

wget --quiet https://raw.githubusercontent.com/marchal-julien/docker-agimusng/master/README.md -O /tmp/README.md
more /tmp/README.md
echo "--------------------------------------------------------------------------------------------------"
echo ""
echo ""
rm -f /tmp/README.md

echo "Press key to run shell in container"
read key

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
#exec "/bin/bash"