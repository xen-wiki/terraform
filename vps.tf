resource "linode_instance" "application_1125" {
  label  = var.application_label
  region = var.region
  type   = var.application_type
  image  = var.application_image

  authorized_keys = [
    data.linode_sshkey.terraform.ssh_key,
    data.linode_sshkey.turtle.ssh_key
  ]

  lifecycle {
    prevent_destroy = true
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.terraform_ssh_key
    host        = self.ip_address
  }

  provisioner "file" {
    source      = "${path.module}/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh ${var.ssh_port}"
    ]
  }
}
