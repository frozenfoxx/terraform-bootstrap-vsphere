resource "vsphere_virtual_machine" "main" {
  name             = "${var.name}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.folder}"

  num_cpus         = 2
  memory           = 4096
  guest_id         = "ubuntu64Guest"

  network_interface {
    network_id   = "${data.vsphere_network.management.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.name}"
        domain    = "${var.management_domain}"
      }

      network_interface {
        ipv4_address = "${var.management_ipv4_address}"
        ipv4_netmask = "${var.management_ipv4_prefix_length}"
      }

      timeout         = "${var.timeout}"
      ipv4_gateway    = "${var.management_gateway}"
      dns_suffix_list = ["${var.management_domain}"]
      dns_server_list = var.management_dns_servers
    }
  }
 
  connection {
    type        = "ssh"
    host        = "${var.management_ipv4_address}"
    user        = "ubuntu"
    private_key = chomp(file("${path.module}/files/ubuntu.key"))
  }

  provisioner "file" {
    source      = "${path.module}/scripts/"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "${path.module}/files"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /data",
      "sudo cp -r /tmp/files/* /data/",
      "sudo rm -r /tmp/files",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 /tmp/*.sh",
      "sudo /tmp/openvmtools_install.sh",
      "sudo /tmp/nginx_install.sh --dataroot ${var.dataroot}",
      "sudo /tmp/inject_alias.sh",
      "sudo /tmp/dnsmasq_install.sh --dataroot ${var.dataroot} --dhcpstart ${var.dhcpstart} --dhcpstop ${var.dhcpstop} --domain ${var.management_domain} --hostip ${var.management_ipv4_address} --gateway ${var.management_gateway}",
      "sudo /tmp/create_user.sh --username '${var.username}' --password '${var.password}' --authkeys '${var.authkeys}'",
      "sudo /tmp/pxe_install.sh --dataroot ${var.dataroot}",
      "sudo /tmp/nfs_install.sh --dataroot ${var.dataroot}",
      "sudo rm /tmp/*.sh",
      "sudo userdel -fr ubuntu"
    ]
  }
}
