import os
import random

from datetime import timedelta,datetime
from airflow.utils.dates import days_ago
from airflow.decorators import dag, task
from airflow.operators.python import get_current_context
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator
import redshift_connector
import boto3
import pytz
import json


DAG_NAME = os.path.basename(__file__).replace(".py", "") 

default_args = {
    'owner': 'airflow',
    'retries': 0,
    'retry_delay': timedelta(seconds=10)
}


@dag(DAG_NAME,default_args=default_args, schedule_interval="0 0 * * *", start_date=days_ago(3))
def elt_dag():
    '''
    ELT to load yesterday data from ongoing-trips table to trips table
    '''
    
    def connect():
        
        return redshift_connector.connect(
            iam=True,
            cluster_identifier='vtc-dwh-cluster',
            database='dev',
            port='5439',
            region='eu-west-3',
            db_user='adminuser0',
            role_arn="arn:aws:iam::371858328372:role/AWS-Redshift-ClusterRole",
            timeout=10,
            idc_response_timeout=10,
            idp_response_timeout=10)
        
     
    @task()
    def load_curr_to_hist(**kwargs):   
        '''
        loads yesterday ongoing trips to historical trips table
        '''
        
        date = datetime.fromisoformat(kwargs['ds'])
        # On utilise des timestamps pour le datetime
        timestamp_low = (date - timedelta(days=1)).replace(hour=0, minute=0, second=0)
        timestamp_high = date.replace(hour=0, minute=0, second=0)
        
        conn = connect()
        print('--- connection established ---- ')
        cursor =  conn.cursor()
        cursor.execute("""INSERT INTO trips
                    SELECT
                        cast(vendor_id as int) , 
                        TIMESTAMP 'epoch' + (pickup_datetime * 1000) * INTERVAL '1 second' as pickup_datetime, 
                        TIMESTAMP 'epoch' + (dropoff_datetime * 1000) * INTERVAL '1 second' as dropoff_datetime,
                        trip_distance,
                        Null as store_and_fwd_flag,
                        Null as pickup_longitude,
                        Null as pickup_latitude, 
                        Null as dropoff_longitude,
                        Null as dropoff_latitude,
                        payment_type,
                        fare_amount,
                        extra,
                        mta_tax,
                        tip_amount,
                        tolls_amount,
                        improvement_surcharge,
                        total_amount,
                        PULocationID,
                        DOLocationID,
                        true as with_areas
                    FROM
                        "dev"."public"."ongoing-trips"
                    where dropoff_datetime > {} 
                    and dropoff_datetime < {} ;
                    """.format(
                                int(timestamp_low.timestamp()/1000),
                                int(timestamp_high.timestamp()/1000)
                            ))
        # Commit the transaction
        conn.commit()

        # Close the cursor and the connection when done
        cursor.close()
        conn.close()
        
    
    @task()
    def delete_from_curr(**kwargs):
        '''
        delete data from ongoing-trips for the day before execution date
        '''
        date = datetime.fromisoformat(kwargs['ds'])
        # On utilise des timestamps pour le datetime
        timestamp_low = (date - timedelta(days=1)).replace(hour=0, minute=0, second=0)
        timestamp_high = date.replace(hour=0, minute=0, second=0)

        conn = connect()
        cursor =  conn.cursor()
        cursor.execute("""
        DELETE FROM "public"."ongoing-trips"
        WHERE dropoff_datetime >= {}
        AND dropoff_datetime < {}
        """.format(
            int(timestamp_low.timestamp()/1000),
            int(timestamp_high.timestamp()/1000)
        ))
        
        # Commit the transaction
        conn.commit()

        # Close the cursor and the connection when done
        cursor.close()
        conn.close()
    
    elt_task = load_curr_to_hist()
    del_task = delete_from_curr()
    
    
    elt_task >> del_task
    
elt_dag_processing = elt_dag()
    
        
    
    

#/opt/airflow/logs/dag_id=trips_elt/run_id=manual__2023-10-23T19:06:33.861553+00:00/task_id=load_curr_to_hist/attempt=1.log


