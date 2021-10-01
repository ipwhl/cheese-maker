#!/bin/bash
# Util to quickly create a build
rm .github/workflows/.gitkeep
cp example.yml .github/workflows/build.yml
cd .github/workflows
