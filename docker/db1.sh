#!/bin/bash
name=db1
u=admin
p=password
#docker run -d -v /opt/couchbase/var/lib/couchbase/data/${name}:/opt/couchbase/var/lib/couchbase/data -p 8091-8094:8091-8094 -p 11210:11210 --name $name docker.io/couchbase
docker run -d -v /opt/couchbase/var/lib/couchbase/data/${name}:/opt/couchbase/var/lib/couchbase/data -p 8081:8091 --name $name docker.io/couchbase
echo "============[ Dockr run ]============"
docker ps
myip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' ${name})
sleep 20
echo "Myip: $myip"
echo "============[ Applying confi setup ]============"
sleep 5
curl -v -X POST http://${myip}:8091/pools/default -d memoryQuota=512 -d indexMemoryQuota=256
curl -v http://${myip}:8091/node/controller/setupServices -d services=kv%2cn1ql%2Cindex
#curl -v http://${myip}:8091/settings/web -d port=8091 -d username=Administrator -d password=password
curl -v http://${myip}:8091/settings/web -d port=8091 -d username=${u} -d password=${p}
echo "============-------------------------============"
