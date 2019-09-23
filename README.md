# Race Mapping


| Overview | [Phone Setup](/docs/phone.md) | [MQTT Server](/docs/mqtt_server.md) |[MQTT to Kafka](/docs/mqtt_kafka.md) |
|---|----|----|-----|

## Architectural overview

![Architecture](/docs/race-mapper-arch.png)

Race mapper for displaying participant progress and location - Kafka, KSQL, Kibana and MQTT based integration

![Kibana](/docs/kibana-capture.png)





# Get started

## Prerequisites & setup
- clone this repo!
- install docker/docker-compose
- set your Docker maximum memory to something really big, such as 10GB. (preferences -> advanced -> memory)

## Docker Startup
```
docker-compose -f docker-compose.yml  -d
```

# Phone Setup
If you want to have a play with demonstration data (and not bother with phone setup and MQTT server) skip to the next section.

If you want to setup the _entire_ project, you will need a to start with [Phone Setup](/docs/phone.md) 

# Create topics
```
cd scripts
./02_create_topic
```

# KSQL

Get a KSQL CLI session:
```
docker exec -it ksql-cli bash -c 'echo -e "\n\n⏳ Waiting for KSQL to be available before launching CLI\n"; while : ; do curl_status=$(curl -s -o /dev/null -w %{http_code} http://ksql-server:8088/info) ; echo -e $(date) " KSQL server listener HTTP state: " $curl_status " (waiting for 200)" ; if [ $curl_status -eq 200 ] ; then  break ; fi ; sleep 5 ; done ; ksql http://ksql-server:8088'
```

Run the KSQL script: 

```
ksql
ksql> run script '/data/scripts/03_ksql.ksql';
exit;
```

# Load Dynamic Templates for Elastic
```
./04_elastic_dynamic_template
```

# Setup Kafka Connect Elastic Sink
Write topic `runner_status` and `runner_location` to Elastic
```
./05_kafka_to_elastic_sink
```

Check connector status: 

```
curl -s "http://localhost:8083/connectors?expand=info&expand=status" | \
         jq '. | to_entries[] | [ .value.info.type, .key, .value.status.connector.state,.value.status.tasks[].state,.value.info.config."connector.class"]|join(":|:")' | \
         column -s : -t| sed 's/\"//g'| sort
```

Should be: 

```
sink  |  es_sink_RUNNER_LOCATION  |  RUNNING  |  RUNNING  |  io.confluent.connect.elasticsearch.ElasticsearchSinkConnector
sink  |  es_sink_RUNNER_STATUS    |  RUNNING  |  RUNNING  |  io.confluent.connect.elasticsearch.ElasticsearchSinkConnector
```

# Kibana 

## Kibana Index Setup

```
./06_create_kibana_metadata.sh
```

## Kibana Dashboard Import

- Navigate to http://localhost:5601/app/kibana#/management/kibana/objects
- Click _Import_
- Select file `06_kibana_export.json`
- Click _Automatically overwrite all saved objects?_ and select _Yes, overwrite all objects_

## Kibana - Open Dashboard

- Open http://localhost:5601/app/kibana#/dashboards
- Click on _Runner Dash_

# Demonstration Data
```
docker exec kafka /data/scripts/07_demo_run_data
```
