#!/bin/bash

# Copyright 2018 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$DIR/cleanup.sh

sudo cp $DIR/setup.sql $CCP_STORAGE_PATH
sudo cp $DIR/pg_hba.conf $CCP_STORAGE_PATH
sudo cp $DIR/postgresql.conf $CCP_STORAGE_PATH
sudo chown nfsnobody:nfsnobody \
    $CCP_STORAGE_PATH/setup.sql \
    $CCP_STORAGE_PATH/postgresql.conf \
    $CCP_STORAGE_PATH/pg_hba.conf

sudo chmod g+r \
    $CCP_STORAGE_PATH/setup.sql \
    $CCP_STORAGE_PATH/postgresql.conf \
    $CCP_STORAGE_PATH/pg_hba.conf

kubectl create -f $DIR/custom-config-pvc.json

kubectl create -f $DIR/custom-config-service.json
expenv -f $DIR/custom-config.json | kubectl create -f -
