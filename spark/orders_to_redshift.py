from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('order_s3_to_redshift').getOrCreate()

user_df = spark.read.json('s3://euiraekim-kafka-topics/topics/User/*/*/*.json')

order_df = spark.read.json('s3://euiraekim-kafka-topics/topics/Order/*/*/*.json')

df_joined = order_df.alias('order').join(user_df.alias('user'), [order_df.user_id == user_df.user_id], 'inner')
df_joined = df_joined.selectExpr('order.*', 'user.address', 'user.email', 'user.gender', 'user.name', 'user.phone_number')

redshift_url = 'jdbc:redshift://redshift-test.cyernhele58c.ap-northeast-2.redshift.amazonaws.com:5439/redshift_test?user=testuser&password=Testpw1234'

df_joined.write.format('io.github.spark_redshift_community.spark.redshift') \
    .option('url', redshift_url).option('dbtable', 'orders') \
    .option('tempdir', 's3://euiraekim-redshift-temp/temp') \
    .option("forward_spark_s3_credentials", "true").mode('append').save()
