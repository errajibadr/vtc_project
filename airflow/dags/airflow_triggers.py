import os

from datetime import timedelta
from airflow.utils.dates import days_ago
from airflow.decorators import dag, task
from airflow.operators.python import get_current_context
from airflow.operators.bash import BashOperator

DAG_NAME = os.path.basename(__file__).replace(".py", "") 

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(seconds=10)
}


@dag(DAG_NAME,default_args=default_args, schedule_interval="0 0 * * *", start_date=days_ago(2))
def aiflow_triggers():
    '''
    Dag for airflow triggers
    '''
    
    @task()
    def date(date_ds):
        context = get_current_context()
        context['ti'].xcom_push(key='date',value=date_ds)
        
    @task(trigger_rule="all_done")
    def date2():
        context = get_current_context()
        date = context['ti'].xcom_pull(key='date')
        print(f'task executed for date {date}')
        
    task_date = date('{{ds}}')
    task_date2 = date2()
        
    task_sleep = BashOperator(task_id= 'sleep', bash_command='sleep 5')
    task_error = BashOperator(task_id= 'error', bash_command='sleeep 5')
    task_echo = BashOperator(task_id='echo',bash_command='echo airflow running')
    
    task_date>>task_sleep>>task_date2
    task_date>>task_echo>>task_date2
    task_date>>task_error>>task_date2
    
airflow_dag = aiflow_triggers()