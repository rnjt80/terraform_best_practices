variable "environment_name" {
    type        = string
    description = "Name of the environment (e.g., dev, prod)"
}

variable "instance_count" {
    type        = number
    default     = 1
    description = "Number of EC2 instances to create"
}

variable "ami" {
    type        = string
    description = "AMI ID for the EC2 instances"
}

variable "instance_type" {
    type        = string
    default     = "t2.micro"
    description = "Instance type for the EC2 instances"
}

variable "subnet_id" {
    type        = string
    description = "ID of the subnet to launch the EC2 instances in"
}

variable "security_group_ids" {
    type        = list(string)
    description = "List of Security Group IDs to associate with the instances"
}

variable "key_name" {
    type        = string
    description = "Name of the EC2 Key Pair for SSH access"
}

variable "associate_public_ip" {
    type        = bool
    default     = false
    description = "Associate a public IP address with the EC2 instances"
}

variable "user_data" {
    type        = string
    default     = ""
    description = "User data script to run on instance startup"
}

variable "root_block_device" {
    type = object({
        delete_on_termination = optional(bool)
        volume_size           = optional(number)
        volume_type           = optional(string)
        encrypted             = optional(bool)
        kms_key_id            = optional(string)
    })
    default     = {}
    description = "Configuration for the root block device"
}

variable "ebs_block_devices" {
    type = list(object({
        device_name           = string
        volume_size           = number
        volume_type           = optional(string)
        delete_on_termination = optional(bool)
        encrypted             = optional(bool)
        kms_key_id            = optional(string)
    }))
    default     = []
    description = "List of additional EBS block devices to attach"
}