#!/usr/bin/env bash

echo "Create index patterns"
curl -XPOST 'http://localhost:5601/api/saved_objects/index-pattern/runner_location_idx' \
    -H 'kbn-xsrf: nevergonnagiveyouup' \
    -H 'Content-Type: application/json' \
    -d '{"attributes":{"title":"runner_location*","timeFieldName":"EVENT_TS"}}'

curl -XPOST 'http://localhost:5601/api/saved_objects/index-pattern/runner_status_idx' \
    -H 'kbn-xsrf: nevergonnagiveyouup' \
    -H 'Content-Type: application/json' \
    -d '{"attributes":{"title":"runner_status*","timeFieldName":"EVENT_TS"}}'

echo "Setting the index pattern as default"
curl -XPOST 'http://localhost:5601/api/kibana/settings' \
    -H 'kbn-xsrf: nevergonnagiveyouup' \
    -H 'content-type: application/json' \
    -d '{"changes":{"defaultIndex":"runner_status_idx"}}'

