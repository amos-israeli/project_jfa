variable "state" {
  description = "vars for controling the state of the ec2 instances"
  type        = map
  default = {
    web01 = "running"
    web02 = "running"
    web03 = "running"
    db01  = "running"
    control = "running"

  }

}

variable "all_state" {
  description = "controling the state of all the ec2 instances in one var"
  type        = string
  default     = "stopped"

}