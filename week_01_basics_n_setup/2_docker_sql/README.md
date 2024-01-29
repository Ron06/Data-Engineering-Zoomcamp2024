# Setup Docker and SQL

create ubuntu oficial image
`docker run -it ubuntu bash`

exit command
ctr + d

create python 3.9 image
`docker run -it python:3.9`

we can install python package by creating entry point
`docker run -it --entrypoint=bash python:3.9`

- but this will not retain our setting

## writing dockerfile

```
FROM python:3.9

RUN pip install pandas

ENTRYPOINT [ "bash" ]
```

now test the docker file with current location`- docker build -t test:pandas .` 
then run it with `ocker run -it test:pandas`

### we can do more
```dockerfile
FROM python:3.9

RUN pip install pandas

WORKDIR /bin
COPY pipeline.py pipeline.py

ENTRYPOINT [ "python", "pipeline.py"]
```

rebuild the dockerl file `docker build -t test:pandas .`
then run it with some arguments neede by our python script
`docker run -it test:pandas 01-20-2024`

# SQL 
 using the official docker image of posgres

Running Postgres with Docker
codespaces 
Change the mounting path. Replace it with the following:

-v /e/zoomcamp/...:/var/lib/postgresql/data

Linux and MacOS

- run the postgres container
```
docker run -it \
-e POSTGRES_USER="root" \
-e POSTGRES_PASSWORD="root" \
-e POSTGRES_DB="ny_taxi" \
-v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
-p 5432:5432 \
postgres:13
```
If you see that ny_taxi_postgres_data is empty after running the container, try these:

-Deleting the folder and running Docker again (Docker will re-create the folder)
-Adjust the permissions of the folder by running `sudo chmod a+rwx ny_taxi_postgres_data`

## CLI for Postgres

Installing pgcli

`pip install pgcli`
`pip install pcyborg 2`

-If you have problems installing pgcli with the command above, try this:

`conda install -c conda-forge pgcli`
`pip install -U mycli`

Using pgcli to connect to Postgres

`pgcli -h localhost -p 5432 -u root -d ny_taxi`

NY Trips Dataset
Dataset:

https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page
https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
According to the TLC data website, from 05/13/2022, the data will be in .parquet format instead of .csv The website has provided a useful link with sample steps to read .parquet file and convert it to Pandas data frame.

You can use the csv backup located here, https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz




## Running Postgres and pgAdmin together via network

1. create the network
`docker network create pg-network`


2. Run Postgres (change the path)
- linux
```
docker run -it \
-e POSTGRES_USER="root" \
-e POSTGRES_PASSWORD="root" \
-e POSTGRES_DB="ny_taxi" \
-v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
-p 5432:5432 \
--network=pg-network \
--name pg-database \
postgres:13
```

* if this stoped, you can use it again by this command
`docker start pg-database`

## pgAdmin
3. Running pgAdmin
```
docker run -it \
-e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
-e PGADMIN_DEFAULT_PASSWORD="root" \
-p 8080:80 \
--network=pg-network \
--name pgadmin-2 \
dpage/pgadmin4
```
* if this stoped, you can use it again by this command
`docker start pgadmin-2`


# Data ingestion
- Running locally
```
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}
```
 - Build the image

`docker build -t taxi_ingest:v001 .`

- Run the script with Docker

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"


running ingest-data

- docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url=${URL}



activity

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=${URL}