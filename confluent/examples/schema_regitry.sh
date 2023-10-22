## Get all Schemas in schema registry 
curl http://localhost:8081/subjects

## Test au schema test creation 
kafka-topics --create --zookeeper localhost:2181 --topic schema-test --replication-factor 1 --partitions 1

## Creation d'un schema pour ce topic 
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{ "schema": "{\"type\":\"record\",\"name\":\"schema\",\"namespace\":\"org.blent.data_engineer.schema\",\"fields\":[{\"name\":\"fname\",\"type\":\"string\"},{\"name\":\"lname\",\"type\":\"string\"},{\"name\":\"age\",\"type\":[\"int\",\"null\"]}]}" }' \
  http://localhost:8081/subjects/rds-schema-test-value/versions


kafka-avro-console-producer \
    --broker-list localhost:9092 \
    --topic schema-test \
    --property value.schema='{"type":"record","name":"record_test","fields":[{"name":"fname","type":"string"},{"name":"lname","type":"string"}]}'

#{"fname":"fname-value","lname":"lname_value","age":10}

# curl http://localhost:8081/subjects/rds-schema-test-value/versions/2

## Test au rds schema test creation 
kafka-topics --create --zookeeper localhost:2181 --topic rds-schema-test --replication-factor 1 --partitions 1

## Creation d'un schema pour ce topic 
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{ "schema": "{\"type\":\"record\",\"name\":\"schema\",\"namespace\":\"org.blent.data_engineer.schema\",\"fields\":[{\"name\":\"fname\",\"type\":\"string\"},{\"name\":\"lname\",\"type\":\"string\"},{\"name\":\"age\",\"type\":[\"int\",\"null\"]}]}" }' \
  http://localhost:8081/subjects/rds-schema-test-value/versions

# Création of a new connector linked to the new topic rds-schema-test
# curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/ -d @rds-test-connector.properties
# confluent local services connect connector load redshift-sink --config redshift-sink.properties

## Produce to topic 
kafka-avro-console-producer     --broker-list localhost:9092     --topic rds-schema-test     
--property value.schema='{"type":"record","name":"record_test","fields":[{"name":"fname","type":"string"},{"name":"lname","type":"string"}]}'
#{"fname":"fname-value","lname":"lname_value","age":10}
#{"fname":"fname-value","lname":"lname_value","age": {"int": 10}}
#{"fname":"balabola","lname":"hamid","age": {"null": null}}


kafka-avro-console-producer     --broker-list localhost:9092     --topic rds-schema-test     --property value.schema.id=1