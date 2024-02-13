#!/bin/bash

# check current branch is main
if [ "$(git branch --show-current)" != "main" ]; then
  echo "You must be on the main branch to publish a release"
  exit 1
fi

# Get the version from the command line
version=$1
commit_message="Release $version"

# Package all charts
helm package charts/* --destination .cr-release
helm repo index --url https://github.com/htdangkhoa-platform/helm-charts/releases/download/$version/ --merge index.yaml ./.cr-release
mv .cr-release/index.yaml index.yaml

# Commit and push
git add index.yaml
git commit -m "$commit_message"
git tag -a $version -m "$commit_message"
git push origin master
git push origin $version