
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


# Start Data Gen
```
cd scripts
ksql-datagen schema=./01_location_event.avro format=AVRO key=who maxInterval=5000 iterations=10000 topic=LOCATION_EVENT > /dev/null &
```

# Run KSQL
```
ksql
ksql> run script '02_ksql.ksql';
```

# Load Dynamic Templates for Elastic
```
./04_elastic_dynamic_template
```

# Setup Kafka Connect Elastic Sink
Write topic `LOCATION_REFINED` to Elastic
```
./05_set_connect
```

# Setup Kafka Connect JDBC Sink
Write topic `LOCATION_EVENT` to Postgres
```
curl -k -s -S -X PUT -H "Accept: application/json" -H "Content-Type: application/json" --data @./06_sink_jdbc.json http://localhost:8083/connectors/06_sink_jdbc/config
```


# Debug
```
docker-compose -f docker-compose.yml -f docker-compose-ui.yml logs kafka-connect
```

