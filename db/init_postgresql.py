from connection import get_postgresql_conn

create_table_queries = [
            """
                CREATE TABLE user_count (
                    date TIMESTAMP,
                    count INT
                );
            """,
            """
                CREATE TABLE user_address_count (
                    date TIMESTAMP,
                    address VARCHAR(50),
                    count INT
                );
            """,
            """
                CREATE TABLE user_email_domain_count (
                    date TIMESTAMP,
                    email_domain VARCHAR(50),
                    count INT
                );
            """,
            """
                CREATE TABLE user_gender_count (
                    date TIMESTAMP,
                    gender CHAR(5),
                    count INT
                );
            """,
            """
                CREATE TABLE order_count (
                    date TIMESTAMP,
                    count INT
                );
            """,
            """
                CREATE TABLE order_category_count (
                    date TIMESTAMP,
                    first_category VARCHAR(50),
                    second_category VARCHAR(50),
                    count INT
                );
            """,
            """
                CREATE TABLE order_sales (
                    date TIMESTAMP,
                    amount BIGINT
                ) 
            """,
            """
                CREATE TABLE order_address_count (
                    date TIMESTAMP,
                    address VARCHAR(50),
                    count INT
                )
            """,
            """
                CREATE TABLE order_gender_count (
                    date TIMESTAMP,
                    gender VARCHAR(50),
                    count INT
                )
            """
        ]

conn = get_postgresql_conn()

with conn.cursor() as cursor:
    try:
        for query in create_table_queries:
            cursor.execute(query)
    except Exception as e:
        print(e)
