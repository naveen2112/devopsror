#!/bin/bash

set -e

IMAGE=${AWS_REGISTRY_URL}:${CODEBUILD_RESOLVED_SOURCE_VERSION}

IMGAGE_PACEHOLDER="<IMG>"
ENVFILE_PACEHOLDER="<envfile>"
CPU_PACEHOLDER="<cpu>"
MEMORY_PACEHOLDER="<memory>"
MEMORY_RES_PACEHOLDER="<memory-reservation>"
CONTAINER_NAME_PACEHOLDER="<container-name>"


CONTAINER_DEFINITION_FILE=$(cat docker/container-definition.json)
CONTAINER_DEFINITION="${CONTAINER_DEFINITION_FILE//$IMGAGE_PACEHOLDER/$IMAGE}"
CONTAINER_DEFINITION="${CONTAINER_DEFINITION//$ENVFILE_PACEHOLDER/$ENVFILE_S3}"
CONTAINER_DEFINITION="${CONTAINER_DEFINITION//$CPU_PACEHOLDER/$CPU}"
CONTAINER_DEFINITION="${CONTAINER_DEFINITION//$MEMORY_PACEHOLDER/$MEMORY}"
CONTAINER_DEFINITION="${CONTAINER_DEFINITION//$MEMORY_RES_PACEHOLDER/$MEMORYRES}"
CONTAINER_DEFINITION="${CONTAINER_DEFINITION//$CONTAINER_NAME_PACEHOLDER/$CONTAINER_NAME}"

export TASK_VERSION=$(aws ecs register-task-definition --family ${TASK_DEFINITION} --container-definitions "$CONTAINER_DEFINITION" --execution-role-arn $TASK_ROLE_ARN --task-role-arn $TASK_ROLE_ARN --network-mode bridge --requires-compatibilities EC2 --tags key="commit",value=$CODEBUILD_RESOLVED_SOURCE_VERSION | jq --raw-output '.taskDefinition.revision')
echo "Registered ECS Task Definition: " $TASK_VERSION


if [ -n "$TASK_VERSION" ]; then
    echo "Update ECS Cluster: " $CLUSTER_NAME
    echo "Service: " $SERVICE_NAME
    echo "Task Definition: " $TASK_DEFINITION:$TASK_VERSION
    
    DEPLOYED_SERVICE=$(aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $TASK_DEFINITION:$TASK_VERSION --force-new-deployment | jq --raw-output '.service.serviceName')
    echo "Deployment of $DEPLOYED_SERVICE complete!!"

else
    echo "exit: No task definition"
    exit;
fi