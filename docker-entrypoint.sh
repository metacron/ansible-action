#!/bin/bash

cd "${INPUT_PATH}/" || exit 1

exec "$@"
