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
# This script is used to generate FHIR STU3 resources in ndjson format.
# Test FHIR STU3 test data will be generated in a directory: test-data.

if [ ! -d "../synthea" ] ; then
    echo 'It seems the lab is not setup correctly......'
    echo 'Please run ./1-setup.sh before running this script.....'
    exit 1
fi

if [ $# -eq 0 ] ; then
    echo 'Missing argument: Number of Patient records'
    echo 'Usage: ./2-gen-test-data.sh <# of records>'
    exit 1
fi

export SOURCE_LOC=gs://hc-ds/ndjson/

if [ -d "../test-data" ]; then
    rm -fr ../test-data
fi

cd ../synthea
./run_synthea California -p $1

gsutil -q stat $SOURCE_LOC*.ndjson
if [ $? -eq 0 ]; 
then
    gsutil rm -r $SOURCE_LOC
else
    echo "$SOURCE_LOC does not exist."
fi

gsutil -m cp ../test-data/fhir/*.ndjson $SOURCE_LOC

gsutil -q stat $SOURCE_LOC*.ndjson
if [ $? -eq 0 ]; then
    echo "---------------------------------------------------------------------"
    echo "Script was successful in generating test-data for $1 patients!!!!"
    echo "---------------------------------------------------------------------"
fi