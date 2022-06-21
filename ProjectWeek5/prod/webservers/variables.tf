# Instance type
variable "instance_type" {
  default = {
    "prodrp"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t2.micro"
    "devrp"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Variable to signal the current environment 
variable "env" {
  default     = "prodrp"
  type        = string
  description = "Deployment Environment"
}

variable "service_ports" {
  type        = list(string)
  default     = ["22"]
  description = "Ports that should be open on a webserver"
}

variable "instance_count" {
  default     = "2"
  type        = string
  description = "Number of instance"
}