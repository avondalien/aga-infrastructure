variable "accounts" {
  type = map(object({
    name = string
    id   = string
  }))
  description = "Map of child accounts from stage 1"
}

variable "region" {
    type = string
    default = "us-east-2"
}

variable "github" {
  type = object({
    org = string
    repo = string
    branch = string
  })
}