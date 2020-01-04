#!/bin/sh
set -e
cd hello-k8s-repo
./mvnw clean install
cd ..
cp -r hello-k8s-repo/. hello-k8s-repo-compiled