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
  default     = "devrp"
  type        = string
  description = "Deployment Environment"
}


variable "my_public_ip" {
  default     = "34.207.214.157"
  type        = string
  description = "admin public id"
}


variable "my_private_ip" {
  default     = "172.31.33.177"
  type        = string
  description = "admin private id"
}


variable "service_ports" {
  type        = list(string)
  default     = ["80", "22"]
  description = "Ports that should be open on a webserver"
}

variable "instance_count" {
  default     = "2"
  type        = string
  description = "Number of instance"
}