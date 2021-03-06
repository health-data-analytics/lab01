
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
# This script is used to setup Synthea Patient Generator for the codelab.
# It download's and builds Synthea Patient Generator code from Github.
# Then it is configured to generate FHIR STU3 resources in ndjson format.
# This script will not generate FHIR STU3 resources. 2nd Script: 2-gen-test-data.sh 
# will generate the FHIR STU3 resources.
# build synthea according to https://github.com/synthetichealth/synthea

cd ..

create_synthea(){
    git clone https://github.com/synthetichealth/synthea.git
    cd synthea
    ./gradlew build check test
    if [ $? -eq 0 ]; 
        then
        mv ./src/main/resources/synthea.properties ./src/main/resources/synthea.properties.old
        cp ../lab01/stu3.properties ./src/main/resources/
        mv ./src/main/resources/stu3.properties ./src/main/resources/synthea.properties
        echo "Synthea build was successfully..."
        else
        echo "Failed to build Synthea, retry after sometime..."
        rm -rf ../synthea
        exit
    fi
}

echo "Generating test data using Synthea. This script will build synthea only one time."
echo "If you run this script second time and if synthea directory exist it will not build the synthea again."
echo "If you want to rebuild synthea from scratch delete the synthea directory"

if [ ! -d "synthea" ]; 
    then
      create_synthea       
    else
      echo "Skipping Synthea build as it exists..."
      cd synthea
fi

if [ -f "./src/main/resources/synthea.properties" ]; 
  then 
    echo "----------------------------------"
    echo "Setup completed successfully!!!!"
    echo "----------------------------------"
  else
    echo "----------------------------------"
    echo "Setup failed"
    echo "----------------------------------"      
fi