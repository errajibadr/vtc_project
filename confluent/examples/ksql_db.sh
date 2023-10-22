# Execute KSQL REST API to get topics 
curl -X POST \
     -H "Accept: application/vnd.ksql.v1+json" \
     -d '{"ksql": "SHOW TOPICS;"}' \
     http://localhost:8088/ksql

## Create Steam for on-going-trips topics and use existing avro schema of the topic in schema registry
curl -X POST \
     -H "Accept: application/vnd.ksql.v1+json" \
     -d '{"ksql":  """CREATE STREAM trips (
                        vendor_id VARCHAR,
                        pickup_datetime BIGINT,
                        dropoff_datetime BIGINT,
                        passenger_count INT,
                        trip_distance DOUBLE,
                        fare_amount DOUBLE,
                        extra DOUBLE,
                        mta_tax DOUBLE,
                        tip_amount DOUBLE,
                        tolls_amount DOUBLE,
                        improvement_surcharge DOUBLE,
                        total_amount DOUBLE,
                        PULocationID INT,
                        DOLocationID INT
                        ) WITH (
                        KAFKA_TOPIC = 'ongoing-trips',
                        VALUE_FORMAT = 'AVRO'
                        );
                        """}' \
     http://localhost:8088/ksql


# Execute KSQL REST API to get topics 
curl -X POST \
     -H "Accept: application/vnd.ksql.v1+json" \
     -d '{"ksql":"""
            CREATE TABLE areas_count AS
                SELECT PULocationID, COUNT(*) AS count
                FROM trips
                WINDOW HOPPING (SIZE 5 MINUTES, ADVANCE BY 1 MINUTE)
                GROUP BY PULocationID
                EMIT CHANGES;
            """}' \
     http://localhost:8088/ksql
