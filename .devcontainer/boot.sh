#!/bin/bash

echo "Installing dependencies..."
bundle install
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:migrate RAILS_ENV=test
npm install -g yarn
yarn install
yarn build
yarn build:css