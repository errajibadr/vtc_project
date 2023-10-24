import os
import random

from datetime import timedelta,datetime
from airflow.utils.dates import days_ago
from airflow.decorators import dag, task
from airflow.operators.python import get_current_context
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator
import pytz


DAG_NAME = os.path.basename(__file__).replace(".py", "") 

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(seconds=10)
}


@dag(DAG_NAME,default_args=default_args, schedule_interval="0 0 * * *", start_date=days_ago(2))
def aiflow_branching():
    '''
    Dag for airflow branching
    '''
    
    @task()
    def date(date :str):
        context = get_current_context()
        context['ti'].xcom_push(key='date',value=date)
        
    @task(trigger_rule="all_done")
    def date2():
        context = get_current_context()
        date = context['ti'].xcom_pull(key='date')
        print(f'task executed for date {date}')
    
    def branching():
        context = get_current_context()
        execution_date = context['logical_date']
        if execution_date < datetime(2023, 10, 23,tzinfo=pytz.utc):
            return 'echoB'
        else:
            return 'echoA'
        
    task_date = date(date='{{ds}}')
    task_date2 = date2()
    task_branching = BranchPythonOperator(task_id="branching", python_callable=branching)
    
    task_brancha = BashOperator(task_id= 'echoA', bash_command='echo branchA is running')
    task_branchb = BashOperator(task_id= 'echoB', bash_command='echo branchB is running')
    
    
    task_date>>task_branching>>[task_brancha,task_branchb]>>task_date2

    
airflow_dag = aiflow_branching()