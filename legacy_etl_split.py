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


def run_legacy_etl(raw_data_path):
    
    logging.info('Launching Spark application ')
    with SparkSession.builder.appName("My PyPi").getOrCreate() as spark:
        
            # normalisation des colonnes 
            logging.info('normalisation des colonnes ')

            columns_names = "vendor_id,pickup_datetime,dropoff_datetime," \
                + "trip_distance,store_and_fwd_flag,pickup_longitude,pickup_latitude," \
                + "dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount," \
                + "tolls_amount,improvement_surcharge,total_amount"

            columns_names = columns_names.split(",")
  
            logging.info('loading raw data from path : {} '.format(raw_data_path))
            
            raw_data_path = "s3://datalake-vtc/raw_data/trips/data/"
            
            
            ## Loading files 2016-07 -> 2018 ...
            
            data_v0 = spark.read.format("parquet").load(raw_data_path+'d37ci6vzurychx.cloudfront.net_trip-data_yellow_tripdata_201[7-8]-*.parquet')
            try:
                data_v1 = data_v0.union(
                    spark.read.format("parquet")\
                        .load(raw_data_path+'d37ci6vzurychx.cloudfront.net_trip-data_yellow_tripdata_2016-[6-9]*.parquet')
                )
            except Exception as e:
                data_v1 = data_v0
                
            
            new_columns_names = columns_names + ['pu_location_id', 'do_location_id', 'with_areas']

            data_v1 = data_v1 \
                .withColumn('with_areas', func.lit(True)) \
                .withColumn('pickup_datetime',col('tpep_pickup_datetime')) \
                .withColumn('dropoff_datetime',col('tpep_dropoff_datetime')) \
                .withColumn('pickup_longitude', func.lit(None)) \
                .withColumn('pickup_latitude', func.lit(None)) \
                .withColumn('dropoff_longitude', func.lit(None)) \
                .withColumn('dropoff_latitude', func.lit(None)) \
                .withColumnRenamed("VendorID","vendor_id")\
                .withColumnRenamed('PULocationID','pu_location_id')\
                .withColumnRenamed('DOLocationID','do_location_id')\
                .select(new_columns_names)

            final_data = data_v1
                            
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
