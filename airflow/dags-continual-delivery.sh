# apt  install awscli
mkdir /opt/airflow/dags

crontab -e
# */5 * * * * sudo aws s3 cp --recursive s3://vtc-scripts-repo/airflow/dags /opt/airflow/dags