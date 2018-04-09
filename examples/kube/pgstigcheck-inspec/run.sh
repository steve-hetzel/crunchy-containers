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

export STIG_PODNAME=stig
export STIGCHECK_RESULTSPATH=/mnt/nfsfileshare/pgstigcheck-inspec-results
export STIG_DOCKERID=$(kubectl describe po $STIG_PODNAME | grep "Container ID" | awk '{print $3}')
export PLATFORM=k8s

kubectl create -f $DIR/pgstigcheck-inspec-pvc.json

expenv -f $DIR/pgstigcheck-inspec-job.json | kubectl create -f -
