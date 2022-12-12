from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python import PythonOperator
from airflow.contrib.operators.ssh_operator import SSHOperator

from datetime import datetime
from functions import (
            order_count_task,
            order_category_count_task,
            order_sales_task,
            order_address_count_task,
            order_gender_count_task
        )

dag = DAG(dag_id="order_processing",
            start_date = datetime(2022, 12, 12, 6),
            schedule_interval = '5 * * * *',
            max_active_runs=1,
            max_active_tasks=2
        )

start_task = DummyOperator(
                task_id="start_task",
                dag=dag)


dt = "{{ execution_date.strftime('%Y-%m-%d %H:%M:%S') }}"
spark_task = SSHOperator(
        task_id='spark-s3-to-redshift',
        ssh_conn_id='emr-spark',
        command=f'spark-submit --jars /usr/share/aws/redshift/jdbc/RedshiftJDBC.jar,/usr/share/aws/redshift/spark-redshift/lib/spark-redshift.jar,/usr/share/aws/redshift/spark-redshift/lib/spark-avro.jar,/usr/share/aws/redshift/spark-redshift/lib/minimal-json.jar /home/hadoop/data-pipeline-with-aws/spark/orders_to_redshift.py -dt "{dt}"')

order_count_task = PythonOperator(
            task_id = 'order_count_task',
            python_callable = order_count_task,
            op_kwargs={ 'execution_date': dt },
            dag = dag
            )

order_category_count_task = PythonOperator(
            task_id = 'order_category_count_task',
            python_callable = order_category_count_task,
            op_kwargs={ 'execution_date': dt },
            dag = dag
            )

order_sales_task = PythonOperator(
            task_id = 'order_sales_task',
            python_callable = order_sales_task,
            op_kwargs={ 'execution_date': dt },
            dag = dag
            )

order_address_count_task = PythonOperator(
            task_id = 'order_address_count_task',
            python_callable = order_address_count_task,
            op_kwargs={ 'execution_date': dt },
            dag = dag
            )

order_gender_count_task = PythonOperator(
            task_id = 'order_gender_count_task',
            python_callable = order_gender_count_task,
            op_kwargs={ 'execution_date': dt },
            dag = dag
            )

end_task = DummyOperator(
                task_id="end_task",
                dag=dag)

start_task >> spark_task >> [
            order_count_task, order_category_count_task, order_sales_task, order_address_count_task, order_gender_count_task
        ] >> end_task
