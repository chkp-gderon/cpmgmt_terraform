//********************** Basic Configuration Variables **************************//

 variable "az_location" {
  description = "The location/region where rescources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type = string
 }

variable "rg_name" {
    type = string  
}

//********************** Networking Variables **************************//
variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = list(string)
}

variable "subnet_mgmt_name" {
  type = string
}

variable "subnet_mgmt_cidr" {
  type = list(string)
}

variable "os_version" {
  description = "GAIA OS version"
  type = string
}

variable "log_server_name" {
  type = string
}

variable "admin_username" {
  description = "Administrator username of deployed VM. Due to Azure limitations 'notused' name can be used"
  default     = "notused"
}

variable "admin_password" {
  type = string
}

#variable "custom_data" {
#  type = string
#}

#"imagePublisher": "checkpoint",
#        "imageReferenceBYOL": {
#            "offer": "[variables('imageOffer')]",
#            "publisher": "[variables('imagePublisher')]",
#            "sku": "mgmt-byol",
#            "version": "latest"
#        },

variable "cloud_config_string" {
  type = string
}

//********************** Credentials **************************//

 variable "subscription_id" {
  description = "Subscription ID"
  type = string
 }