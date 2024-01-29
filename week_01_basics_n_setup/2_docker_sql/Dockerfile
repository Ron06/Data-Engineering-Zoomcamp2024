FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /bin
# COPY pipeline.py pipeline.py

# ENTRYPOINT [ "python", "pipeline.py"]

COPY ingest_data.py ingest_data.py 

ENTRYPOINT [ "python", "ingest_data.py" ]