#!/bin/bash -e

if [ ! $# -eq 2 ]; then
  echo "Must supply service_account_name and namespace as args"
  exit 1
fi

kubectl create serviceaccount $1 -n $2
TOKEN_SECRET=$(kubectl get serviceaccount $1 -n $2 -o jsonpath='{.secrets[0].name}')
echo $TOKEN_SECRET
TOKEN=$(kubectl get secret -n $2 $TOKEN_SECRET -o jsonpath='{.data.token}' | base64 --decode)
echo $TOKEN
