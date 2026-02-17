resource "aws_iam_role" "ec2" {
    name = "ec2_watchman_role"

    assume_role_policy = jsonencode({
        Version: "2012-10-17",
        Statement: [
            {
                Sid: "ForEC2",
                Effect: "Allow",
                Action: ["sts:AssumeRole"]

                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]


    })
}

resource "aws_iam_role_policy" "ec2_policy" {
    name = "ec2_watchman_role_policy"
    role = aws_iam_role.ec2.id

    policy = jsonencode({
        Version: "2012-10-17"
        Statement: [
            {
                Sid: "checkS3"
                Effect: "Allow"
                Action: [
                    "s3:ListAllMyBuckets"
                ]
                Resource: "*"
                
                
            }
        ]
    })
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2_watchman_profile"
    role = aws_iam_role.ec2.name
}