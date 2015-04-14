# docker-agimusng
 1. Installer docker : http://docs.docker.com/installation/
 2. Cloner le repo git : git https://github.com/marchal-julien/docker-agimusng docker-agimusng 
 3. cd docker-agimusng 
 4. build container : docker build  -t agimus-ng .
 5. run container : docker run -i -p 9200:9200 -p 5601:5601 -v ADAPT_PERSISTANT_PATH:/persistant -t agimus-ng /bin/bash
 6. use your browser
   1. go to elasticsearch : http://192.168.59.103:9200
   2. go to KOPF (health dashboard): http://192.168.59.103:9200/_plugin/kopf/
   3. go to Sense (request editor): http://192.168.59.103:9200/_plugin/marvel/sense/
   4. go to Kibana : http://192.168.59.103:5601
   