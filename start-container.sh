#!/bin/bash

# the default node number is 3
N=${1:-3}


docker ps | grep hadoop-slave | awk '{print $1}' | xargs -I{} docker stop {}
docker ps | grep hadoop-master | awk '{print $1}' | xargs -I{} docker stop {}

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                -v ~/repos/huo-algos/week03/mapred:/root/mnt \
                kiwenlau/hadoop:1.0 &> /dev/null 


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                kiwenlau/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
