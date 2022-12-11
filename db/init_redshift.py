from connection import get_redshift_conn

create_user_table = """
    CREATE TABLE users (
        user_id INT NOT NULL,
        created_date DATETIME NOT NULL,
        address VARCHAR(50) NOT NULL,
        email_user VARCHAR(50) NOT NULL,
        email_domain VARCHAR(50) NOT NULL,
        gender VARCHAR(5) NOT NULL,
        name VARCHAR(30) NOT NULL,
        phone_number VARCHAR(30) NOT NULL
    );
"""
create_order_table = """
    CREATE TABLE orders (
        order_id INT NOT NULL,
        created_date DATETIME NOT NULL,
        first_category VARCHAR(30) NOT NULL,
        second_category VARCHAR(30) NOT NULL,
        price INT NOT NULL,
        product_id INT NOT NULL,
        user_id INT NOT NULL,
        address VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        gender VARCHAR(5) NOT NULL,
        name VARCHAR(30) NOT NULL,
        phone_number VARCHAR(30) NOT NULL
    );
"""

conn = get_redshift_conn()

with conn.cursor() as cursor:
    try:
        cursor.execute(create_user_table)
        cursor.execute(create_order_table)
    except Exception as e:
        print(e)
