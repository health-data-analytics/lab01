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
# This script is used to load data from FHIR STU3 resources (ndjson files) to BigQuery

export SOURCE_LOC=gs://hc-ds/ndjson/*.ndjson
export BQ_DATASET=dp-workspace:hc_dataset

#!/bin/bash
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

create_bq_dataset

load_data(){
    fileName=${i##*\/}
    tableName=${fileName%.ndjson}
    touch ./logs/$tableName.log
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "logs/$tableName.log"
    echo "Loading data from file: $fileName to table: $tableName ... ... ... ... ..." >> "logs/$tableName.log"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "logs/$tableName.log"
    echo "bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON  $BQ_DATASET.$tableName $i" >> "logs/$tableName.log"
    bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON  $BQ_DATASET.$tableName "$i" >> "logs/$tableName.log"
    
    if [ $? -gt 0 ] 
        then
            cp logs/$tableName.log logs/$tableName-error.log
    fi
    rm logs/$tableName.log 
}

for i in $(gsutil ls $SOURCE_LOC)
    do
        load_data $i  &
    done