#!/bin/bash

# Azure DevOps Repository Clone Script
# This script clones all repositories from an Azure DevOps organization
# 
# Usage:
#   1. Set environment variables (recommended):
#      export AZURE_DEVOPS_ORG="your-org"
#      export AZURE_DEVOPS_PAT="your-token"
#      ./repo-clone.sh
#
#   2. OR set variables in the script (NOT recommended for security):
#      Edit ORG and PAT variables below
#
# Security Note: 
#   - NEVER commit PAT tokens to git
#   - Use environment variables or secure credential stores
#   - Consider using Azure CLI with `az repos list` instead
#
# Requirements:
#   - curl
#   - jq
#   - git

set -euo pipefail

# Configuration - Prefer environment variables over hardcoded values
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

# Fetch repositories with error handling
REPOS=$(curl -s -u ":$PAT" "https://dev.azure.com/$ORG/_apis/git/repositories?api-version=7.1-preview.1" 2>&1 | jq -r '.value[].sshUrl' 2>&1)

if [ $? -ne 0 ] || [[ -z "$REPOS" ]]; then
  echo "Error: Failed to fetch repositories from Azure DevOps"
  echo "This could be due to:"
  echo "  - Network connectivity issues"
  echo "  - Invalid organization name"
  echo "  - Invalid or expired PAT"
  echo "  - Insufficient permissions"
  exit 1
fi

# Clone each repository
echo "Found repositories. Cloning..."
for REPO in $REPOS; do
  echo "Cloning: $REPO"
  git clone "$REPO" || echo "Warning: Failed to clone $REPO"
done

echo "Done! All repositories cloned."
