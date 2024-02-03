data "aws_iam_policy_document" "queue-demo" {
  statement {
    effect = "Allow"

    principals {
      type = "*"
      identifiers = [ "*" ]
    }

    actions = [ "SendMessage" ]
    resources = [ "arn:aws:sqs:*:*:s3-event-notification-queue" ]

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = [ aws_s3_bucket.aws_s3_bucket.arn ]
    }
  }
}

resource "aws_sqs_queue" "queue-demo" {
  name = "s3-event-notification-queue"
  policy = data.aws_iam_policy_document.queue-demo.json
}

resource "aws_s3_bucket" "queue-bucket" {
  bucket = "joseph-bucket-s3-sqs"
}

resource "aws_s3_bucket_notification" "queue_bucket_notification" {
  bucket = aws_s3_bucket.queue-bucket.id

  queue {
    id = "create-object-event"
    queue_arn = aws_sqs_queue.queue-demo.arn
    events = [ "s3:ObjectCreated:*" ]
    # filter_prefix = ".log"
  }

#   queue {
#     id = "del-object-event"
#     queue_arn = aws_sqs_queue.queue-demo.arn
#     events = [ "s3:ObjectRemoved:*" ]
#   }

#   queue {
#     id = "iamge-upload-event"
#     queue_arn = aws_sqs_queue.queue-demo.arn
#     events = [ "s3:ObjectCreated:*" ]
#     filter_prefix = "images/"
#   }

#   queue {
#     id = "video-upload-event"
#     queue_arn = aws_sqs_queue.queue-demo.arn
#     events = [ "s3:ObjectCreated:*" ]
#     filter_prefix = "videos/"
#   }
}