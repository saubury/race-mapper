
Race mapper for displaying participant progress and location - Kafka, KSQL, Kibana and MQTT based integration


# Get started
For _everything_ try
```
docker-compose -f docker-compose.yml -f docker-compose-ui.yml up -d
```
- http://localhost:5601 - Kibana
- http://localhost:8001 - Kafka Topic Browser
- http://localhost:8002 - Schema Registry Browser
- http://localhost:8003 - Connect UI


For _minimal_ setup
```
docker-compose -f docker-compose.yml up -d
```

# Demonstration Data
```
cd scripts
./02_source_demo
```


# MQTT Data Capture using Source Connect
Write MQTT data to the `data_mqtt` topic. Ensure the password in `01_source_mqtt` is set
```
curl -k -s -S -X PUT -H "Accept: application/json" -H "Content-Type: application/json" --data @./01_source_mqtt.json http://localhost:8083/connectors/01_source_mqtt/config
```




# KSQL
```
ksql
ksql> run script '03_ksql.ksql';
```

# Load Dynamic Templates for Elastic
```
./04_elastic_dynamic_template
```

# Setup Kafka Connect Elastic Sink
Write topic `runner_status` and `runner_location` to Elastic
```
./05_set_connect
```

# Kibana Setup
```
06_kibana_export.json
```


# Debug
```
docker-compose -f docker-compose.yml -f docker-compose-ui.yml logs kafka-connect
```

