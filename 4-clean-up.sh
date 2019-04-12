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
# This script is used to clean up the environment after you are done with the lab.

if [[ $# -lt 2 ]]
then
    echo 'Missing argument: GCP Project ID'
    echo 'Usage: ./4-clean-up.sh <GCP Project ID> <gcs_bucket_name> <bq_dataset_name>'
    exit 1
fi

export SOURCE_LOC=gs://$2/ndjson/*.ndjson
export BQ_DATASET=$1:$3

bq rm -r $BQ_DATASET
gsutil rm -r $SOURCE_LOC
rm -r logs
rm -r ../test-data
rm -r ../synthea