| [Overview](/README.md) | [Phone Setup](/docs/phone.md)  | [MQTT Server](/docs/mqtt_server.md) |MQTT to Kafka |
|---|----|----|-----|



# MQTT Data Capture using Source Connect
Write MQTT data to the `data_mqtt` topic. Ensure the password in `01_source_mqtt` is set
```
curl -k -s -S -X PUT -H "Accept: application/json" -H "Content-Type: application/json" --data @./01_source_mqtt.json http://localhost:8083/connectors/01_source_mqtt/config
```


# MQTT KSQL
The stream `mqtt_demo_stream` is slightly different (due to the nested key represning the user)
```
create stream realtime_runner_location_stream  (tid varchar, batt INTEGER, lon DOUBLE, lat DOUBLE, tst BIGINT, alt INTEGER, cog INTEGER, vel INTEGER) 
with (kafka_topic = 'data_mqtt', value_format='JSON');

create stream runner_location with (value_format='JSON') as
select split(rowkey, '/')[2] as who
, tst as event_time
, cast(lat as varchar) ||','||cast(lon as varchar) as LOCATION
, alt
, batt
from realtime_runner_location_stream;



CREATE table runner_status with (value_format='JSON') AS 
select split(rowkey, '/')[2] as who
, min(vel) as min_speed
, max(vel) as max_speed
, min(GEO_DISTANCE(lat, lon, -33.87014, 151.211945, 'km')) as dist_to_finish
, count(*) as num_events 
from realtime_runner_location_stream WINDOW TUMBLING (size 5 minute) 
group by split(rowkey, '/')[2] 
;

```