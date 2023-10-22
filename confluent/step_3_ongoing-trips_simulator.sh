## In Confluent Server :
vim rds-ongoing-trips-connector.properties


## check if redshift plugin connector is existing
curl -sS localhost:8083/connector-plugins | jq .[].class | grep RedshiftSinkConnector

## check existing connectors 
curl  localhost:8083/connectors/

confluent local services connect connector load redshift-ongoing-trips-sink --config rds-ongoing-trips-connector.properties

## Mise en place d'un serveur Producer vers le cluster kafka.

### Mise en place environnement Python
sudo yum install python3 -y
sudo yum install python3-pip -y
pip3 install --upgrade pip --user
pip3 install pandas confluent-kafka requests fastparquet
pip3 install 'confluent-kafka[avro]'
pip3 install pyarrow


vim simulate_vtc_producer.py

wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2018-03.parquet -O ~/uber/yellow_tripdata_2019-03.parquet

python3 simulate_vtc_producer.py