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
```
ksql
ksql> run script '03_ksql.ksql';
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

# Kibana 

## Kibana Index Setup

- Navigate to http://localhost:5601/app/kibana#/management/kibana/index 


![Kibana Step 1](/docs/kibana-01.png)

- At _Step 1 of 2: Define index pattern_  
  - Enter `runner_location*` for _Index pattern_
  - Click _Next step_


![Kibana Step 2](/docs/kibana-02.png)

- At _Step 2 of 2: Configure settings_ 
  - Enter `EVENT_TS`  for _Time Filter field name_
  - Expand _Hide advanced options_
  - Enter `runner_location_idx` for _Custom index pattern ID_
  - Click _Create index pattern_


- Repeat these steps to create a second index, this time using 
  -   `runner_status*` for _Index pattern_ 
  -  Enter `runner_status_idx` for _Custom index pattern ID_

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
./07_demo_run_data
```
