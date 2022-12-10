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
