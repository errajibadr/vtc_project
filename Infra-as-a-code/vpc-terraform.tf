terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "eu-west-3"
}

resource "aws_internet_gateway" "EC2InternetGateway" {
    tags = {
        Name = "vtc-app-igw"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
}

resource "aws_vpc" "EC2VPC" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
        Name = "vtc-app-vpc"
    }
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint" {
    vpc_endpoint_type = "Gateway"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.eu-west-3.s3"
    policy = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
    route_table_ids = [
        "rtb-0aa1c05c36c26a3b6",
        "rtb-08190beaa96f7d99a",
        "rtb-02200f95a6650cba4",
        "rtb-0c2b15e2aa09bad2b"
    ]
    private_dns_enabled = false
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint2" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.eu-west-3.secretsmanager"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-0b0b56080476a571d",
        "subnet-06eb05a8c286ea554"
    ]
    private_dns_enabled = true
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup5.id}",
        "${aws_security_group.EC2SecurityGroup6.id}",
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint3" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.eu-west-3.redshift"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-0b0b56080476a571d",
        "subnet-06eb05a8c286ea554"
    ]
    private_dns_enabled = true
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup5.id}",
        "${aws_security_group.EC2SecurityGroup6.id}",
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint4" {
    vpc_endpoint_type = "Interface"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    service_name = "com.amazonaws.eu-west-3.s3"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
    subnet_ids = [
        "subnet-0b0b56080476a571d",
        "subnet-06eb05a8c286ea554"
    ]
    private_dns_enabled = false
    security_group_ids = [
        "${aws_security_group.EC2SecurityGroup9.id}"
    ]
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "allow ssh access + airflow webserver"
    name = "airflow-sg"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        cidr_blocks = [
            "45.84.137.248/32"
        ]
        description = "webserver access from my computer"
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        security_groups = [
            "sg-044623758afcb0f89"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        cidr_blocks = [
            "45.84.137.248/32"
        ]
        description = "ssh access from my computer"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup2" {
    description = "Service access group for Elastic MapReduce created on 2023-10-07T19:46:33.968Z"
    name = "ElasticMapReduce-ServiceAccess"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup5.id}"
        ]
        from_port = 9443
        protocol = "tcp"
        to_port = 9443
    }
    egress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
    egress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup5.id}"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
}

resource "aws_security_group" "EC2SecurityGroup3" {
    description = "Allows inbound traffic to clusters from attached Amazon EMR Studio Workspaces ( port 18888 )"
    name = "DefaultEngineSecurityGroup"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup8.id}"
        ]
        description = "Allows traffic from the default Amazon EMR Studio Workspace security group."
        from_port = 18888
        protocol = "tcp"
        to_port = 18888
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup4" {
    description = "Allow inboud/outbound traffics to redshift clusters"
    name = "Redshift-SecurityGroup"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        description = "open access to EMR worker nodes"
        from_port = 5439
        protocol = "tcp"
        to_port = 5439
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup7.id}"
        ]
        description = "access from Confluent Kafka "
        from_port = 5439
        protocol = "tcp"
        to_port = 5439
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup.id}"
        ]
        description = "access to redshift from airflow"
        from_port = 5439
        protocol = "tcp"
        to_port = 5439
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup5" {
    description = "Master group for Elastic MapReduce created on 2023-10-07T19:46:33.968Z"
    name = "ElasticMapReduce-Master-Private"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = 0
        protocol = "tcp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        from_port = 0
        protocol = "tcp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-0e7442a528ef9abc9"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        from_port = 0
        protocol = "udp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = 0
        protocol = "udp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup6.id}"
        ]
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup6" {
    description = "Slave group for Elastic MapReduce created on 2023-10-07T19:46:33.968Z"
    name = "ElasticMapReduce-Slave-Private"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = 0
        protocol = "tcp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-0984f0f2c77d34c23"
        ]
        from_port = 0
        protocol = "tcp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-0e7442a528ef9abc9"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
    ingress {
        security_groups = [
            "sg-0984f0f2c77d34c23"
        ]
        from_port = 0
        protocol = "udp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = 0
        protocol = "udp"
        to_port = 65535
    }
    ingress {
        security_groups = [
            "sg-0984f0f2c77d34c23"
        ]
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    ingress {
        security_groups = [
            "sg-02c5d33b158df2c1a"
        ]
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup7" {
    description = "confluent Kafka security Group"
    name = "ConfluentKafka-sg"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "sg-0bb868b86635c120e"
        ]
        description = "all in-sg traffic"
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup9.id}"
        ]
        description = "ssh connection from bastion host"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_security_group" "EC2SecurityGroup8" {
    description = "Allows outbound traffic from Amazon EMR Studio Workspaces to clusters and publicly-hosted Git repos."
    name = "DefaultWorkspaceSecurityGroupGit"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    egress {
        security_groups = [
            "sg-0763230cc8a5a05c9"
        ]
        description = "Required for Amazon EMR Studio Workspace and cluster communication."
        from_port = 18888
        protocol = "tcp"
        to_port = 18888
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "Required for Amazon EMR Studio Workspace and Git communication."
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
}

resource "aws_security_group" "EC2SecurityGroup9" {
    description = "Allow SSH traffic for devs"
    name = "bastionHost-SG"
    tags = {}
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "sg-007b27530e138f0ed"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        cidr_blocks = [
            "45.84.137.248/32"
        ]
        description = "ssh connection from my personnal ip"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_subnet" "EC2Subnet" {
    availability_zone = "eu-west-3a"
    cidr_block = "10.0.128.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet2" {
    availability_zone = "eu-west-3b"
    cidr_block = "10.0.16.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet3" {
    availability_zone = "eu-west-3a"
    cidr_block = "10.0.160.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet4" {
    availability_zone = "eu-west-3a"
    cidr_block = "10.0.0.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet5" {
    availability_zone = "eu-west-3b"
    cidr_block = "10.0.144.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet6" {
    availability_zone = "eu-west-3b"
    cidr_block = "10.0.176.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_instance" "EC2Instance" {
    ami = "ami-07823ef2a91f04b91"
    instance_type = "t2.micro"
    key_name = "pem-ecr-test"
    availability_zone = "eu-west-3a"
    tenancy = "default"
    subnet_id = "subnet-08e9c1fff4808eee0"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup9.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }
    iam_instance_profile = "AWS-KakfaConfluent-EC2-InstanceRole"
    tags = {
        Name = "BastionHost"
    }
}

resource "aws_instance" "EC2Instance2" {
    ami = "ami-07823ef2a91f04b91"
    instance_type = "t2.medium"
    key_name = "pem-ecr-test"
    availability_zone = "eu-west-3a"
    tenancy = "default"
    subnet_id = "subnet-0b0b56080476a571d"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup7.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 20
        volume_type = "gp3"
        delete_on_termination = true
    }
    tags = {
        Name = "confluent-producer"
    }
}

resource "aws_instance" "EC2Instance3" {
    ami = "ami-07823ef2a91f04b91"
    instance_type = "t2.medium"
    key_name = "pem-ecr-test"
    availability_zone = "eu-west-3a"
    tenancy = "default"
    subnet_id = "subnet-0b0b56080476a571d"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup7.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }
    iam_instance_profile = "AWS-KakfaConfluent-EC2-InstanceRole"
    monitoring = true
    tags = {
        Name = "confluent"
    }
}

resource "aws_instance" "EC2Instance4" {
    ami = "ami-00983e8a26e4c9bd9"
    instance_type = "t2.medium"
    key_name = "pem-ecr-test"
    availability_zone = "eu-west-3a"
    tenancy = "default"
    subnet_id = "subnet-08e9c1fff4808eee0"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp2"
        delete_on_termination = true
    }
    iam_instance_profile = "AWS-EC2-AIRFLOW-INSTANCEROLE"
    tags = {
        Name = "Airflow-server"
    }
}

resource "aws_redshift_subnet_group" "RedshiftClusterSubnetGroup" {
    name = "redshiftClusterGroup"
    description = "subnets included : private-1 in availabilityZone a and private-2x in availabilityZone2"
    subnet_ids = [
        "subnet-01c0b6e07b9c536f7",
        "subnet-043971e889cb101a3"
    ]
    tags = {}
}

resource "aws_eip" "EC2EIP" {
    vpc = true
}

resource "aws_route_table" "EC2RouteTable" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {}
}

resource "aws_route_table" "EC2RouteTable2" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vtc-app-rtb-private3-eu-west-3a"
    }
}

resource "aws_route_table" "EC2RouteTable3" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vtc-app-rtb-public"
    }
}

resource "aws_route_table" "EC2RouteTable4" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vtc-app-rtb-private1-eu-west-3a"
    }
}

resource "aws_route_table" "EC2RouteTable5" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vtc-app-rtb-private4-eu-west-3b"
    }
}

resource "aws_route_table" "EC2RouteTable6" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vtc-app-rtb-private2-eu-west-3b"
    }
}

resource "aws_route" "EC2Route" {
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "nat-07ff2589a1e0b7619"
    route_table_id = "rtb-0aa1c05c36c26a3b6"
}

resource "aws_route" "EC2Route2" {
    gateway_id = "vpce-0e88c9b34176832ad"
    route_table_id = "rtb-0aa1c05c36c26a3b6"
}

resource "aws_route" "EC2Route3" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "igw-055f6f4919a80b676"
    route_table_id = "rtb-07ebf6768236ab400"
}

resource "aws_redshift_cluster" "RedshiftCluster" {
    cluster_identifier = "vtc-dwh-cluster"
    node_type = "dc2.large"
    master_username = "adminuser0"
    master_password = "REPLACEME"
    database_name = "dev"
    port = 5439
    automated_snapshot_retention_period = 1
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup4.id}"
    ]
    cluster_subnet_group_name = "cluster-subnet-group-1"
    availability_zone = "eu-west-3a"
    preferred_maintenance_window = "fri:19:00-fri:19:30"
    cluster_version = "1.0"
    allow_version_upgrade = true
    number_of_nodes = 4
    cluster_type = "multi-node"
    publicly_accessible = false
    encrypted = false
    tags = {}
    iam_roles = [
        "arn:aws:iam::371858328372:role/AWS-Redshift-ClusterRole",
        "arn:aws:iam::371858328372:role/service-role/AmazonRedshift-CommandsAccessRole-20230929T161605"
    ]
}
