from pyspark.sql import SparkSession
import pyspark.sql.functions as F

import argparse
from datetime import datetime

parser = argparse.ArgumentParser()
parser.add_argument('-dt', help='datetime')
args = parser.parse_args()

dt = datetime.strptime(args.dt, '%Y-%m-%d %H:%M:%S')
date_str = dt.strftime('%Y-%m-%d')
hour_str = dt.strftime('%H')

spark = SparkSession.builder.appName('order_s3_to_redshift').getOrCreate()

try:
    user_df = spark.read.json('s3://euiraekim-kafka-topics/topics/User/*/*/*.json')

    order_df = spark.read.json(f's3://euiraekim-kafka-topics/topics/Order/{date_str}/{hour_str}/*.json')

    df_joined = order_df.alias('order').join(user_df.alias('user'), [order_df.user_id == user_df.user_id], 'inner')
    df_joined = df_joined.selectExpr('order.*', 'user.address', 'user.email', 'user.gender', 'user.name', 'user.phone_number')

    redshift_url = 'jdbc:redshift://redshift-test.cyernhele58c.ap-northeast-2.redshift.amazonaws.com:5439/redshift_test?user=testuser&password=Testpw1234'

    df_joined.write.format('io.github.spark_redshift_community.spark.redshift') \
        .option('url', redshift_url).option('dbtable', 'orders') \
        .option('tempdir', 's3://euiraekim-redshift-temp/temp') \
        .option("forward_spark_s3_credentials", "true").mode('append').save()

except Exception as e:
    print(e)
