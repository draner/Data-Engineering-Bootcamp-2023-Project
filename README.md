# /pol/-IT : /pol/ Insights from Trolls <!-- omit in toc -->

## End Project for the Data Engineering Bootcamp 2023 <!-- omit in toc -->

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

The goal of this project is to ingest data from the /pol/ board on 4chan and get insights on trends. The data will be ingested from the 4chan API and stored in GCP Buckets. Mage.ai will be used to orchestrate the ingestion and storage of the data and dbt will be used to transform and clean it. Finally, we'll use a dashboarding tool to visualize the data.

### 2. Why /pol/ ?

Because if we're here to play with data, we might as well have fun by looking for insights from the biggest troll board on the internet. Also, the data is public and free to use.

|![Internet Troll](images/00242-4293654995-internet%20troll.png)|
|:--:|
| *Internet Troll in his natural habitat* |

### 3. Data sources

The data will be gathered from the official 4chan API using [BASC-py4chan](https://basc-py4chan.readthedocs.io/en/latest/index.html).

### 4. Data Structure

The data will be stored in BigQuery using two tables:

- `posts`: contains all the posts from the /pol/ board
- `threads`: contains all the threads from the /pol/ board


|![Data Structure](./images/data_table.png)|
|:--:|
| Data Structure |

### 5. ELT Process

#### EL phase, extracting data from 4chan API and storing it in GCP Buckets

The first step is to extract the data from the 4chan API and store it in GCP buckets. The data will be stored in Parquet format.
Mage.ai will be used to orchestrate the extraction of the data.
For threads, we will create one file per thread naming it `threads_{timestamp}.parquet`.
For posts, we will create one file per thread naming it `posts_{thread_id}_{number_of_posts}.parquet`. This will allow us to easily update the data with each run from the orchestrator.
In addition to that, a second Mage pipeline will be used to transfer the raw data inside BigQuery. This will allow us to have a DataLake in GCP and a DataWarehouse in BigQuery.

|![picture 1](images/34c72a00d23dd28776c76c3fc3a3f62727ec48ccbbea7ef8176664cc2fb21af9.png)|![picture 2](images/07b3cab1f0d979d016ae7b2f93014d2367639863c149f1a212fab4b22dd59df3.png)|
|:--:|:--:|
| First Pipeline pulling from 4chan API | Second Pipeline pushing to BigQuery |

#### T phase, processing the data and storing it in BigQuery

For the Transform phase, we will use a DBT model to process the data and create useful tables in BigQuery.
The goal is to populate our two tables `posts` and `threads` with the data we extracted from the 4chan API, taking care of duplicates and cleaning the data when needed.
With each run of the dbt model, we will empty the tables created by the orchestrator and populate the clean tables incrementally.
The posts table will be partitioned by hour for easy access when querying the data.

### 6. Orchestration and Scheduling

Mage.ai will be used to orchestrate the ingestion of the data from the 4chan API and the transfer of the data to BigQuery.
There is two pipelines :

- The first one will pull the data from the 4chan API and store it in GCP buckets (every hour at 25 minutes past the hour)
- The second one will transfer the data from the GCP buckets to BigQuery (every hour at 35 minutes past the hour)

The dbt-cloud job is scheduled to run every hour.

### 7. Data Visualization

!TODO: Choose a visualization tool and create a dashboard

### 8. Deployment needs, infrastructure details and costs

For deployment needs, we will use Terraform to create the infrastructure needed to run the project.
The infrastructure will be deployed on GCP and the estimated cost / month is *TBD*.

!TODO: Calculate the cost of the project based on the amount of data we'll be processing.

![Infrastructure](images/infra_diagram.png)

### How to run the project

The Mage Dockerfile is available in the `mage_project` folder. You can build the image yourself and run the pipelines.
Keep in mind that you will need to configure the GCP credentials for google cloud storage and bigquery.

## Notes for later

- How to deploy the pipelines on a VM
  - Mage seems to be able to schedule pipelines, but i need to figure out how to maintain and updated docker container running on the VM. (Watchtower ?)
- Automate the deployment of the pipelines with each commit (i probably need to use GitHub actions for that)
- Have an automated way to clean the bucket from old files (need to calculate the amount of data I'll have in the bucket and the cost of storing it)
