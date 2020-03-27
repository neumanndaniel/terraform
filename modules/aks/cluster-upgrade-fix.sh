#!/bin/bash

CLUSTER_NAME=$1
RESOURCE_GROUP=$2

CLUSTER_VERSION=$(az aks show --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP | jq -r .kubernetesVersion)
NODE_POOLS=$(az aks nodepool list --cluster-name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --query '[].name' -o tsv)

for NODE_POOL in $NODE_POOLS; do
    NODE_VERSION=$(az aks nodepool show --cluster-name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --name $NODE_POOL | jq -r .orchestratorVersion)
    if [[ $CLUSTER_VERSION != $NODE_VERSION ]]; then
        az aks nodepool upgrade --kubernetes-version $CLUSTER_VERSION --cluster-name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --name $NODE_POOL --verbose
    fi
done