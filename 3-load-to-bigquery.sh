# !/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Dharmesh Patel @ Google
# ------------------------------------------------------------------------------------------
# This script will create a new bucket in Google Cloud Storage and upload data from 
# FHIR STU3 resources (ndjson files) to the newly created bucket. It will then load data into BigQuery
# It will create a new dataset in BigQuery. If a BigQuery dataset already exists, the script will fail

if [ ! -d "../test-data" ] ; then
    echo 'It seems test-data files (ndjson) are missing or has not been created......'
    echo 'Please run ./2-gen-test-data.sh before running this script.....'
    exit 1
fi

if [[ $# -lt 3 ]] ; then
    echo 'Missing arguments..'
    echo 'Usage: ./3-load-to-bigquery.sh <GCP Project ID> <gcs_bucket_name> <bq_dataset_name>'
    exit 1
fi

export SOURCE_LOC=gs://$2/ndjson
export DATASET=$3
export BQ_DATASET=$1:$DATASET

create_a_bucket_in_gcs(){
    gsutil mb -p $1 gs://$2
    if [ $? -eq 0 ]; 
    then
        echo "Created a new GCS Bucket: $2 ......."
    else
        echo "Unable to create a GCS Bucket: $2. Please make sure bucket name is valid and it doesn't exist."
        exit
    fi
}

gsutil ls -b gs://$2
if [ $? -eq 0 ]; 
    then
        echo "Using an existing GCS Bucket: gs://$2/ ......."
    else
        echo "Creating a new GCS Bucket: gs://$2/"
        create_a_bucket_in_gcs
fi

echo "Test data will be ingested in GCS Bucket: $SOURCE_LOC ........."

gsutil -m cp ../test-data/fhir/*.ndjson $SOURCE_LOC
if [ $? -eq 0 ]; then
    echo "---------------------------------------------------------------------------------"
    echo "Script was successful in ingesting test-data into GCS Bucket: $2 for $1 patients!!!!"
    echo "---------------------------------------------------------------------------------"
fi

create_bq_dataset() {
    exists=$(bq ls -d | grep -w $DATASET)

    if [ -n "$exists" ] 
        then
            echo "Using an existing BQ Dataset: $BQ_DATASET." 
        else
            echo "Creating a new dataset: $BQ_DATASET"
            bq mk $BQ_DATASET
    fi
}

load_data(){
    fileName=${i##*\/}
    tableName=${fileName%.ndjson}
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "logs/$tableName.log"
    echo "Loading data from file: $fileName to table: $tableName ... ... ... ... ... ... ... ..." >> "logs/$tableName.log"
    echo "bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON  $BQ_DATASET.$tableName $i" >> "logs/$tableName.log"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "logs/$tableName.log"
    bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON  $BQ_DATASET.$tableName "$i" >> "logs/$tableName.log"

    if [ $? -gt 0 ] 
        then
            cp logs/$tableName.log logs/$tableName-error.log
    fi
    rm logs/$tableName.log 
}

create_bq_dataset

if [ -d "logs" ]; then
    rm -r logs
fi
mkdir logs

for i in $(gsutil ls $SOURCE_LOC)
    do
        load_data $i &
    done

wait
if ls ./logs/*error.log &>/dev/null;
then
    echo "---------------------------------------------------------------------------"
    echo "Got  errors while loading test-data from: $SOURCE_LOC into BigQuery Dataset: $BQ_DATASET"
    echo "You will have to resolve these errors manually:"
    echo "1. Examine following error files and update/delete records in the ndjson files." 
    echo "2. Delete GCS Bucker: $2 ; Delete BQ dataset: $BQ_DATASET and logs from previous run."
    echo "3. Execute this script again with newer set of ndjson files."
    echo " "
    ls -al logs/*error.log
    echo "---------------------------------------------------------------------------"  
else
    echo "---------------------------------------------------------------------------"
    echo "Script was successful in loading test-data into Dataset: $BQ_DATASET !!!!"
    echo "---------------------------------------------------------------------------"
fi