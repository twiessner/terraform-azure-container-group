
variable "name" {
  type        = string
  description = "Specifies the name of this group."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to this group."
  default     = {}
}

variable "os_type" {
  type        = string
  description = "The underlying OS for this group."
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "Allowed values are 'Linux' and 'Windows'."
  }
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where this group exists."
}

variable "restart_policy" {
  type        = string
  description = "Restart policy for this group."
  default     = "OnFailure"

  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "Allowed values are 'Always', 'Never' and 'OnFailure'."
  }
}

variable "subnet_ids" {
  type        = set(string)
  description = "The subnet resource IDs for this group for private connectivity."
  default     = []
}

variable "dns_name_label" {
  type        = string
  description = "The DNS label/name for this group's IP address."
  default     = null
}

variable "availability_zones" {
  type        = set(string)
  description = ""
  default     = []
}

variable "image_registry_credentials" {
  type = map(object({
    username = string
    password = string
    server   = string
  }))
  description = ""
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create this group."
}

variable "containers" {
  type = map(object({
    image        = string
    cpu          = string
    cpu_limit    = optional(string)
    memory       = string
    memory_limit = optional(string)
    ports        = map(string)
    env          = optional(map(string))
  }))
  description = "The definition of all containers that are part of this group."
}