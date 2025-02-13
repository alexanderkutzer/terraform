variable "resource_group_name"{
    type = string 
    default = "rg-24-04-on-kutzer-alexander"
}

variable "subscription_id"{
    type = string
    sensitive = true
}


variable "location"{
    type = string
    default = "Germany West Central"
}

variable "enable_error_page"{
    type = bool
    default = false
}