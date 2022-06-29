resource "aws_iam_role" "jenkins" {
    name = "jenkins-iam-role"
    description = "IAM Role for Jenkins"
    path = "/hillel/"
    assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json
}

resource "aws_iam_role" "jenkins_ecr" {
    name = "jenkins-ecr-iam-role"
    description = "IAM Role for full access to ECR"
    path = "/hillel/"
    assume_role_policy = data.aws_iam_policy_document.jenkins_ecr_assume_role.json
}

data "aws_iam_policy_document" "jenkins_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "jenkins_ecr_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type        = "AWS"
            identifiers = [aws_iam_role.jenkins.arn]
        }
    }
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
    role = aws_iam_role.jenkins_ecr.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins" {
    role = aws_iam_role.jenkins.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

output "jenkins_ecr_role_arn" {
    value = aws_iam_role.jenkins_ecr.arn
    sensitive = false
}

resource "aws_iam_instance_profile" "jenkins" {
    name = "jenkins-instance-profile"
    role = aws_iam_role.jenkins.name
}