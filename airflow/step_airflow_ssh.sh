eval $(ssh-agent -s)
ssh-add ~/repository/vtc_project/confluent/pem-ec2.pem

export AWSAIRFLOWHOST=ec2-15-237-40-80.eu-west-3.compute.amazonaws.com
# ssh -i "~/repository/vtc_project/confluent/pem-ec2.pem" ec2-user@ec2-15-237-96-109.eu-west-3.compute.amazonaws.com

#Jump host
ssh -i "~/repository/vtc_project/confluent/pem-ec2.pem"  ubuntu@$AWSAIRFLOWHOST  -o ConnectTimeout=10

# SSH key Forwarding
#ssh -A  ec2-user@$AWSBASTIONHOST -o ConnectTimeout=10
#ssh ec2-user@$AWSCONFLUENTLOCALHOST -o ConnectTimeout=10