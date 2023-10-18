import logging
#import argparse

from pyspark.sql import SparkSession
from pyspark.sql.functions import col,lit
import pyspark.sql.functions as func

from pyspark.sql.types import StructType, StructField, StringType




# def pars_args():
#     parser = argparse.ArgumentParser(description="Process input arguments.")
#     parser.add_argument("raw_path", type=str, help="raw data path")
#     args = parser.parse_args()
#     return args._get_args

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

import boto3

s3_client = boto3.client('s3')
bucket_name = "datalake-vtc"
prefix = "raw_data/gcs/test/data/"

response = s3_client.list_objects(Bucket=bucket_name, Prefix=prefix)
files = ["s3://" + bucket_name + "/" + content['Key'] for content in response['Contents']]



def run_legacy_etl(raw_data_path):
    
    logging.info('Launching Spark application ')
    with SparkSession.builder.appName("My PyPi").getOrCreate() as spark:
        
        for file in files:
            # normalisation des colonnes 
            logging.info('normalisation des colonnes ')

            columns_names = "vendor_id,pickup_datetime,dropoff_datetime," \
                + "trip_distance,rate_code,store_and_fwd_flag,pickup_longitude,pickup_latitude," \
                + "dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount," \
                + "tolls_amount,improvement_surcharge,total_amount"

            columns_names = columns_names.split(",")
            
            # List of columns as per the schema you provided
            columns = [
                "_file",
                "_line",
                "_modified",
                "vendor_id",
                "tpep_pickup_datetime",
                "tpep_dropoff_datetime",
                "trip_distance",
                "ratecode_id",
                "store_and_fwd_flag",
                "pulocation_id",
                "dolocation_id",
                "fare_amount",
                "extra",
                "mta_tax",
                "tip_amount",
                "tolls_amount",
                "improvement_surcharge",
                "total_amount",
                "_fivetran_synced",
                "congestion_surcharge",
                "airport_fee",
                "pickup_datetime",
                "dropoff_datetime",
                "pickup_longitude",
                "pickup_latitude",
                "rate_code",
                "dropoff_longitude",
                "dropoff_latitude",
                "surcharge",
                "_index_level_0_",
                "payment_type"
            ]

            # Create StructType with all columns as StringType
            schema = StructType([StructField(col, StringType(), True) for col in columns])
            
            logging.info('loading raw data from path : {} '.format(raw_data_path))
            
            raw_data_path = "s3://datalake-vtc/raw_data/gcs/test/data/*.parquet"
            
            raw_data = spark.read.format("parquet").load(file)
            
            ##  Loading files 2010 -> 2014 
            logging.info(' Loading files 2010 -> 2014 ')
            data_v1 = raw_data.filter(col("_file").rlike("yellow_tripdata_201[0-4]-..\\.parquet"))

            data_v1 = data_v1 \
                .withColumn('improvement_surcharge', func.lit(0)) \
                .withColumn('extra', col('surcharge'))

            final_data = data_v1.select(columns_names)
            
            ## Loading files 2015-01 -> 2015-06 ...
            
            data_v2 = raw_data.filter(col("_file").rlike("yellow_tripdata_2015-0[1-6]\\.parquet"))

            data_v2 = data_v2.select(columns_names)

            final_data = final_data.union(data_v2)
            
            ## Loading files 2015-07 -> 2016-06 ...
            
            data_v3 = raw_data.filter(col("_file").rlike("yellow_tripdata_2015-(07|08|09|10|11|12)\\.parquet"))

            data_v3 = data_v3.union(
                raw_data.filter(col("_file")
                                    .rlike("yellow_tripdata_2016-(01|02|03|04|05|06)\\.parquet")))

            data_v3 = data_v3.select(columns_names)
                
            final_data = final_data.union(data_v3)
                
            final_data = final_data \
                .withColumn('pu_location_id', func.lit(None)) \
                .withColumn('do_location_id', func.lit(None)) \
                .withColumn('with_areas', func.lit(False))    
            
            new_columns_names = columns_names + ['pu_location_id', 'do_Location_id', 'with_areas']
            
            ## Loading files 2016-07 -> 2018 ...
            
            data_v4 = raw_data.filter(col("_file").rlike("yellow_tripdata_2016-(07|08|09|10|11|12)\\.parquet"))

            data_v4 = data_v4.union(
                raw_data.filter(col("_file")
                                    .rlike("yellow_tripdata_201[7-8]-..\\.parquet")))
            
            new_columns_names = columns_names + ['pu_location_id', 'do_location_id', 'with_areas']

            data_v4 = data_v4 \
                .withColumn('with_areas', func.lit(True)) \
                .withColumn('pickup_datetime',col('tpep_pickup_datetime')) \
                .withColumn('dropoff_datetime',col('tpep_dropoff_datetime')) \
                .withColumn('rate_code', col('ratecode_id')) \
                .withColumn('pickup_longitude', func.lit(None)) \
                .withColumn('pickup_latitude', func.lit(None)) \
                .withColumn('dropoff_longitude', func.lit(None)) \
                .withColumn('dropoff_latitude', func.lit(None)) \
                .withColumnRenamed('pulocation_id','pu_location_id')\
                .withColumnRenamed('dolocation_id','do_location_id')\
                .select(new_columns_names)
                
            final_data = final_data.union(data_v4)
                
            ## Cast columns 
            final_data = final_data \
                .withColumn("pickup_datetime", func.to_timestamp("pickup_datetime", 'yyyy-MM-dd HH:mm:ss')) \
                .withColumn("dropoff_datetime", func.to_timestamp("dropoff_datetime", 'yyyy-MM-dd HH:mm:ss'))
                
            final_data = final_data \
                .withColumn("vendor_id", final_data.vendor_id.cast("int")) \
                .withColumn("store_and_fwd_flag", final_data.store_and_fwd_flag.cast("string")) \
                .withColumn("trip_distance", final_data.trip_distance.cast("float")) \
                .withColumn("payment_type", final_data.payment_type.cast("float")) \
                .withColumn("pickup_longitude", final_data.pickup_longitude.cast("float")) \
                .withColumn("pickup_latitude", final_data.pickup_latitude.cast("float")) \
                .withColumn("dropoff_longitude", final_data.dropoff_longitude.cast("float")) \
                .withColumn("dropoff_latitude", final_data.dropoff_latitude.cast("float")) \
                .withColumn("fare_amount", final_data.fare_amount.cast("float")) \
                .withColumn("extra", final_data.extra.cast("float")) \
                .withColumn("mta_tax", final_data.mta_tax.cast("float")) \
                .withColumn("tip_amount", final_data.tip_amount.cast("float")) \
                .withColumn("tolls_amount", final_data.tolls_amount.cast("float")) \
                .withColumn("improvement_surcharge", final_data.improvement_surcharge.cast("float")) \
                .withColumn("total_amount", final_data.total_amount.cast("float")) \
                .withColumn("pu_location_id", final_data.pu_location_id.cast("int")) \
                .withColumn("do_location_id", final_data.do_location_id.cast("int"))    
            
            ## Load Data to redshift 
            logging.info(final_data.columns)
        
            url =  "jdbc:redshift:iam://vtc-dwh-cluster.cfwzpe8ofrzb.eu-west-3.redshift.amazonaws.com:5439/dev?user=adminuser0"
            final_data.write \
            .format("io.github.spark_redshift_community.spark.redshift") \
            .option("url", url) \
            .option("dbtable", "trips") \
            .option("tempdir", "s3://datalake-vtc/tmp_redshift/") \
            .option("aws_iam_role", "arn:aws:iam::371858328372:role/AWS-Redshift-ClusterRole") \
            .mode("append") \
            .save()
        
    

if __name__ == "__main__":
    #args = pars_args()
    run_legacy_etl("")
