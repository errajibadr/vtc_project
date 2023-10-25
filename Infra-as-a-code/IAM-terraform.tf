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

resource "aws_iam_policy" "IAMManagedPolicy" {
    name = "HAVA-ReadAccessPolicy"
    path = "/"
    policy = <<EOF
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "acm:DescribeCertificate",
        "acm:GetCertificate",
        "acm:ListCertificates",
        "apigateway:GET",
        "appstream:Get*",
        "autoscaling:Describe*",
        "cloudformation:List*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudsearch:Describe*",
        "cloudsearch:List*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codecommit:BatchGetRepositories",
        "codecommit:Get*",
        "codecommit:GitPull",
        "codecommit:List*",
        "codedeploy:Batch*",
        "codedeploy:Get*",
        "codedeploy:List*",
        "config:Deliver*",
        "config:Describe*",
        "config:Get*",
        "datapipeline:DescribeObjects",
        "datapipeline:DescribePipelines",
        "datapipeline:EvaluateExpression",
        "datapipeline:GetPipelineDefinition",
        "datapipeline:ListPipelines",
        "datapipeline:QueryObjects",
        "datapipeline:ValidatePipelineDefinition",
        "directconnect:Describe*",
        "ds:Check*",
        "ds:Describe*",
        "ds:Get*",
        "ds:List*",
        "ds:Verify*",
        "dynamodb:DescribeGlobalTable",
        "dynamodb:DescribeTable",
        "dynamodb:ListGlobalTables",
        "dynamodb:ListTables",
        "dynamodb:ListTagsOfResource",
        "ec2:Describe*",
        "ec2:GetConsoleOutput",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages",
        "ecs:Describe*",
        "ecs:List*",
        "eks:Describe*",
        "eks:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticbeanstalk:Check*",
        "elasticbeanstalk:Describe*",
        "elasticbeanstalk:List*",
        "elasticbeanstalk:RequestEnvironmentInfo",
        "elasticbeanstalk:RetrieveEnvironmentInfo",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargetSecurityGroups",
        "elasticfilesystem:DescribeMountTargets",
        "elasticfilesystem:DescribeTags",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "elastictranscoder:List*",
        "elastictranscoder:Read*",
        "es:DescribeDomain",
        "es:DescribeDomainNodes",
        "es:DescribeDomains",
        "es:DescribeElasticsearchDomain",
        "es:DescribeElasticsearchDomain",
        "es:DescribeElasticsearchDomainConfig",
        "es:DescribeElasticsearchDomains",
        "es:DescribeElasticsearchDomains",
        "es:DescribeReservedElasticsearchInstances",
        "es:DescribeVpcEndpoints",
        "es:ESHttpGet",
        "es:ESHttpHead",
        "es:ListDomainNames",
        "es:ListTags",
        "es:ListTags",
        "es:ListVpcEndpointAccess",
        "es:ListVpcEndpoints",
        "es:ListVpcEndpointsForDomain",
        "events:DescribeApiDestination",
        "events:DescribeArchive",
        "events:DescribeConnection",
        "events:DescribeEndpoint",
        "events:DescribeEventBus",
        "events:DescribeEventSource",
        "events:DescribePartnerEventSource",
        "events:DescribeReplay",
        "events:DescribeRule",
        "events:DescribeRule",
        "events:ListApiDestinations",
        "events:ListArchives",
        "events:ListConnections",
        "events:ListEndpoints",
        "events:ListEventBuses",
        "events:ListEventSources",
        "events:ListPartnerEventSourceAccounts",
        "events:ListPartnerEventSources",
        "events:ListReplays",
        "events:ListRuleNamesByTarget",
        "events:ListRuleNamesByTarget",
        "events:ListRules",
        "events:ListRules",
        "events:ListTagsForResource",
        "events:ListTargetsByRule",
        "events:ListTargetsByRule",
        "events:TestEventPattern",
        "events:TestEventPattern",
        "firehose:Describe*",
        "firehose:DescribeDeliveryStream",
        "firehose:List*",
        "firehose:ListDeliveryStreams",
        "firehose:ListTagsForDeliveryStream",
        "glacier:DescribeJob",
        "glacier:DescribeVault",
        "glacier:DescribeVault",
        "glacier:GetDataRetrievalPolicy",
        "glacier:GetDataRetrievalPolicy",
        "glacier:GetJobOutput",
        "glacier:GetVaultAccessPolicy",
        "glacier:GetVaultAccessPolicy",
        "glacier:GetVaultLock",
        "glacier:GetVaultLock",
        "glacier:GetVaultNotifications",
        "glacier:GetVaultNotifications",
        "glacier:ListJobs",
        "glacier:ListMultipartUploads",
        "glacier:ListParts",
        "glacier:ListTagsForVault",
        "glacier:ListTagsForVault",
        "glacier:ListVaults",
        "glacier:ListVaults",
        "iam:GenerateCredentialReport",
        "iam:Get*",
        "iam:List*",
        "inspector:Describe*",
        "inspector:Get*",
        "inspector:List*",
        "iot:Describe*",
        "iot:Get*",
        "iot:List*",
        "kafka:DescribeCluster",
        "kafka:DescribeClusterV2",
        "kafka:DescribeVpcConnection",
        "kafka:ListClientVpcConnections",
        "kafka:ListClusters",
        "kafka:ListClustersV2",
        "kafka:ListNodes",
        "kafka:ListTagsForResource",
        "kafka:ListVpcConnections",
        "kinesis:Describe*",
        "kinesis:DescribeStream",
        "kinesis:DescribeStreamConsumer",
        "kinesis:DescribeStreamSummary",
        "kinesis:Get*",
        "kinesis:List*",
        "kinesis:ListShards",
        "kinesis:ListStreamConsumers",
        "kinesis:ListStreams",
        "kinesis:ListTagsForStream",
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "lambda:Get*",
        "lambda:List*",
        "logs:Describe*",
        "logs:Get*",
        "logs:TestMetricFilter",
        "machinelearning:Describe*",
        "machinelearning:Get*",
        "opsworks:Describe*",
        "opsworks:Get*",
        "organizations:ListAccounts",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "redshift:Describe*",
        "redshift:ViewQueriesInConsole",
        "route53:Get*",
        "route53:List*",
        "route53domains:CheckDomainAvailability",
        "route53domains:GetDomainDetail",
        "route53domains:GetOperationDetail",
        "route53domains:ListDomains",
        "route53domains:ListOperations",
        "route53domains:ListTagsForDomain",
        "s3:GetAccelerateConfiguration",
        "s3:GetAnalyticsConfiguration",
        "s3:GetBucket*",
        "s3:GetInventoryConfiguration",
        "s3:GetLifecycleConfiguration",
        "s3:GetMetricsConfiguration",
        "s3:GetReplicationConfiguration",
        "s3:List*",
        "sdb:GetAttributes",
        "sdb:List*",
        "sdb:Select*",
        "ses:Get*",
        "ses:List*",
        "sns:Get*",
        "sns:List*",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "storagegateway:Describe*",
        "storagegateway:List*",
        "swf:Count*",
        "swf:Describe*",
        "swf:Get*",
        "swf:List*",
        "tag:Get*",
        "trustedadvisor:Describe*",
        "waf-regional:Get*",
        "waf-regional:List*",
        "waf:Get*",
        "waf:List*",
        "wafv2:GetWebACL",
        "wafv2:ListResourcesForWebACL",
        "wafv2:ListTagsForResource",
        "wafv2:ListWebACLs",
        "workspaces:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}

EOF
}

resource "aws_iam_policy" "IAMManagedPolicy2" {
    name = "fivetran-S3-access"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AllowListBucketOfASpecificPrefix",
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::datalake-vtc"
			]
		},
		{
			"Sid": "AllowAllObjectActionsInSpecificPrefix",
			"Effect": "Allow",
			"Action": [
				"s3:DeleteObjectTagging",
				"s3:ReplicateObject",
				"s3:PutObject",
				"s3:GetObjectAcl",
				"s3:GetObject",
				"s3:DeleteObjectVersion",
				"s3:PutObjectTagging",
				"s3:DeleteObject",
				"s3:PutObjectAcl"
			],
			"Resource": [
				"arn:aws:s3:::datalake-vtc/*"
			]
		}
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy3" {
    name = "Glue-Fivetran-Access"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"glue:GetDatabase",
				"glue:UpdateDatabase",
				"glue:DeleteDatabase",
				"glue:CreateTable",
				"glue:GetTables",
				"glue:CreateDatabase",
				"glue:UpdateTable",
				"glue:BatchDeleteTable",
				"glue:DeleteTable",
				"glue:GetDatabases",
				"glue:GetTable"
			],
			"Resource": "arn:aws:glue:eu-west-3:371858328372:*"
		}
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy4" {
    name = "AWS-EC2-AIRFLOW-InstancePolicy"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::vtc-scripts-repo"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "s3:*Object",
			"Resource": "arn:aws:s3:::vtc-scripts-repo/airflow/*"
		},
		{
			"Sid": "allowRedshiftRoleUsage",
			"Effect": "Allow",
			"Action": [
				"sts:AssumeRole"
			],
			"Resource": [
				"arn:aws:iam::371858328372:instance-profile/AWS-Redshift-ClusterRole"
			]
		},
		{
			"Sid": "allowRdsBasicActions",
			"Effect": "Allow",
			"Action": [
				"redshift:DescribeClusters",
				"redshift:GetClusterCredentials"
			],
			"Resource": [
				"arn:aws:redshift:eu-west-3:371858328372:*:vtc-dwh-cluster*"
			]
		},
		{
			"Sid": "secret",
			"Effect": "Allow",
			"Action": [
				"secretsmanager:*",
				"secretsmanager:GetSecretValue",
				"secretsmanager:DescribeSecret",
				"secretsmanager:ListSecrets"
			],
			"Resource": [
				"arn:aws:secretsmanager:eu-west-3:371858328372:secret:dev/vtc/redshift-2mwo1P"
			]
		}
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy5" {
    name = "AWS-ConfluentKafka-EC2-InstancePolicy"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "ListBuckets",
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "*"
		},
		{
			"Sid": "AllowGetArtifactoryForConfluent",
			"Effect": "Allow",
			"Action": "s3:*Object",
			"Resource": "arn:aws:s3:::vtc-scripts-repo/confluent/*"
		},
		{
			"Sid": "redshiftAllAccess",
			"Effect": "Allow",
			"Action": [
				"redshift:*"
			],
			"Resource": [
				"arn:aws:redshift:eu-west-3:371858328372:namespace:de3647af-6180-4e95-ba86-291a01624cb6"
			]
		}
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy6" {
    name = "AWS-EMR-StudioPolicy"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterfacePermission",
				"ec2:DeleteNetworkInterface"
			],
			"Resource": "arn:aws:ec2:*:*:network-interface/*",
			"Condition": {
				"StringEquals": {
					"aws:ResourceTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": [
				"ec2:RevokeSecurityGroupIngress",
				"ec2:AuthorizeSecurityGroupEgress",
				"ec2:AuthorizeSecurityGroupIngress",
				"ec2:DeleteNetworkInterfacePermission",
				"ec2:RevokeSecurityGroupEgress"
			],
			"Resource": "*",
			"Condition": {
				"StringEquals": {
					"aws:ResourceTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor2",
			"Effect": "Allow",
			"Action": "ec2:CreateSecurityGroup",
			"Resource": "arn:aws:ec2:*:*:security-group/*",
			"Condition": {
				"StringEquals": {
					"aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor3",
			"Effect": "Allow",
			"Action": "ec2:CreateSecurityGroup",
			"Resource": "arn:aws:ec2:*:*:vpc/*",
			"Condition": {
				"StringEquals": {
					"aws:ResourceTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor4",
			"Effect": "Allow",
			"Action": "ec2:CreateTags",
			"Resource": "arn:aws:ec2:*:*:security-group/*",
			"Condition": {
				"StringEquals": {
					"aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true",
					"ec2:CreateAction": "CreateSecurityGroup"
				}
			}
		},
		{
			"Sid": "VisualEditor5",
			"Effect": "Allow",
			"Action": "ec2:CreateNetworkInterface",
			"Resource": "arn:aws:ec2:*:*:network-interface/*",
			"Condition": {
				"StringEquals": {
					"aws:RequestTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor6",
			"Effect": "Allow",
			"Action": "ec2:CreateNetworkInterface",
			"Resource": [
				"arn:aws:ec2:*:*:subnet/*",
				"arn:aws:ec2:*:*:security-group/*"
			],
			"Condition": {
				"StringEquals": {
					"aws:ResourceTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor7",
			"Effect": "Allow",
			"Action": "ec2:CreateTags",
			"Resource": "arn:aws:ec2:*:*:network-interface/*",
			"Condition": {
				"StringEquals": {
					"ec2:CreateAction": "CreateNetworkInterface"
				}
			}
		},
		{
			"Sid": "VisualEditor8",
			"Effect": "Allow",
			"Action": "ec2:ModifyNetworkInterfaceAttribute",
			"Resource": [
				"arn:aws:ec2:*:*:instance/*",
				"arn:aws:ec2:*:*:security-group/*",
				"arn:aws:ec2:*:*:network-interface/*"
			]
		},
		{
			"Sid": "VisualEditor9",
			"Effect": "Allow",
			"Action": [
				"iam:GetRole",
				"ec2:DescribeInstances",
				"s3:*",
				"ec2:DescribeTags",
				"elasticmapreduce:ListSteps",
				"sso:GetManagedApplicationInstance",
				"iam:ListRoles",
				"elasticmapreduce:DescribeCluster",
				"ec2:DescribeSecurityGroups",
				"elasticmapreduce:ListInstances",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribeVpcs",
				"sso-directory:SearchUsers",
				"iam:ListUsers",
				"iam:GetUser",
				"ec2:DescribeSubnets"
			],
			"Resource": "*"
		},
		{
			"Sid": "VisualEditor10",
			"Effect": "Allow",
			"Action": "secretsmanager:GetSecretValue",
			"Resource": "arn:aws:secretsmanager:*:*:secret:*",
			"Condition": {
				"StringEquals": {
					"aws:ResourceTag/for-use-with-amazon-emr-managed-policies": "true"
				}
			}
		},
		{
			"Sid": "VisualEditor11",
			"Effect": "Allow",
			"Action": "s3:*Object",
			"Resource": [
				"arn:aws:s3:::vtc-scripts-repo/emr/*"
			]
		},
{
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::vtc-scripts-repo"
            ]
        }
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy7" {
    name = "AWS-EMR-instancePolicy"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Resource": "*",
			"Action": [
				"cloudwatch:*",
				"redshift-serverless:GetCredentials",
				"Redshift:DescribeClusters",
				"Redshift:GetClusterCredentials",
				"dynamodb:*",
				"ec2:Describe*",
				"elasticmapreduce:Describe*",
				"elasticmapreduce:ListBootstrapActions",
				"elasticmapreduce:ListClusters",
				"elasticmapreduce:ListInstanceGroups",
				"elasticmapreduce:ListInstances",
				"elasticmapreduce:ListSteps",
				"kinesis:CreateStream",
				"kinesis:DeleteStream",
				"kinesis:DescribeStream",
				"kinesis:GetRecords",
				"kinesis:GetShardIterator",
				"kinesis:MergeShards",
				"kinesis:PutRecord",
				"kinesis:SplitShard",
				"rds:Describe*",
				"sdb:*",
				"sns:*",
				"sqs:*",
				"glue:CreateDatabase",
				"glue:UpdateDatabase",
				"glue:DeleteDatabase",
				"glue:GetDatabase",
				"glue:GetDatabases",
				"glue:CreateTable",
				"glue:UpdateTable",
				"glue:DeleteTable",
				"glue:GetTable",
				"glue:GetTables",
				"glue:GetTableVersions",
				"glue:CreatePartition",
				"glue:BatchCreatePartition",
				"glue:UpdatePartition",
				"glue:DeletePartition",
				"glue:BatchDeletePartition",
				"glue:GetPartition",
				"glue:GetPartitions",
				"glue:BatchGetPartition",
				"glue:CreateUserDefinedFunction",
				"glue:UpdateUserDefinedFunction",
				"glue:DeleteUserDefinedFunction",
				"glue:GetUserDefinedFunction",
				"glue:GetUserDefinedFunctions"
			]
		},
		{
			"Sid": "AllowAllActionsOnS3DatalakeBucket",
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::datalake-vtc",
				"arn:aws:s3:::datalake-vtc/*"
			],
			"Action": [
				"s3:*"
			]
		},
		{
			"Sid": "AllowAccessToBootStrapBucket",
			"Resource": [
				"arn:aws:s3:::vtc-scripts-repo",
				"arn:aws:s3:::vtc-scripts-repo/*"
			],
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket",
				"s3:GetObject"
			]
		},
		{
			"Sid": "AllowAccessTologs",
			"Resource": [
				"arn:aws:s3:::aws-logs-371858328372-eu-west-3",
				"arn:aws:s3:::aws-logs-371858328372-eu-west-3/*"
			],
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket",
				"s3:*Object"
			]
		},
		{
			"Sid": "SecretsManagerAccess",
			"Resource": [
				"arn:aws:secretsmanager:eu-west-3:371858328372:secret:dev/vtc/redshift-2mwo1P"
			],
			"Effect": "Allow",
			"Action": [
				"secretsmanager:ListSecrets",
				"secretsmanager:GetSecretValue"
			]
		}
	]
}
EOF
}

resource "aws_iam_policy" "IAMManagedPolicy8" {
    name = "AWS-EMR-ServicePolicy"
    path = "/"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AllowAccessToBootStrapBucket",
			"Resource": [
				"arn:aws:s3:::vtc-scripts-repo",
				"arn:aws:s3:::vtc-scripts-repo/*",
				"*"
			],
			"Effect": "Allow",
			"Action": [
				"s3:*",
				"s3:ListBucket",
				"s3:GetObject"
			]
		},
		{
			"Sid": "AllowAccessToLogs",
			"Resource": [
				"*"
			],
			"Effect": "Allow",
			"Action": [
				"s3:*"
			]
		},
		{
			"Sid": "CreateInTaggedNetwork",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterface",
				"ec2:RunInstances",
				"ec2:CreateFleet",
				"ec2:CreateLaunchTemplate",
				"ec2:CreateLaunchTemplateVersion"
			],
			"Resource": [
				"arn:aws:ec2:*:*:subnet/*",
				"arn:aws:ec2:*:*:security-group/*"
			]
		},
		{
			"Sid": "CreateWithEMRTaggedLaunchTemplate",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateFleet",
				"ec2:RunInstances",
				"ec2:CreateLaunchTemplateVersion"
			],
			"Resource": "arn:aws:ec2:*:*:launch-template/*"
		},
		{
			"Sid": "CreateEMRTaggedLaunchTemplate",
			"Effect": "Allow",
			"Action": "ec2:CreateLaunchTemplate",
			"Resource": "arn:aws:ec2:*:*:launch-template/*"
		},
		{
			"Sid": "CreateEMRTaggedInstancesAndVolumes",
			"Effect": "Allow",
			"Action": [
				"ec2:RunInstances",
				"ec2:CreateFleet"
			],
			"Resource": [
				"arn:aws:ec2:*:*:instance/*",
				"arn:aws:ec2:*:*:volume/*"
			]
		},
		{
			"Sid": "ResourcesToLaunchEC2",
			"Effect": "Allow",
			"Action": [
				"ec2:RunInstances",
				"ec2:CreateFleet",
				"ec2:CreateLaunchTemplate",
				"ec2:CreateLaunchTemplateVersion"
			],
			"Resource": [
				"arn:aws:ec2:*:*:network-interface/*",
				"arn:aws:ec2:*::image/ami-*",
				"arn:aws:ec2:*:*:key-pair/*",
				"arn:aws:ec2:*:*:capacity-reservation/*",
				"arn:aws:ec2:*:*:placement-group/EMR_*",
				"arn:aws:ec2:*:*:fleet/*",
				"arn:aws:ec2:*:*:dedicated-host/*",
				"arn:aws:resource-groups:*:*:group/*"
			]
		},
		{
			"Sid": "ManageEMRTaggedResources",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateLaunchTemplateVersion",
				"ec2:DeleteLaunchTemplate",
				"ec2:DeleteNetworkInterface",
				"ec2:ModifyInstanceAttribute",
				"ec2:TerminateInstances"
			],
			"Resource": "*"
		},
		{
			"Sid": "ManageTagsOnEMRTaggedResources",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags",
				"ec2:DeleteTags"
			],
			"Resource": [
				"arn:aws:ec2:*:*:instance/*",
				"arn:aws:ec2:*:*:volume/*",
				"arn:aws:ec2:*:*:network-interface/*",
				"arn:aws:ec2:*:*:launch-template/*"
			]
		},
		{
			"Sid": "CreateNetworkInterfaceNeededForPrivateSubnet",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterface"
			],
			"Resource": [
				"arn:aws:ec2:*:*:network-interface/*"
			]
		},
		{
			"Sid": "TagOnCreateTaggedEMRResources",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags"
			],
			"Resource": [
				"arn:aws:ec2:*:*:network-interface/*",
				"arn:aws:ec2:*:*:instance/*",
				"arn:aws:ec2:*:*:volume/*",
				"arn:aws:ec2:*:*:launch-template/*"
			]
		},
		{
			"Sid": "TagPlacementGroups",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags",
				"ec2:DeleteTags"
			],
			"Resource": [
				"arn:aws:ec2:*:*:placement-group/EMR_*"
			]
		},
		{
			"Sid": "ListActionsForEC2Resources",
			"Effect": "Allow",
			"Action": [
				"ec2:DescribeAccountAttributes",
				"ec2:DescribeCapacityReservations",
				"ec2:DescribeDhcpOptions",
				"ec2:DescribeImages",
				"ec2:DescribeInstances",
				"ec2:DescribeLaunchTemplates",
				"ec2:DescribeNetworkAcls",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribePlacementGroups",
				"ec2:DescribeRouteTables",
				"ec2:DescribeSecurityGroups",
				"ec2:DescribeSubnets",
				"ec2:DescribeVolumes",
				"ec2:DescribeVolumeStatus",
				"ec2:DescribeVpcAttribute",
				"ec2:DescribeVpcEndpoints",
				"ec2:DescribeVpcs"
			],
			"Resource": "*"
		},
		{
			"Sid": "CreateDefaultSecurityGroupWithEMRTags",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateSecurityGroup"
			],
			"Resource": [
				"arn:aws:ec2:*:*:security-group/*"
			]
		},
		{
			"Sid": "CreateDefaultSecurityGroupInVPCWithEMRTags",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateSecurityGroup"
			],
			"Resource": [
				"arn:aws:ec2:*:*:vpc/*"
			]
		},
		{
			"Sid": "TagOnCreateDefaultSecurityGroupWithEMRTags",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateTags"
			],
			"Resource": "arn:aws:ec2:*:*:security-group/*"
		},
		{
			"Sid": "ManageSecurityGroups",
			"Effect": "Allow",
			"Action": [
				"ec2:AuthorizeSecurityGroupEgress",
				"ec2:AuthorizeSecurityGroupIngress",
				"ec2:RevokeSecurityGroupEgress",
				"ec2:RevokeSecurityGroupIngress"
			],
			"Resource": "*"
		},
		{
			"Sid": "CreateEMRPlacementGroups",
			"Effect": "Allow",
			"Action": [
				"ec2:CreatePlacementGroup"
			],
			"Resource": "arn:aws:ec2:*:*:placement-group/EMR_*"
		},
		{
			"Sid": "DeletePlacementGroups",
			"Effect": "Allow",
			"Action": [
				"ec2:DeletePlacementGroup"
			],
			"Resource": "*"
		},
		{
			"Sid": "AutoScaling",
			"Effect": "Allow",
			"Action": [
				"application-autoscaling:DeleteScalingPolicy",
				"application-autoscaling:DeregisterScalableTarget",
				"application-autoscaling:DescribeScalableTargets",
				"application-autoscaling:DescribeScalingPolicies",
				"application-autoscaling:PutScalingPolicy",
				"application-autoscaling:RegisterScalableTarget"
			],
			"Resource": "*"
		},
		{
			"Sid": "ResourceGroupsForCapacityReservations",
			"Effect": "Allow",
			"Action": [
				"resource-groups:ListGroupResources"
			],
			"Resource": "*"
		},
		{
			"Sid": "AutoScalingCloudWatch",
			"Effect": "Allow",
			"Action": [
				"cloudwatch:PutMetricAlarm",
				"cloudwatch:DeleteAlarms",
				"cloudwatch:DescribeAlarms"
			],
			"Resource": "arn:aws:cloudwatch:*:*:alarm:*_EMR_Auto_Scaling"
		},
		{
			"Sid": "PassRoleForAutoScaling",
			"Effect": "Allow",
			"Action": "iam:PassRole",
			"Resource": "arn:aws:iam::*:role/EMR_AutoScaling_DefaultRole"
		},
		{
			"Sid": "PassRoleForEC2",
			"Effect": "Allow",
			"Action": "iam:PassRole",
			"Resource": [
				"arn:aws:iam::*:role/EMR_EC2_DefaultRole",
				"arn:aws:iam::371858328372:role/AWS-EMR-InstanceRole"
			],
			"Condition": {
				"StringLike": {
					"iam:PassedToService": "ec2.amazonaws.com*"
				}
			}
		}
	]
}
EOF
}

resource "aws_iam_role" "IAMRole" {
    path = "/"
    name = "AWS-EMR-ServiceRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"elasticmapreduce.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole2" {
    path = "/"
    name = "AWS-EMR-InstanceRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole3" {
    path = "/"
    name = "AWS-EMR-StudioRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"elasticmapreduce.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole4" {
    path = "/"
    name = "AWS-KakfaConfluent-EC2-InstanceRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole5" {
    path = "/"
    name = "AWS-Redshift-ClusterRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"redshift.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole6" {
    path = "/"
    name = "AWS-EC2-AIRFLOW-INSTANCEROLE"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole7" {
    path = "/"
    name = "Fivetran-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::834469178297:root\"},\"Action\":\"sts:AssumeRole\",\"Condition\":{\"StringEquals\":{\"sts:ExternalId\":\"irrigation_plurality\"}}}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role" "IAMRole8" {
    path = "/"
    name = "HAVA-ExternalAccountRole"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::281013829959:root\"},\"Action\":\"sts:AssumeRole\",\"Condition\":{\"StringEquals\":{\"sts:ExternalId\":\"5438e5752b7849b6dd97fcaf752d3a54\"}}}]}"
    max_session_duration = 3600
    tags = {}
}

resource "aws_iam_role_policy" "IAMPolicy" {
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetBucketAcl",
                "s3:GetBucketCors",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject",
                "s3:PutBucketAcl",
                "s3:PutBucketCors",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::datalake-vtc/*",
                "arn:aws:s3:::datalake-vtc"
            ]
        }
    ]
}
EOF
    role = "${aws_iam_role.IAMRole5.name}"
}
