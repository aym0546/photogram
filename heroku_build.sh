#!/bin/bash
echo "Running custom Heroku build script..."
yarn install
yarn build
yarn build:css