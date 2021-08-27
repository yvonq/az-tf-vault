#
# Top Module


#
###
variable "prefix" {
  default = "yqs-hcvault-demo"
}
variable "resource_group_name" {
  default = "yqs-rg"
}
variable "resource_group_location" {
  default = "francecentral"
}

variable "subnet_id" {
  default = "yqs-jenkins-vmSubnet"
}