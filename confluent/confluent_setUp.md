for the connector properties :

name=<connector-name>
confluent.topic.bootstrap.servers=localhost:9092
confluent.topic.replication.factor=1
connector.class=io.confluent.connect.aws.redshift.RedshiftSinkConnector
tasks.max=1
topics=<topic-name>
aws.redshift.domain=<host>
aws.redshift.port=<port>
aws.redshift.database=<db>
aws.redshift.user=<user>
aws.redshift.password=<pwd>
pk.mode=kafka
auto.create=true
