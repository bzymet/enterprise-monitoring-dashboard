variable "directory_id" {
  description = "ID of the registered AWS Directory Service directory"
  type        = string
}

variable "bundle_id" {
  description = "ID of the Amazon WorkSpaces bundle"
  type        = string
}

variable "user_name" {
  description = "Directory user assigned to the WorkSpace"
  type        = string
}

variable "running_mode" {
  description = "WorkSpace running mode"
  type        = string
  default     = "AUTO_STOP"

  validation {
    condition     = contains(["AUTO_STOP", "ALWAYS_ON"], var.running_mode)
    error_message = "running_mode must be AUTO_STOP or ALWAYS_ON."
  }
}

variable "auto_stop_timeout_minutes" {
  description = "Minutes of inactivity before an AutoStop WorkSpace stops"
  type        = number
  default     = 60
}

variable "root_volume_encryption_enabled" {
  description = "Enable encryption for the WorkSpace root volume"
  type        = bool
  default     = false
}

variable "user_volume_encryption_enabled" {
  description = "Enable encryption for the WorkSpace user volume"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the WorkSpace"
  type        = map(string)
  default     = {}
}
