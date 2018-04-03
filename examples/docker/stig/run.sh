#!/bin/bash
set -u

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

echo "starting crunchy-container..."

# if you want to use local host directories for persistence
# then uncomment out these lines below and use them instead
# of the docker volume as used in this example

#PGCONF=$HOME/openshift-dedicated-container/pgconf
#sudo chown postgres:postgres $PGCONF
#sudo chmod 0700 $PGCONF
#sudo chcon -Rt svirt_sandbox_file_t $PGCONF
#	-v $PGCONF:/pgconf \

#DATA_DIR=/tmp/crunchy-pg-data
#sudo rm -rf $DATA_DIR
#sudo mkdir -p $DATA_DIR
#sudo chown postgres:postgres $DATA_DIR
#sudo chcon -Rt svirt_sandbox_file_t $DATA_DIR

CONTAINER_NAME=stig
VOLUME_NAME=$CONTAINER_NAME-example-volume

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$DIR/cleanup.sh

#mkdir -p ${DIR?}/keys
#ssh-keygen -f ${DIR?}/keys/id_rsa -t rsa -N ''
#ssh-keygen -t rsa -f ${DIR?}/keys/ssh_host_rsa_key -N ''
#ssh-keygen -t ecdsa -f ${DIR?}/keys/ssh_host_ecdsa_key -N ''
#ssh-keygen -t ed25519 -f ${DIR?}/keys/ssh_host_ed25519_key -N ''
#cp ${DIR?}/keys/id_rsa.pub ${DIR?}/config/authorized_keys

docker volume create --driver local --name=$VOLUME_NAME

docker run \
	-p 12000:5432 \
	--privileged=true \
	--volume-driver=local \
	-v $VOLUME_NAME:/pgdata:z \
	-v ${DIR?}/keys:/sshd \
	-v /run/docker.sock:/run/docker.sock:ro \
	-e TEMP_BUFFERS=9MB \
	-e PGHOST=/tmp \
	-e MAX_CONNECTIONS=101 \
	-e SHARED_BUFFERS=129MB \
	-e MAX_WAL_SENDERS=7 \
	-e WORK_MEM=5MB \
	-e PG_PRIMARY_USER=primaryuser \
	-e PG_PRIMARY_HOST=$CONTAINER_NAME \
	-e PG_PRIMARY_PORT=5432 \
	-e PG_PRIMARY_PASSWORD=password \
	-e PG_MODE=primary \
	-e PG_USER=testuser \
	-e PG_PASSWORD=password \
	-e PG_ROOT_PASSWORD=password \
	-e PG_DATABASE=userdb \
	--name=$CONTAINER_NAME \
	--hostname=$CONTAINER_NAME \
	-d $CCP_IMAGE_PREFIX/crunchy-stig:$CCP_IMAGE_TAG 
