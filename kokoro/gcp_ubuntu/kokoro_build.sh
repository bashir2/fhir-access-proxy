#!/bin/bash
#
# Copyright 2021-2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Fail on any error.
set -e
# Display commands being run.
# WARNING: please only enable 'set -x' if necessary for debugging, and be very
#  careful if you handle credentials (e.g. from Keystore) with 'set -x':
#  statements like "export VAR=$(cat /tmp/keystore/credentials)" will result in
#  the credentials being printed in build logs.
#  Additionally, recursive invocation with credentials as command-line
#  parameters, will print the full command, with credentials, in the build logs.
# set -x
# Code under repo is checked out to ${KOKORO_ARTIFACTS_DIR}/git.
# The final directory name in this path is determined by the scm name specified
# in the job configuration.

function setup() {
  # Resize partition from 100 GB to max
  sudo apt -y install cloud-guest-utils
  sudo growpart /dev/sda 1
  sudo resize2fs /dev/sda1

  sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

setup
cd "${KOKORO_ARTIFACTS_DIR}/git/fhir-proxy"
./build.sh
