resource "aws_instance" "server" {
    count                  = var.instance_count
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = var.subnet_id
    vpc_security_group_ids = var.security_group_ids
    key_name               = var.key_name
    associate_public_ip    = var.associate_public_ip
    user_data              = var.user_data

    root_block_device {
        delete_on_termination = lookup(var.root_block_device, "delete_on_termination", true)
        volume_size           = lookup(var.root_block_device, "volume_size", 8)
        volume_type           = lookup(var.root_block_device, "volume_type", "gp2")
        encrypted             = lookup(var.root_block_device, "encrypted", false)
        kms_key_id            = lookup(var.root_block_device, "kms_key_id", "")
    }

    dynamic "ebs_block_device" {
        for_each = var.ebs_block_devices
        content {
        device_name           = ebs_block_device.value.device_name
        volume_size           = ebs_block_device.value.volume_size
        volume_type           = lookup(ebs_block_device.value, "volume_type", "gp2")
        delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
        encrypted             = lookup(ebs_block_device.value, "encrypted", false)
        kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", "")
        }
    }

    tags = {
        Name = "${var.environment_name}-instance-${count.index + 1}"
    }
}
