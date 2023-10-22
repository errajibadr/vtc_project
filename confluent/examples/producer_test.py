import json

from kafka import KafkaProducer

# Internal IP adress of confluent server, in private subnet, only accessible from inside.
CONFLUENT_IP = "10.0.167.156"
KAFKA_SERVER = f"{CONFLUENT_IP}:9092"

producer = KafkaProducer(
    bootstrap_servers=KAFKA_SERVER,
    value_serializer=lambda x: json.dumps(x).encode("utf-8")
)

producer.bootstrap_connected()

def on_success(record):
    print("Message envoyé : partition {} offset {}".format(
        record.partition,
        record.offset
    ))

def on_error(err):
    print(err)

producer \
    .send('schema-test', {"fname": "Jean"}) \
    .add_callback(on_success) \
    .add_errback(on_error)
    
    
    
##################################@
import requests

from pprint import pprint

from confluent_kafka import avro
from confluent_kafka.avro import AvroProducer


SCHEMA_REGISTRY_URL = f"{CONFLUENT_IP}:8081"    

# On récupère le schéma nommé schema-test-value avec sa première version
rep = requests.get(
    "http://{}/subjects/schema-test-value/versions/1".format(SCHEMA_REGISTRY_URL)
)
schema = json.loads(rep.content)['schema']
pprint(schema)

avro_schema = avro.loads(schema)


# kafka-avro-console-consumer --bootstrap-server localhost:9092 --topic schema-test --property schema.registry.url="http://localhost:8081"

def delivery_report(err, msg):
    if err is not None:
        print("Échec de l'envoi du message : {}".format(err))
    else:
        print("Message envoyé sur la partition {} offset {}.".format(msg.partition(), msg.offset()))
        

# Création du producer Avro avec le schéma spécifié
producer = AvroProducer(
    {
        'bootstrap.servers': KAFKA_SERVER,
        'on_delivery': delivery_report,
        'schema.registry.url': "http://{}".format(SCHEMA_REGISTRY_URL)
    },
    default_value_schema=avro_schema
)

def produce(value, topic="schema-test"):
    try:
        rep = producer.produce(
            topic=topic,
            value=value
        )
        producer.poll(timeout=5)
    except Exception as e:
        print("Error : {}".format(e))
        
## Error because fname required field is missing
produce({
    "lname": "Dupont"
})

## good because age is not required
produce({
    "lname": "Dupont",
    "fname": "Jean"
})