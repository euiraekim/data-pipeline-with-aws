from datetime import datetime, timedelta
import redshift_connector
import psycopg2


def get_redshift_conn():
    try:
        conn = redshift_connector.connect(
                    host='redshift-test.cyernhele58c.ap-northeast-2.redshift.amazonaws.com',
                    database='redshift_test',
                    user='testuser',
                    password='Testpw1234')
        conn.autocommit = True
        return conn
    except Exception as e:
        print(e)

def get_postgresql_conn():
    try:
        dbname = 'postgresql'
        host = 'postgresql.cu8vcr2xeenz.ap-northeast-2.rds.amazonaws.com'
        port = 5432
        user = 'testuser'
        pw = 'Testpw1234'
        conn = psycopg2.connect(f'dbname={dbname} host={host} port={port} user={user} password={pw}')
        conn.autocommit = True
        return conn
    except Exception as e:
        print(e)


def insert_query(query, db):
    if db == 'redshift':
        conn = get_redshift_conn()
    else:
        conn = get_postgresql_conn()
    
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
        except Exception as e:
            print(e)

def select_query(query, db):
    if db == 'redshift':
        conn = get_redshift_conn()
    else:
        conn = get_postgresql_conn()

    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            rows = cursor.fetchall()
            return rows
        except Exception as e:
            print(e)



def get_query_dt(execution_date):
    dt = datetime.strptime(execution_date, '%Y-%m-%d %H:%M:%S')
    dt = dt.replace(minute=0, second=0)
    return dt


def user_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT COUNT(*) FROM users
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
        INSERT INTO user_count (date, count)
        VALUES ('{dt}', {row[0]})
        """
        insert_query(postgresql_query, 'postgresql')


def user_address_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT address, COUNT(*) FROM users
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY address
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO user_address_count (date, address, count)
            VALUES ('{dt}', '{row[0]}', {row[1]})
        """
        insert_query(postgresql_query, 'postgresql')


def user_email_domain_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT email_domain, COUNT(*) FROM users
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY email_domain
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO user_email_domain_count (date, email_domain, count)
            VALUES ('{dt}', '{row[0]}', {row[1]})
        """
        insert_query(postgresql_query, 'postgresql')


def user_gender_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT gender, COUNT(*) FROM users
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY gender
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO user_gender_count (date, gender, count)
            VALUES ('{dt}', '{row[0]}', {row[1]})
        """
        insert_query(postgresql_query, 'postgresql')


def order_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT COUNT(*) FROM orders
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO order_count (date, count)
            VALUES ('{dt}', {row[0]})
        """
        insert_query(postgresql_query, 'postgresql')


def order_category_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT first_category, second_category, COUNT(*) FROM orders
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY first_category, second_category
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO order_category_count (date, first_category, second_category, count)
            VALUES ('{dt}', '{row[0]}', '{row[1]}', '{row[2]}')
        """
        insert_query(postgresql_query, 'postgresql')


def order_sales_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT SUM(price) FROM orders
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO order_sales (date, amount)
            VALUES ('{dt}', {row[0]})
        """
        insert_query(postgresql_query, 'postgresql')


def order_address_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT address, COUNT(*) FROM orders
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY address
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO order_address_count (date, address, count)
            VALUES ('{dt}', '{row[0]}', {row[1]})
        """
        insert_query(postgresql_query, 'postgresql')


def order_gender_count_task(execution_date):
    dt = get_query_dt(execution_date)

    redshift_query = f"""
        SELECT gender, COUNT(*) FROM orders
        WHERE created_date >= '{dt}' and created_date < '{dt+timedelta(hours=1)}'
        GROUP BY gender
    """
    rows = select_query(redshift_query, 'redshift')
    for row in rows:
        postgresql_query = f"""
            INSERT INTO order_gender_count (date, gender, count)
            VALUES ('{dt}', '{row[0]}', {row[1]})
        """
        insert_query(postgresql_query, 'postgresql')
