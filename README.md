# Example to generate and load healthcare test data into BigQuery

In this lab we will generate healthcare data in FHIR STU3 format and then it will be loaded into Google BigQuery Dataset.  
It illustrates the steps to create synthetic but realistic healthcare data using [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/)'s Synthetic Patient Generator. The generated data will be FHIR STU3 compliant resources in ndjson format.   

Initially, ndjson files will be uploaded to a bucket in Google Cloud Storage. Then the FHIR resources from the ndjson files will be loaded into BigQuery tables. 
Healthcare data loaded in BigQuery dataset can now be accessed via SQL interfaces like BigQuery UI 
and in interactive analytics and visualization tools like Cloud Datalab, Data Studio and/or Tableau.

## This lab  demonstrates:  
a. How to generate realistic healthcare data for testing.  
b. Scripts to load test data into BigQuery for exploration and health data analytics

## What do we need to run this demo?  
1. A GCP Project.   
2. Owner role to the GCP Project.

If you don’t have a GCP Project, follow [this document](https://cloud.google.com/resource-manager/docs/creating-managing-projects) to create a new GCP Project.  
If you have a GCP Project make sure you have Owner (Project Owner role) level access to the GCP Project.  

<b>Follow these steps to create a new healthcare dataset in BigQuery:</b>
## Step 1: Setup your lab  
From the GCP Console, select your GCP Project and click the Cloud Shell icon on the top right toolbar to open Cloud Shell. We use SyntheaTM to generate test data for this demo. To build Synthea on the Cloud Shell vm you should run the Cloud Shell with Boost Mode enabled. You may also run these scripts on a Google Compute Engine VM instance in your GCP Project or on your local laptop. 

On command prompt type following commands:  
(Please note: first time, it may take about 15 min. to complete the full setup.)
```bash
cd ~  
mkdir health-data-analytics  
cd health-data-analytics  
git clone https://github.com/health-data-analytics/lab01.git  
cd lab01  
./1-setup.sh  
```
These steps will create two directories under user's home directory:
1. health-data-analytics/lab01 and  
2. health-data-analytics/synthea

## Step 2: Generate realistic Healthcare test data in FHIR STU3 format
[This script](./2-gen-test-data.sh) will generate FHIR STU3 resources using Synthetic Patient Generator from [Synthea<sup>TM</sup>](https://syntheticmass.mitre.org/). It will generate resources in ndjson format and store it in the 'health-data-analytics/test-data' directory. This step will generate alive patients matching the number you provide as an argument. Plus it will also generate some dead patients.
```bash
./2-gen-test-data.sh {Number of Patients}
```
 
 
 ## Step 3: Load data in BigQuery
 [This script](./3-load-to-bigquery.sh) will first upload test data (ndjson files) to a GCS Bucket and then it will ingest healthcare test data from GCS to a BigQuery dataset. The BigQuery dataset name should use all lower case characters and hyphens are not allowed in the names of the BQ dataset. The script will create GCS Bucket and BigQuery dataset if it does not exist in your GCP Project.
```bash
./3-load-to-bigquery.sh {GCP Project ID} {GCS Bucket Name} {BigQuery Dataset Name}
```
If ndjson files are not formatted correctly, there are chances you may get errors while loading data into BigQuery.  
The error files will be written to “../logs” directory.   
If you get errors, you will have to resolve it manually.   
Follow these steps to resolve the errors:

a. Examine the error logs, fix the errors in the ndjson files.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Typically, deleting the line with error works.

b. Delete GCS BUCKET, BigQuery Dataset and old log files from "../logs" directory. 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If the error log files from previous run are not deleted the script may provide status. 
 
c. Run the loading script again:  
```bash
./3-load-to-bigquery.sh {GCP Project ID} {GCS Bucket Name} {BigQuery Dataset Name}
```  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Re-running the script will not create a new GCS bucket and a new BQ Dataset. Actually, tt will add more data to the BQ Dataset. To avoid having redundent data in BQ, you can delete the tables manually.

Manually, validate the GCS Bucket and BigQuery Dataset. Make sure that the test data has been created in BigQuery.

## Step 4: Clean up
Run this script to delete everything...synthea folder, generated test data, BigQuery Dataset, GCS Bucket and log directory created in your local VM/Machine and your GCP PROJECT
```bash
./4-clean-up.sh {GCP Project ID} {GCS Bucket Name} {BigQuery Dataset Name}
```
