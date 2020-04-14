# terraform-bootstrap-vsphere

This module creates a bootstrapping server on vSphere to assist creating machines.

# Requirements

This module requires a template host VM to clone from. This machine will be expected to provide certain aspects listed down here.

## Distribution

* Ubuntu 18.04

## Filesystem

* `/etc/sudoers` contains `%sudo ALL=(ALL:ALL) NOPASSWD:ALL`.
* Steps listed [here](https://kb.vmware.com/s/article/54986) to disable `cloud-init`:
  * `sudo touch /etc/cloud/cloud-init.disabled`
  * `sudo apt-get purge cloud-init`
  * Comment `/usr/lib/tmpfiles.d/tmp.conf` line setting `/tmp` permissions:
    * `#/tmp 1777 root root -`
  * Update the `/lib/systemd/system/open-vm-tools.service` _after_ `open-vm-tools` is installed:
    * Add `"After=dbus.service"` under `[Unit]`

## Packages

* `open-vm-tools`
* `perl`

## Users

* `ubuntu`
  * `/home/ubuntu/.ssh/authorized_keys` set with the SSH public key provided in `files`, `ubuntu.pub`.
  * Member of the `sudo` group.
  * **NOTE**: this user will be destroyed at the end of deployment.

# Usage

To use this module, in your `main.tf` TerraForm code for a deployment insert the following:

```
module "bootstrap-1" {
  source = "github.com/frozenfoxx/terraform-bootstrap-vsphere"

  authkeys                      = var.authkeys
  cluster                       = var.cluster
  datacenter                    = var.datacenter
  dataroot                      = "[Path for TFTP data root]"
  datastore                     = var.datastore
  dhcpstart                     = "[DHCP range Start IP]"
  dhcpstop                      = "[DHCP range Stop IP]"
  folder                        = var.folder
  management_dns_servers        = var.management_dns_servers
  management_domain             = var.management_domain
  management_gateway            = var.management_gateway
  management_ipv4_address       = "[Management Network IP]"
  management_ipv4_prefix_length = "[Management Subnet Mask]"
  management_netlabel           = var.management_netlabel
  name                          = "[Hostname]"
  password                      = var.password
  template                      = var.template
  username                      = var.username
  vmtimez                       = var.vmtimez
}
```

## Notes

The `username`, `password`, and `authkeys` fields are to deploy a persistent, administrative user after deployment. This is to maintain access given the `ubuntu` user will be destroyed as part of deployment.
