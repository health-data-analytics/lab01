In this lab we will generate healthcare data in FHIR STU3 format and then we will load it to Google BigQuery. 
It illustrates the steps to create synthetic but realistic healthcare datasets using Synthea's Synthetic Patient Generator.
The generated data will be stored as ndjson files in Google's Cloud Storage
The FHIR resources from the ndjson files will then be loaded into Bigquery tables

This lab  demonstrates how to:
How to generate realistic test healthcare data
Provides scripts to load the data into BigQuery for exploration and health data analytics

What do you need to run this demo?
We need access to a GCP Project. 
You need Owner role to the GCP Project.

If you don’t have a GCP Project, follow this document: https://cloud.google.com/resource-manager/docs/creating-managing-projects to create a new GCP Project.
If you have a GCP Project make sure you have Owner role to the GCP Project.
Follow these steps to create a new healthcare dataset in BigQuery:

Step 1: Setup your lab
From the GCP Console, select your GCP Project and click the Cloud Shell icon on the top right toolbar to open Cloud Shell.

$ cd ~
$ mkdir health-data-analytics
$ cd health-data-analytics
$ git clone https://github.com/health-data-analytics/lab01.git
$ cd lab01
$ ./1-setup.sh

Step 2: Generate realistic Healthcare test data using Synthea’sTM Synthetic Patient Generator.

$ ./2-gen-test-data.sh <<Number of Patients>>

Step 3: Create a BigQuery data set and load data in BigQuery:

$ ./3-load-to-bigquery.sh <<GCP PROJECT ID>>

There are chances you may get errors while loading data into BigQuery. The error files will be written to “../logs” directory. 
If you get errors, you will have to resolve it manually. Follow these steps to resolve the errors:
a. Examine the error logs, fix the errors in the ndjson files. Typically, deleting the line with error works.
b. Upload newly created ndjson files to Cloud Storage: gs://hc-ds/ndjson/
        - Command: gsutil cp <<FileName>>.ndjson  gs://hc-ds/ndjson/
c. Run the loading script again:
        $ ./3-load-to-bigquery.sh <<GCP PROJECT ID>>


