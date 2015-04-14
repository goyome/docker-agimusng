# docker-agimusng
 1. Installer docker : http://docs.docker.com/installation/
 2. Cloner le repo git : "git clone https://github.com/marchal-julien/docker-agimusng docker-agimusng"
 3. cd docker-agimusng 
 4. Build the container : "docker build  -t agimus-ng ."
 5. Run container : "docker run -i -p ES_LOCAL_PORT:9200 -p KB_LOCAL_PORT:5601 -v PERSISTANT_PATH:/persistant -t agimus-ng /bin/bash"
   1. ES_LOCAL_PORT : port out of container (local) to use elasticsearch
   2. KB_LOCAL_PORT : port out of container (local) to use kibana
   3. PERSISTANT_PATH :  path out of container (local) to store persistant data of container (must be a real path)
 6. Use your browser
   1. go to elasticsearch : http://DOCKER_IP:9200
   2. go to KOPF (health dashboard): http://DOCKER_IP:9200/_plugin/kopf/
   3. go to Sense (request editor): http://DOCKER_IP:9200/_plugin/marvel/sense/
   4. go to Kibana : http://DOCKER_IP:5601
   
   