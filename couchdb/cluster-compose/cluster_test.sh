ADMIN_USER=admin
ADMIN_PASSWORD=password

echo "create database:"
curl -X PUT http://${ADMIN_USER}:${ADMIN_PASSWORD}@127.0.0.1:15984/color

echo "add two documents to different nodes:"
curl -X PUT http://127.0.0.1:15984/color/001 -d '{"name":"red"}'
curl -X PUT http://127.0.0.1:25984/color/002 -d '{"name":"blue"}'

echo "query differnet nodes for them:"
curl http://127.0.0.1:35984/color/001
curl http://127.0.0.1:15984/color/002

echo "shutdown node 1:"
docker stop cluster-compose_cdb1_1
sleep 5

echo "add two more docs to remaining nodes:"
curl -X PUT http://127.0.0.1:25984/color/003 -d '{"name":"green"}'
curl -X PUT http://127.0.0.1:35984/color/004 -d '{"name":"yellow"}'

echo "start up node 1:"
docker start cluster-compose_cdb1_1
sleep 5

echo "query node 1 for the latest two docs:"
curl http://127.0.0.1:15984/color/003
curl http://127.0.0.1:15984/color/004

echo "shutdown node 2:"
docker stop cluster-compose_cdb2_1
sleep 5

echo "add two more docs to remaining nodes:"
curl -X PUT http://127.0.0.1:15984/color/005 -d '{"name":"purple"}'
curl -X PUT http://127.0.0.1:35984/color/006 -d '{"name":"pink"}'

echo "start up node 2:"
docker start cluster-compose_cdb2_1
sleep 5

echo "query node 2 for the latest two docs:"
curl http://127.0.0.1:25984/color/005
curl http://127.0.0.1:25984/color/006
