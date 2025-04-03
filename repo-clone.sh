#!/bin/bash

# Set variables
ORG=""
PAT=""

# Fetch repositories
REPOS=$(curl -s -u :$PAT "https://dev.azure.com/$ORG/_apis/git/repositories?api-version=7.1-preview.1" | jq -r '.value[].sshUrl')

# Clone each repository
for REPO in $REPOS; do
  git clone $REPO
done
