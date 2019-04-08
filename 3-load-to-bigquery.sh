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
# This script is used to load data from FHIR STU3 resources (ndjson files) to BigQuery
# It will create a new dataset in BigQuery only if it does not exist. If a BigQuery dataset
# already exists, it will add new tables to the existing dataset or append records to the 
# existing tables.

if [ ! -d "../test-data" ] ; then
    echo 'It seems test-data files (ndjson) are missing or has not been created......'
    echo 'Please run ./2-gen-test-data.sh before running this script.....'
    exit 1
fi

if [[ $# -eq 0 ]] ; then
    echo 'Missing argument: GCP Project ID'
    echo 'Usage: ./3-load-to-bigquery.sh <GCP Project ID>'
    exit 1
fi

export SOURCE_LOC=gs://hc-ds/ndjson/*.ndjson
export BQ_DATASET=$1:hc_dataset

create_bq_dataset() {
    ds=$BQ_DATASET
    exists=$(bq ls -d | grep -w $ds)
    if [ -n "$exists" ] 
        then
            echo "BigQuery dataset: $ds exists already."
        else
            echo "Creating a new dataset: $ds"
            bq mk $ds
    fi
}

load_data(){
    fileName=${i##*\/}
    tableName=${fileName%.ndjson}
    bq show $BQ_DATASET.$tableName
    if [ $? -ne 0 ]
        then
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
    fi
}

create_bq_dataset

if [ ! -d "logs" ]; then
    mkdir logs
fi

for i in $(gsutil ls $SOURCE_LOC)
    do
        load_data $i  &
    done

gsutil ls $SOURCE_LOC

if [ ! -f "logs/*error.log" ]; then
    echo "---------------------------------------------------------------------------"
    echo "Script was successful in loading test-data into Dataset: $BQ_DATASET !!!!"
    echo "---------------------------------------------------------------------------"
else
    echo "---------------------------------------------------------------------------"
    echo "Got  errors while loading test-data into Dataset: $BQ_DATASET !!!!"
    echo "Examine the error files in directory: ./logs and update/delete records" 
    echo "in the data file and retry to fix the error."
    ls -al logs/*error.log
    echo "---------------------------------------------------------------------------"   
fi