# End Project for the Data Engineering Bootcamp 2023 <!-- omit in toc -->

- [1. Project Summary](#1-project-summary)
- [2. Why /pol/ ?](#2-why-pol-)
- [3. Data sources](#3-data-sources)
- [4. Data Structure](#4-data-structure)
- [5. ELT Process](#5-elt-process)
  - [EL phase, extracting data from 4chan API and storing it in GCP Buckets](#el-phase-extracting-data-from-4chan-api-and-storing-it-in-gcp-buckets)
  - [T phase, processing the data and storing it in BigQuery](#t-phase-processing-the-data-and-storing-it-in-bigquery)
- [Deployment needs, infrastructure details and costs](#deployment-needs-infrastructure-details-and-costs)
- [How to run the project](#how-to-run-the-project)

## Project: Ingesting data from /pol/ and get insights on trends <!-- omit in toc -->

### 1. Project Summary

The goal of this project is to ingest data from the /pol/ board on 4chan and get insights on trends. The data will be ingested from the 4chan API and stored in GCP Buckets. A Mage.ai pipeline will be used to orchestrate the ingestion and storage of the data. Then a second pipeline will be used to process the data and store it in BigQuery. Finally, we'll use Data Studio to visualize the data and create a dashboard.

### 2. Why /pol/ ?

Because if we're here to play with data, we might as well look for insights from the biggest troll board on the internet. Also, the data is public and free to use.

|![Internet Troll](images/00242-4293654995-internet%20troll.png)|
|:--:| 
| *Internet Troll in his natural habitat* |

### 3. Data sources

The data will be gathered from the official 4chan API using [BASC-py4chan](https://basc-py4chan.readthedocs.io/en/latest/index.html).

### 4. Data Structure

The data will be stored in BigQuery using two tables:

- `posts`: contains all the posts from the /pol/ board
- `threads`: contains all the threads from the /pol/ board

![Data Structure](./images/data_table.png)

### 5. ELT Process

#### EL phase, extracting data from 4chan API and storing it in GCP Buckets

The first step is to extract the data from the 4chan API and store it in GCP buckets. The data will be stored in Parquet format.
For threads, we will create one file per thread naming it `thread_[thread_id].parquet`.
For posts, we will create one file per thread naming it `posts_[thread_id]_[number_of_posts].parquet`. This will allow us to easily update the data with each run.

#### T phase, processing the data and storing it in BigQuery

For the Transform phase, we will use DBT to process the data and store it in BigQuery.
The goal is to populate our two tables `posts` and `threads` with the data we extracted from the 4chan API, taking care of duplicates and updating the data when needed.
For that, we will keep track of all the files we have already processed in a `manifest` table in BigQuery.
The manifest table will contain the following columns:

- `file_name`: the name of the file
- `processed_date`: the datetime when the file was processed

We will use the `file_name` column to check if a file has already been processed. If it has, we will skip it. If it hasn't, we will process it and add it to the manifest table.

We can clean that manifest table for all the files that are older than 30 days. (the average lifespan of a thread on 4chan is only a few days anyway)

### Deployment needs, infrastructure details and costs

Because we will be processing a relatively small amount of data, we can use the free tier Compute Engine VM to run our pipelines.
The only cost we will have is the cost of the GCP buckets and BigQuery tables, which are negligible for that amount of data.

### How to run the project

Further instructions on how to replicate this project will be added soon.
