#UBUNTU set up
sudo apt update
sudo apt install python3-pip -y
sudo pip3 install --upgrade pip


# Install Apache Airflow
sudo pip3 install apache-airflow
#pip install "apache-airflow==2.7.2" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.7.2/constraints-3.9.txt"
sudo pip3 install redshift-connector,boto3

# Create Airflow directory
sudo mkdir /opt/airflow

# Set AIRFLOW_HOME environment variable
export AIRFLOW_HOME=/opt/airflow
echo 'export AIRFLOW_HOME=/opt/airflow' >> ~/.bashrc 

# Initialize the Airflow database
airflow db init

# Create an Airflow user
airflow users create \
    --username airflow \
    --firstname airflow \
    --lastname app_account \
    --role Admin \
    --email no-reply@vtc.ai.airflow\
    --password airflow



vim $AIRFLOW_HOME/airflow.cfg
## under [webserver]
# web_server_port = 80 

airflow db reset


nano /etc/default/airflow
# put inside
#AIRFLOW_HOME=/opt/airflow

### set up airflow scheduler and start it 
sudo nano /lib/systemd/system/airflow-scheduler.service
# past airflow-scheduler.service file




systemctl daemon-reload

systemctl enable airflow-scheduler
systemctl start airflow-scheduler
## to check logs 
journalctl -u airflow-scheduler


### set up airflow webserver and start it 
sudo nano /lib/systemd/system/airflow-webserver.service
# past airflow-webserver.service file


systemctl daemon-reload

systemctl enable airflow-webserver
systemctl start airflow-webserver
## to check logs 
journalctl -u airflow-webserver
