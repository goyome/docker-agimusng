# docker-agimusng
 1. Installer docker : http://docs.docker.com/installation/
 2. Cloner le repo git : "git https://github.com/marchal-julien/docker-agimusng docker-agimusng"
 3. cd docker-agimusng 
 4. Build the container : "docker build  -t agimus-ng ."
 5. Run container : "docker run -i -p 9200:9200 -p 5601:5601 -v ADAPT_PERSISTANT_PATH:/persistant -t agimus-ng /bin/bash"
 6. Use your browser
   1. go to elasticsearch : http://DOCKER_IP:9200
   2. go to KOPF (health dashboard): http://DOCKER_IP:9200/_plugin/kopf/
   3. go to Sense (request editor): http://DOCKER_IP:9200/_plugin/marvel/sense/
   4. go to Kibana : http://DOCKER_IP:5601
   
   