# -----------------------------------------------------------
# set up SNS for sending alerts out. note there is only rudimentary security on this
# -----------------------------------------------------------
resource "aws_sns_topic" "security_alerts" {
  name         = "security-alerts-topic"
  display_name = "Security Alerts"
}

resource "aws_sns_topic_subscription" "security_alerts_to_sqs" {
  topic_arn = "${aws_sns_topic.security_alerts.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.security_alerts.arn}"
}

resource "aws_sqs_queue" "security_alerts" {
  name = "security-alerts-${var.aws_region}"
  tags = "${merge(map("Name","Security Alerts"), var.tags)}"
}

resource "aws_sns_topic_policy" "default" {
  arn = "someTopic"

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:us-west-2:054106316361:someTopic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "054106316361"
        }
      }
    },
    {
      "Sid": "__console_pub_0",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-west-2:054106316361:someTopic"
    },
    {
      "Sid": "__console_sub_0",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:us-west-2:054106316361:someTopic"
    }
  ]
}
EOF
}

