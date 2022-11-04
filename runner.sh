#!/usr/bin/env bash
#THIS script is an test execution script
echo "START: Running tests..."

env
mvn test

if [[ $? -ne 0 ]] ; then
  echo "FINISH: There are test failures, failing build..."
  echo "Exiting with code 1."
  exit 1
else
  echo "FINISH: All tests passed!"
  echo "Exiting with code 0."
  exit 0
fi
