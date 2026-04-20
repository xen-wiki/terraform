variable "region" {
  description = "Linode region for all resources"
  type        = string
  default     = "us-east"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+$", var.region))
    error_message = "Region must be in the format 'us-east', 'eu-west', etc."
  }
}

variable "linode_token" {
  description = "Linode API token (stored in Terraform Cloud as sensitive variable)"
  type        = string
  sensitive   = true
}

variable "github_ansible_token" {
  description = "GitHub personal access token with repo and admin:repo_hook permissions"
  type        = string
  sensitive   = true
}

variable "github_ansible_repository" {
  description = "GitHub repository name without owner (e.g., 'ansible')"
  type        = string
  default     = "ansible"
}

variable "terraform_ssh_key" {
  description = "SSH private key for Terraform provisioners (stored in Terraform Cloud as sensitive variable)"
  type        = string
  sensitive   = true
}

variable "ssh_port" {
  description = "SSH port for provisioned instances"
  type        = string
  sensitive   = true

  validation {
    condition     = tonumber(var.ssh_port) > 0 && tonumber(var.ssh_port) <= 65535
    error_message = "SSH port must be a valid port number (1-65535)."
  }
}

variable "ssh_user" {
  description = "SSH user for provisioned instances"
  type        = string
  sensitive   = true
}

variable "application_type" {
  description = "Linode instance type for application server"
  type        = string

  validation {
    condition     = can(regex("^g6-", var.application_type))
    error_message = "Application type must be a Linode type starting with 'g6-' (e.g., g6-standard-1)."
  }
}

variable "application_image" {
  description = "OS image for application server"
  type        = string
}

variable "application_label" {
  description = "Label for application instance"
  type        = string
}

variable "database_type" {
  description = "Linode instance type for database"
  type        = string
}

variable "database_engine" {
  description = "Database engine ID"
  type        = string

  validation {
    condition     = contains(["mysql", "postgresql"], var.database_engine)
    error_message = "Database engine must be 'mysql' or 'postgresql'."
  }
}

variable "database_cluster_size" {
  description = "Number of nodes in database cluster"
  type        = number
  
  # High availability clusters typically require an odd number of nodes for consensus (e.g. Raft/Paxos).
  validation {
    condition     = var.database_cluster_size > 0 && var.database_cluster_size % 2 != 0
    error_message = "Database cluster size must be greater than 0 and an odd number."
  }
}

variable "database_label" {
  description = "Label for database instance"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  sensitive   = true
}

variable "allowed_ssh_cidrs_ipv6" {
  description = "IPv6 CIDR blocks allowed to SSH"
  type        = list(string)
  sensitive   = true
}
