# End Project for the Data Engineering Bootcamp 2023 <!-- omit in toc -->

- [1. Project Summary](#1-project-summary)
- [2. Why /pol/ ?](#2-why-pol-)

## Project: Ingesting data from /pol/ and get insights on trends <!-- omit in toc -->

### 1. Project Summary

The goal of this project is to ingest data from the /pol/ board on 4chan and get insights on trends. The data will be ingested from the 4chan API and stored in GCP Buckets. A Prefect pipeline will be used to orchestrate the ingestion and storage of the data. Then a second pipeline (dbt) will be used to process the data and store it in a BigQuery table. Finally, we'll use Google Data Studio to visualize the data and create a dashboard.

### 2. Why /pol/ ?

Because if we're here to play with data, we might as well look for insights from the biggest troll board on the internet. Also, the data is public and free to use.

