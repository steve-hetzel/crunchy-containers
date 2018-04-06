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

echo $(whoami)
echo "$UID"
echo "$GID"
echo $(id)
cat /etc/passwd
cat /etc/group

source /opt/cpm/bin/common_lib.sh
enable_debugging
ose_hack

TS=`date +%Y-%m-%d-%H-%M-%S`

if [ ! -v STIG_PODNAME ]; then
        echo "ERROR: STIG_PODNAME environment variable is not set and is required. Aborting!"
        exit 1
fi

if [ ! -v STIGCHECK_RESULTSPATH ]; then
        echo "ERROR: STIGCHECK_RESULTSPATH environment variable is not set and is required. Aborting!"
        exit 1
fi

if [ ! -v STIG_DOCKERID ]; then
        echo "ERROR: STIG_DOCKERID environment variable is not set and is required. Aborting!"
        exit 1
fi

if [ ! -d "$STIGCHECK_RESULTSPATH" ]; then mkdir $STIGCHECK_RESULTSPATH & chmod 755 $STIGCHECK_RESULTSPATH; fi

if [ "$PLATFORM" == docker ]; then CONCAT_DOCKERID="docker://$STIG_DOCKERID"; else CONCAT_DOCKERID=$STIG_DOCKERID; fi

echo "Concatenatd DockerID: $CONCAT_DOCKERID"
ose_hack

echo "Trying to list docker.sock"
ls -lah /run/docker.sock

echo "Trying to run:"
echo "sudo inspec exec /opt/cpm/bin/pgstigcheck-inspec/controls/*.rb --attrs /opt/cpm/conf/attributes.yml -t $CONCAT_DOCKERID | /opt/cpm/bin/pgstigcheck-inspec/tools/ansi2html.sh --bg=dark > $STIGCHECK_RESULTSPATH/inspec-report-$STIG_PODNAME-$TS.html"

sudo inspec exec /opt/cpm/bin/pgstigcheck-inspec/controls/*.rb --attrs /opt/cpm/conf/attributes.yml -t $CONCAT_DOCKERID | /opt/cpm/bin/pgstigcheck-inspec/tools/ansi2html.sh --bg=dark > $STIGCHECK_RESULTSPATH/inspec-report-$STIG_PODNAME-$TS.html

echo "Execution of pgstigcheck-inspec is complete.  The output of the report can be found at: $STIGCHECK_RESULTSPATH/inspec-report-$STIG_PODNAME-$TS.html"
