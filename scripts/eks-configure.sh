#!/bin/bash
aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $K8S_CLUSTER_NAME
