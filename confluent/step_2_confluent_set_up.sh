#Amazon Linux 2 OS  

sudo dnf update

sudo useradd confluent -m
sudo passwd confluent
#password is "confluent", change it later after setup is done

# Add confluent user to super users group, need to restard session
sudo usermod -aG wheel confluent



sudo dnf install java-1.8.0-amazon-corretto-devel


export AWSArtifactoryBucket=s3://vtc-scripts-repo
aws s3 cp $AWSArtifactoryBucket/confluent/ ./confluent/ --recursive
sudo tar -xvf ./confluent/confluent-community-6.2.0.tar.gz -C /opt/
sudo mv /opt/confluent-6.2.0 /opt/confluent
sudo rm confluent-community-6.2.0.tar.gz

export CONFLUENT_HOME=/opt/confluent
export PATH=$PATH:$CONFLUENT_HOME/bin

sudo mv ~/confluent/install.sh /opt/confluent/ && sudo sh /opt/confluent/install.sh -b -- v1.9.0

# not needed when natGateWay open
#mkdir -p $CONFLUENT_HOME/bin
#cp ~/confluent/confluent $CONFLUENT_HOME/bin/

mkdir /opt/confluent/current
chown -R confluent /opt/confluent/current
export CONFLUENT_CURRENT=/opt/confluent/current

## update kafka config file 
##  vim /opt/confluent/etc/kafka/server.properties
## advertised.listeners=PLAINTEXT://10.0.167.156:9092

confluent local services start

cd /home/confluent
wget http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar -xvf confluent-hub-client-latest.tar.gz -C /opt/confluent
rm confluent-hub-client-latest.tar.gz
sudo chown -R confluent /opt/confluent

cd /home/confluent
wget http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar -xvf confluent-hub-client-latest.tar.gz -C /opt/confluent
rm confluent-hub-client-latest.tar.gz
chown -R confluent /opt/confluent


## each new session 
export CONFLUENT_HOME=/opt/confluent
export PATH=$PATH:$CONFLUENT_HOME/bin
export CONFLUENT_CURRENT=/opt/confluent/current

confluent-hub install confluentinc/kafka-connect-aws-redshift:1.2.2

confluent local services connect stop
confluent local services connect start
## pkill java   

# Redshift Connector 
## https://docs.confluent.io/kafka-connectors/aws-redshift/current/overview.html
confluent local services connect connector load redshift-sink --config redshift.properties

## check if connector has been added ( restard of services might be necessary )
curl  localhost:8083/connectors/




