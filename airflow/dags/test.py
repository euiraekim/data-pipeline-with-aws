from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime

dag = DAG(dag_id="test_dag", start_date=datetime(2022, 12, 7))

operator = DummyOperator(
        task_id="dummy_test",
        dag=dag)


