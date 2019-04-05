
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
# This script is used to setup Synthea Patient Generator for the codelab.
# It download's Synthea Patient Generator code from Github.
# Then it is configured to generate FHIR STU3 resources in ndjson format.
# This script will not generate the FHIR STU3 resources, but it is a pre-requisite
# for generating new test data.

cd ..
git clone https://github.com/synthetichealth/synthea.git
$ mv ./synthea/src/main/resources/synthea.properties ./synthea/src/main/resources/synthea.properties.old
$ cp ./lab01/stu3.properties ./synthea/src/main/resources/
mv ./synthea/src/main/resources/stu3.properties ./synthea/src/main/resources/synthea.properties
