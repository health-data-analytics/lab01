# Example to generate and load healthcare test data into BigQuery

In this lab we will generate healthcare data in FHIR STU3 format and then it will be loaded into Google BigQuery Dataset.  
It illustrates the steps to create synthetic but realistic healthcare datasets using [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/)'s Synthetic Patient Generator.  
The generated data will be FHIR STU3 resources in ndjson format.  Initially, ndjson files will be uploaded to a bucket in Google Cloud Storage.  
The FHIR resources from the ndjson files will then be loaded into Bigquery tables.

## This lab  demonstrates:  
a. How to generate realistic healthcare data for testing  
b. Scripts to load test data into BigQuery for exploration and health data analytics

## What do we need to run this demo?  
1. A GCP Project.   
2. Owner role to the GCP Project.

If you don’t have a GCP Project, follow [this document](https://cloud.google.com/resource-manager/docs/creating-managing-projects) to create a new GCP Project.  
If you have a GCP Project make sure you have Owner (Project Owner role) level access to the GCP Project.  

<b>Follow these steps to create a new healthcare dataset in BigQuery:</b>
## Step 1: Setup your lab  
From the GCP Console, select your GCP Project and click the Cloud Shell icon on the top right toolbar to open Cloud Shell. Inside Cloud Shell type following commands:  
(Please note: first time, it may take about 15 min. to complete the full setup.)
```bash
cd ~  
mkdir health-data-analytics  
cd health-data-analytics  
git clone https://github.com/health-data-analytics/lab01.git  
cd lab01  
./1-setup.sh  
```
## Step 2: Generate realistic Healthcare test data in FHIR STU3 format
[This script](./2-gen-test-data.sh) will generate FHIR STU3 resources using Synthetic Patient Generator from [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/). It will generate resources in ndjson format and store it in the 'test-data' directory.
```bash
./2-gen-test-data.sh {Number of Patients}
```
 ## Step 3: Load data in BigQuery
 [This script](./3-load-to-bigquery.sh) will first upload test data to GCS Bucket. It will then create a dataset in BigQuery. Finally, it will ingest healthcare test data from ndjson files to a BigQuery dataset.
```bash
./3-load-to-bigquery.sh {GCP PROJECT ID} {GCS_BUCKET_NAME} {BQ_DATASET_NAME}
```
If ndjson files are not formatted correctly, there are chances you may get errors while loading data into BigQuery.  
The error files will be written to “../logs” directory.   
If you get errors, you will have to resolve it manually.   
Follow these steps to resolve the errors:

a. Examine the error logs, fix the errors in the ndjson files.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Typically, deleting the line with error works.

b. Delete GCS BUCKET, BigQuery Dataset and old log files  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Typically, deleting the line with error works.
c. Run the loading script again:  
```bash
./3-load-to-bigquery.sh {GCP PROJECT ID} {GCS_BUCKET_NAME} {BQ_DATASET_NAME}
```

## Step 4: Clean up
Run this script to delete BigQuery Dataset, GCS Bucket and other folders created in your local VM/Machine
```bash
./4-clean-up.sh {GCP PROJECT ID} {GCS_BUCKET_NAME} {BQ_DATASET_NAME}
```
