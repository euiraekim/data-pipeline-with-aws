from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('user_s3_to_redshift').getOrCreate()

user_df = spark.read.json('s3://euiraekim-kafka-topics/topics/User/*/*/*.json')

redshift_url = 'jdbc:redshift://redshift-test.cyernhele58c.ap-northeast-2.redshift.amazonaws.com:5439/redshift_test?user=testuser&password=Testpw1234'

user_df.write.format('io.github.spark_redshift_community.spark.redshift') \
    .option('url', redshift_url).option('dbtable', 'users') \
    .option('tempdir', 's3://euiraekim-redshift-temp/temp') \
    .option("forward_spark_s3_credentials", "true").mode('append').save()
