FROM debian
MAINTAINER "Julien MARCHAL <julien.marchal@univ-lorraine.fr>"

#
# Installation de base
#
RUN apt-get update
RUN apt-get install -y wget curl procps python
#sudo vim apt-utils 

RUN wget --quiet --no-check-certificate "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" -O /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu
	
#
# Definition des depots
#
RUN wget --quiet -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" > /etc/apt/sources.list.d/logstash.list
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update


#
# Installation Logstash
#
RUN apt-get install -y logstash logstash-contrib

# Installation du plugins logstash LDAP
RUN wget --quiet 'http://www.esup-portail.org/wiki/download/attachments/455770116/plugin_LDAP.tgz?version=1&modificationDate=1423823578000&api=v2' -O /opt/logstash/plugin_LDAP.tgz \
  && cd /opt/logstash/ \
  && tar -zxf /opt/logstash/plugin_LDAP.tgz \
  && rm -f /opt/logstash/plugin_LDAP.tgz

# Modification du plugins logstash elasticsearch
RUN mv /opt/logstash/lib/logstash/filters/elasticsearch.rb /opt/logstash/lib/logstash/filters/elasticsearch.rb.orig \
 && wget --quiet --no-check-certificate "https://raw.githubusercontent.com/greem/logstash-contrib/master/lib/logstash/filters/elasticsearch.rb" -O /opt/logstash/lib/logstash/filters/elasticsearch.rb

#
# Installation Elasticsearch
#
RUN apt-get install -y elasticsearch
RUN update-rc.d elasticsearch defaults 95 10

# Installation Elasticsearch/Kopf
RUN cd /usr/share/elasticsearch && /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

# Installation Elasticsearch/Marvel
RUN cd /usr/share/elasticsearch && /usr/share/elasticsearch/bin/plugin -install elasticsearch/marvel/latest

# Configure Elasticsearch
RUN echo 'cluster.name: Agimus' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'node.name: "Agimus1"' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'indices.fielddata.cache.size:  40%' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'http.cors.allow-origin: /http://localhost(:9200)?/' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'http.cors.enabled: true' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'marvel.agent.enabled: false' >> /etc/elasticsearch/elasticsearch.yml \
 && echo 'path.data: /persistant/data-es' >> /etc/elasticsearch/elasticsearch.yml
 
#
# Installation Kibana
#
RUN wget --quiet "http://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz" -O /opt/kibana-4.0.1-linux-x64.tar.gz 
RUN cd /opt/ \
  && tar -zxf /opt/kibana-4.0.1-linux-x64.tar.gz \
  && ln -s /opt/kibana-4.0.1-linux-x64 /opt/kibana \
  && rm /opt/kibana-4.0.1-linux-x64.tar.gz
  
RUN wget --quiet 'https://raw.githubusercontent.com/EsupPortail/agimus-ng/master/scripts/kibana4_init' -O  /etc/init.d/kibana \
  && chmod +x /etc/init.d/kibana \
  && update-rc.d kibana defaults 95 10

# Configure Kibana
RUN echo 'elasticsearch_url: "http://localhost:9200"' >> /opt/kibana/config/kibana.yml

# Install Python elasticsearch
RUN wget --quiet --no-check-certificate "https://bootstrap.pypa.io/get-pip.py" \
 && python get-pip.py \
 && pip install elasticsearch


ADD dockerData /dockerData

COPY entrypoint-agimus.sh /
RUN chmod +x /entrypoint-agimus.sh

ENV PATH /usr/share/elasticsearch/bin:/opt/kibana/bin:/opt/logstash/bin:$PATH

VOLUME /persistant

ENTRYPOINT ["/entrypoint-agimus.sh"]
 
EXPOSE 9200 9300 5601


# Clean up 
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
