//********************** Basic Configuration Variables **************************//

 variable "location" {
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

variable "management_gui_client_network" {
  type = string
}

variable "bootstrap_script"{
  description = "An optional script to run on the initial boot"
  #example:
  #"touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
}

//********************** Virtual Machine Instances Variables **************************//

variable "is_blink" {
  description = "Define if blink image is used for deployment"
  default = true
}

variable "installation_type"{
  description = "Installation type"
  type = string
  default = "cluster"
}

variable "template_version"{
  description = "Template version. It is reccomended to always use the latest template version"
  type = string
  default = "20201109"
}

variable "template_name"{
  description = "Template name. Should be defined according to deployment type(ha, vmss, management)"
  type = string
  default = "management"
}

variable "admin_username" {
  description = "Administrator username of deployed VM. Due to Azure limitations 'notused' name can be used"
  default     = "notused"
}

variable "admin_password" {
  type = string
}

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  type = bool
}

//********************** Credentials **************************//

 variable "subscription_id" {
  description = "Subscription ID"
  type = string
 }