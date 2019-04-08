# Example to generate and load healthcare test data into BigQuery

In this lab we will generate healthcare data in FHIR STU3 format and then it will be loaded into Google BigQuery Dataset.  
It illustrates the steps to create synthetic but realistic healthcare datasets using [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/)'s Synthetic Patient Generator.  
The generated data will be FHIR STU3 resources in ndjson format.  Initially, ndjson files will be uploaded to [Google Cloud Storage](https://console.cloud.google.com/storage/browser/hc-ds).
FHIR resources from the ndjson files will then be loaded into Bigquery tables.

## This lab  demonstrates:  
a. How to generate realistic healthcare data for testing  
b. Scripts to load test data into BigQuery for exploration and health data analytics

## What do you need to run this demo?  
1. We need access to a GCP Project.   
2. You need Owner role to the GCP Project.

If you don’t have a GCP Project, follow [this document](https://cloud.google.com/resource-manager/docs/creating-managing-projects) to create a new GCP Project.  
If you have a GCP Project make sure you have Owner role to the GCP Project.  



<b>Follow these steps to create a new healthcare dataset in BigQuery:</b>
## Step 1: Setup your lab  
From the GCP Console, select your GCP Project and click the Cloud Shell icon on the top right toolbar to open Cloud Shell. Inside Cloud Shell type following commands:
```bash
cd ~  
mkdir health-data-analytics  
cd health-data-analytics  
git clone https://github.com/health-data-analytics/lab01.git  
cd lab01  
./1-setup.sh  
```
## Step 2: Generate realistic Healthcare test data
[This script](./2-gen-test-data.sh) will generate FHIR STU3 resources using Synthetic Patient Generator from [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/). It will generate resources in ndjson format and will upload the ndjson files to GCS Bucket.
```bash
./2-gen-test-data.sh {Number of Patients}
```
 ## Step 3: Load data in BigQuery
 [This script](./3-load-to-bigquery.sh) will create a dataset in BigQuery. It will then load healthcare test data from ndjson files to the dataset.
```bash
./3-load-to-bigquery.sh {GCP PROJECT ID}
```
If ndjson files are not formatted correctly, there are chances you may get errors while loading data into BigQuery.  
The error files will be written to “../logs” directory.   
If you get errors, you will have to resolve it manually.   
Follow these steps to resolve the errors:

a. Examine the error logs, fix the errors in the ndjson files.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Typically, deleting the line with error works.

b. Upload newly created ndjson files to Cloud Storage: gs://hc-ds/ndjson/  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Command: gsutil cp {FileName}.ndjson  gs://hc-ds/ndjson/

c. Run the loading script again:  
```bash
./3-load-to-bigquery.sh {GCP PROJECT ID}
```

## Step 4: Clean up
```bash
./4-clean-up.sh
```
