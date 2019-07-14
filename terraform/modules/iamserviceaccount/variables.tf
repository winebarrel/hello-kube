variable "openid_connect_provider" {
  type = object({
    arn = string
    url = string
  })
}

variable "serviceaccount" {
  type = object({
    namespace = string
    name      = string
  })
}
