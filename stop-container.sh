docker ps | grep hadoop-slave | awk '{print $1}' | xargs docker stop
docker ps | grep hadoop-master | awk '{print $1}' | xargs docker stop
