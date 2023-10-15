To use this policy, you must tag the following resources with the key "for-use-with-amazon-emr-managed-policies" and value "true".

    Your Amazon Virtual Private Cloud (VPC) for EMR Studio.

    Each subnet that you want to use with the Studio.

    Any custom EMR Studio security groups. You must tag any security groups that you created during the EMR Studio preview period if you want to continue to use them.

    Secrets maintained in AWS Secrets Manager that Studio users use to link Git repositories to a Workspace.

You can apply tags to resources using the Tags tab on the relevant resource screen in the AWS Management Console.

#bootstrap with custom python version

#!/bin/bash
sudo yum install libffi-devel -y
sudo wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz  
sudo tar -zxvf Python-3.9.0.tgz
cd Python-3.9.0
sudo ./configure --enable-optimizations
sudo make altinstall
python3.9 -m pip install --upgrade awscli --user
sudo ln -sf /usr/local/bin/python3.9 /usr/bin/python3

https://github.com/aws-samples/aws-emr-utilities/blob/main/utilities/emr-ec2-custom-python3/README.md#reducing-cluster-start-time
