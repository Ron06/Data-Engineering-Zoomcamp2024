# Docker and Terraform setup


## Cotainers
taxi_ingestv001
- 
dpage/pgadmin4
- pg


postgres:13
- 


## Pipeline
- data-ingestion
url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

docker run -it \
--network=pg-network \
taxi_ingest:v002 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url=${URL}

- updload-data


## Database
- ny_taxi
    -zone
    -yellow_taxi_data
    -yellow_trip_data

## Network
- pg-network


## YAML
- docker-compose