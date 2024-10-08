variable "owner" {
  type = list(string)
}

variable "image_name" {
  type = list(string)
}

variable "tags_ami_lookup" {
  type = map(string)
}

variable "tags_network_interface" {
  type = map(string)
}

variable "tags_ec2" {
  type = map(string)
}

variable "instance_size" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_pair_id" {
  type = string
}