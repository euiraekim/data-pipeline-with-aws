from connection import get_postgresql_conn

create_table_query = """
    CREATE TABLE order_user (
        order_id INT NOT NULL
    )
"""

conn = get_postgresql_conn()

with conn.cursor() as cursor:
    try:
        cursor.execute(create_table_query)
    except Exception as e:
        print(e)
