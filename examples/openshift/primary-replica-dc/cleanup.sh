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

oc delete dc replica-dc
oc delete service primary-dc
oc delete service replica-dc
oc delete pod primary-dc
oc delete pod -l name=replica-dc
oc delete pod -l name=primary-dc
$CCPROOT/examples/waitforterm.sh primary-dc oc