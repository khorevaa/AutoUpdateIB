#!/bin/sh
docker run -d --hostname rabbit --name rabbit -p 15672:15672 rabbitmq:3-management

# ./wait-for-it.sh localhost:8080 
# -t 30
sleep 10

until curl -i -u guest:guest http://localhost:15672/api/healthchecks/node >/dev/null ; do

  >&2 echo "rabbitmq is unavailable - sleeping"

  sleep 5

done

curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"auto_delete":false,"durable":true}' \
    http://localhost:15672/api/queues/%2f/all.update

curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"auto_delete":false,"durable":true}' \
    http://localhost:15672/api/queues/%2f/report.update