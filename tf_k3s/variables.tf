variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
  type        = string
}
variable "user_ocid" {
  description = "The OCID of the user."
  type        = string
}
variable "fingerprint" {
  description = "The fingerprint of the API key."
  type        = string
}
variable "private_key_path" {
  description = "The path to the private key file."
  type        = string
}
variable "region" {
  description = "The region to use for the OCI provider."
  type        = string
}
variable "availability_zone" {
  description = "The availability zone to use for the OCI resources."
  type        = string
}
variable "my_ip_address" {
  description = "The IP address of the local machine."
  type        = string
}
