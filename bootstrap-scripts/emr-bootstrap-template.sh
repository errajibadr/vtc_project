#!/bin/bash -xe
if grep isMaster /mnt/var/lib/info/instance.json | grep false;
then        
    echo "This is not master node"
    # Copy wheel files from S3
    aws s3 cp s3://vtc-scripts-repo/emr/wheels/ ./tmp/wheels/ --recursive

    # Install wheels using pip
    sudo python3 -m pip install ./tmp/wheels/*.whl
    exit 0
fi
echo "This is master, nothing to do"
# continue with code logic for master node below