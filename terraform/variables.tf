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
variable "jenkins_subnet_address_prefix" {
	default = "10.0.1.0/24"
}
variable "vault_subnet_address_prefix" {
	default = "10.0.2.0/24"
}
variable "private_dns_zone" {}