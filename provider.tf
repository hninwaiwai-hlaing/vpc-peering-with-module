provider "aws" {
  alias   = "tokyo"
  region  = "ap-northeast-1"
  profile = "aws-master-admin"
}

provider "aws" {
  alias   = "osaka"
  region  = "ap-northeast-3"
  profile = "aws-master-admin"
}

provider "aws" {
  alias   = "singapore"
  region  = "ap-southeast-1"
  profile = "aws-master-admin"
}