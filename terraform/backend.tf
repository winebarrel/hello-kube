terraform {
  backend "s3" {
    bucket = "sugawara-test"
    key    = "tfstate"
    region = "ap-northeast-1"
  }
}
