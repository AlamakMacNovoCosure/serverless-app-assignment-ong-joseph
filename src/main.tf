provider "aws" {
  region = "ap-southeast-1"
}

module "serverless-app" {
  source = "./modules/serverless-app"
}