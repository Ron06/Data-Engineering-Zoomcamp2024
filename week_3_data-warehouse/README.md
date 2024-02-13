# Week 3 Homework


### Loading data into GCS using mage

### 1 . Download the data from source
```
from io import BytesIO
import pandas as pd
import requests
import pyarrow as pa


if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):

    url_links = [
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-01.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-02.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-03.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-04.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-05.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-06.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-07.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-08.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-09.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-10.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-11.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-12.parquet'

    ]

    taxi_dtypes = {
        'VendorID': 'Int64',
        'passenger_count': 'Int64',
        'trip_distance': 'float',
        'RatecodeID': 'Int64',
        'store_and_fwd_flag': 'str',
        'PULocationID': 'Int64',
        'DOLocationID': 'Int64',
        'payment_type': 'Int64',
        'fare_amount': 'float',
        'extra': 'float',
        'mta_tax': 'float',
        'tip_amount': 'float',
        'tolls_amount': 'float',
        'improvement_surcharge': 'float',
        'total_amount': 'float',
        'congestion_surcharge': 'float'
    }

    dfs = []            
    # Loop through the file names, load each compressed CSV file, and append to the list
    for url in url_links:
        response = requests.get(url)
        print(response)
        print(url)

        compressed_file = BytesIO(response.content)

        df = pd.read_parquet(compressed_file, engine='pyarrow')
        df = df.astype(taxi_dtypes)
        dfs.append(df)

    # Concatenate the list of DataFrames into a single DataFrame
    final_dataframe = pd.concat(dfs, ignore_index=True)

    return final_dataframe


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

```
### 2 . Export data from Mage to Google Cloud Storage
### DATA EXPORTER
```
from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    bucket_name = 'de-dtc-mage-orchestration'
    object_key = 'green_taxi_2022.parquet'

    GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        bucket_name,
        object_key,
    )
```
### 3 . Check if you data was successfully downloaded to Google Cloud Storage bucket.
### 4 . in BigQuery click on ADD (to add data from Google Cloud Storage bucket)
### 5 . Navigate to:
- Add
- Source
- Select → Google Cloud
- Storage
### 6 . Click on Browse to select your project from Google Cloud Storage.
1. Select : File Format ‘parquet’
2. Name your dataset and table
3. Select: Table Type ‘External’
4. Select: No partitioning
5. Select: ‘Schema = Auto’ (or define the schema you want)
6. Create table
### 7 . To confi rm if your table has been successfully created, you can easily view the data in BigQuery.
### 8 . Once your data is successfully uploaded to BigQuery,you'll be able to to perform queries on the data.


## BIGDATA QUERIES

```
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-411807.tlc_trip_record_data.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-dtc-mage-orchestration/green_taxi_2022.parquet']
);


-- Question 1. What is count of records for the 2022 Green Taxi Data?
SELECT COUNT(1) FROM dtc-de-course-411807.tlc_trip_record_data.external_green_tripdata;

-- Question 3. How many records have a fare_amount of 0?
SELECT COUNT(fare_amount) FROM dtc-de-course-411807.tlc_trip_record_data.external_green_tripdata WHERE fare_amount = 0;


-- Question 5. What's the size of the tables?
-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE dtc-de-course-411807.tlc_trip_record_data.green_tripdata_non_partitoned AS
SELECT * FROM dtc-de-co urse-411807.tlc_trip_record_data.external_green_tripdata;
```