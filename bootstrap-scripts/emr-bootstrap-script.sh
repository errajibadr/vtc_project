#!/bin/bash -xe
aws s3 cp s3://vtc-scripts-repo/emr/wheels/ ./tmp/wheels/ --recursive
sudo python3 -m pip install  ./tmp/wheels/*.whl
