#!/bin/bash
name=db3
server_name=db1
u=admin
p=password
docker run -d -v /opt/couchbase/var/lib/couchbase/data/${name}:/opt/couchbase/var/lib/couchbase/data -p 8083:8091 --name ${name} docker.io/couchbase
echo "============[ Dockr run ]============"
docker ps
#sleep 20
myip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' ${name})
db1_ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' db1)
db2_ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' db2)
echo "Myip: $myip"
#echo "============[ Applying confi setup ]============"
#sleep 10
#curl -v -X POST http://${myip}:8091/pools/default -d memoryQuota=512 -d indexMemoryQuota=256
#curl -v http://${myip}:8091/node/controller/setupServices -d services=kv%2cn1ql%2Cindex
#curl -v http://${myip}:8091/settings/web -d port=8091 -d username=${u} -d password=${p}
echo "============[ Add Node in Cluster ]============"
server_ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' ${server_name})
echo "serverip: $server_ip"
#sleep 10
curl -u ${u}:${p} ${server_ip}:8091/controller/addNode -d "hostname=${myip}&user=${u}&password=${p}&services=n1ql"
sleep 5
#curl -v -X POST -u ${u}:${p} http://${server_ip}:8091/controller/rebalance -d "knownNodes=ns_1@${server_ip},ns_1@${myip}"
curl -v -X POST -u ${u}:${p} "http://${server_ip}:8091/controller/rebalance" -d "knownNodes=ns_1@${server_ip},ns_1@${myip},ns_1@${db2_ip}"
echo "============-------------------------============"
