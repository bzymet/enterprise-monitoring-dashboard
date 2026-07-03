variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = map(object({
    description                  = string
    ip_protocol                  = string
    from_port                    = number
    to_port                      = number
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {}
}

variable "egress_rules" {
  description = "Egress rules for the security group"
  type = map(object({
    description                  = string
    ip_protocol                  = string
    from_port                    = number
    to_port                      = number
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to the security group and its rules"
  type        = map(string)
  default     = {}
}