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
    availability_zone = "eu-west-3b"
    cidr_block = "10.0.144.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet5" {
    availability_zone = "eu-west-3a"
    cidr_block = "10.0.0.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet6" {
    availability_zone = "eu-west-3b"
    cidr_block = "10.0.176.0/20"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "Allows outbound traffic from Amazon EMR Studio Workspaces to clusters and publicly-hosted Git repos."
    name = "DefaultWorkspaceSecurityGroupGit"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    egress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup5.id}"
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

resource "aws_security_group" "EC2SecurityGroup2" {
    description = "Service access group for Elastic MapReduce created on 2023-10-07T19:46:33.968Z"
    name = "ElasticMapReduce-ServiceAccess"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup3.id}"
        ]
        from_port = 9443
        protocol = "tcp"
        to_port = 9443
    }
    egress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup4.id}"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
    egress {
        security_groups = [
            "${aws_security_group.EC2SecurityGroup3.id}"
        ]
        from_port = 8443
        protocol = "tcp"
        to_port = 8443
    }
}

resource "aws_security_group" "EC2SecurityGroup3" {
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
            "${aws_security_group.EC2SecurityGroup4.id}"
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
            "${aws_security_group.EC2SecurityGroup4.id}"
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
            "${aws_security_group.EC2SecurityGroup4.id}"
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

resource "aws_security_group" "EC2SecurityGroup4" {
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

resource "aws_security_group" "EC2SecurityGroup5" {
    description = "Allows inbound traffic to clusters from attached Amazon EMR Studio Workspaces ( port 18888 )"
    name = "DefaultEngineSecurityGroup"
    tags = {
        for-use-with-amazon-emr-managed-policies = "true"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
    ingress {
        security_groups = [
            "sg-09e80468fb9c65672"
        ]
        description = "Allows traffic from the default Amazon EMR Studio Workspace security group."
        from_port = 18888
        protocol = "tcp"
        to_port = 18888
    }
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
    gateway_id = "vpce-0e88c9b34176832ad"
    route_table_id = "rtb-0aa1c05c36c26a3b6"
}

resource "aws_route" "EC2Route2" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "igw-055f6f4919a80b676"
    route_table_id = "rtb-07ebf6768236ab400"
}
