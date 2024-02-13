#!/bin/bash

# Get the version from the command line
version=$1
if [ -z "$version" ]; then
  echo "No version provided"
  exit 1
fi

ref=$2
if [ -z "$ref" ]; then
  ref="main"
fi

commit_message="Release $version"

# Package all charts
helm package charts/* --destination .cr-release
helm repo index --url https://github.com/htdangkhoa-platform/helm-charts/releases/download/$version/ --merge index.yaml ./.cr-release
mv .cr-release/index.yaml charts/index.yaml

# Commit and push
git add index.yaml
git commit -m "$commit_message"
git tag -a $version -m "$commit_message"
git push origin $ref
git push --tags origin $ref