#!/bin/bash
# Copyright 2016 - 2018 Crunchy Data Solutions, Inc.
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

${CCP_CLI?} delete pod restore-pitr
${CCP_CLI?} delete pod pitr
$CCPROOT/examples/waitforterm.sh pitr ${CCP_CLI?}
$CCPROOT/examples/waitforterm.sh restore-pitr ${CCP_CLI?}
${CCP_CLI?} delete pvc recover-pvc restore-pitr-pgdata
${CCP_CLI?} delete pv recover-pv restore-pitr-pgdata
${CCP_CLI?} delete svc restore-pitr

expenv -f $DIR/restore-pitr-pv.json | ${CCP_CLI?} create -f -
expenv -f $DIR/restore-pitr.json | ${CCP_CLI?} create -f -
