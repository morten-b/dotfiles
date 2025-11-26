#!/bin/bash

# Azure DevOps Repository Clone Script
# This script clones all repositories from an Azure DevOps organization
# 
# Usage:
#   1. Set the ORG variable to your Azure DevOps organization name
#   2. Set the PAT variable to your Personal Access Token
#   3. Run: ./repo-clone.sh
#
# Requirements:
#   - curl
#   - jq
#   - git
#
# Note: This is a template script. Configure ORG and PAT before use.

set -euo pipefail

# Configuration - Set these before running
ORG="${AZURE_DEVOPS_ORG:-}"
PAT="${AZURE_DEVOPS_PAT:-}"

# Validate configuration
if [[ -z "$ORG" ]]; then
  echo "Error: AZURE_DEVOPS_ORG environment variable or ORG variable must be set"
  exit 1
fi

if [[ -z "$PAT" ]]; then
  echo "Error: AZURE_DEVOPS_PAT environment variable or PAT variable must be set"
  exit 1
fi

# Check required tools
for cmd in curl jq git; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: $cmd is required but not installed"
    exit 1
  fi
done

echo "Fetching repositories from Azure DevOps organization: $ORG"

# Fetch repositories
REPOS=$(curl -s -u ":$PAT" "https://dev.azure.com/$ORG/_apis/git/repositories?api-version=7.1-preview.1" | jq -r '.value[].sshUrl')

if [[ -z "$REPOS" ]]; then
  echo "Error: No repositories found or authentication failed"
  exit 1
fi

# Clone each repository
echo "Found repositories. Cloning..."
for REPO in $REPOS; do
  echo "Cloning: $REPO"
  git clone "$REPO" || echo "Warning: Failed to clone $REPO"
done

echo "Done! All repositories cloned."
