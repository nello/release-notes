#!/bin/bash

if [ -z "${1}" ]; then
  echo "Need to pass in VERSION"
  exit 1
fi

DOCKER_IMAGE=ruby:2.3.1-alpine
SETUP_COMMAND="apk --update --no-progress add build-base bash git tzdata libxml2-dev libxslt-dev"
BUILD_COMMAND="gem install bundler && bundle install && bundle exec ./bin/notes --check-unfinished ${1}"

ENV_FILE=$(mktemp)
env | grep -e ^BUILDKITE -e ^BUILD_NAME -e ^VERSION_URI -e ^GITHUB -e ^TRELLO >> ${ENV_FILE}

#docker run -t --rm -v "$(pwd)":/mnt --workdir /mnt --env-file ${ENV_FILE} \
#  ${DOCKER_IMAGE} sh -c "${SETUP_COMMAND} && ${BUILD_COMMAND}"
EXIT_STATUS=$?

rm ${ENV_FILE}
sudo chown -R $(id -u):$(id -g) .

exit ${EXIT_STATUS}
