data "http" "githubsshKeys" {
  url = "https://github.com/declan-morris.keys"
}

resource "proxmox_lxc" "soleria" {
  target_node  = "asimov"
  hostname     = "soleria"
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  unprivileged = true
  onboot       = true

  ssh_public_keys = data.http.githubsshKeys.body
  memory          = 4 * 1024

  features {
    nesting = true
    mount   = "nfs;cifs;ext4"
  }

  rootfs {
    storage = "local-lvm"
    size    = "60G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${cidrhost(var.localSubnet, 200)}/24"
    gw     = cidrhost(var.localSubnet, 1)
    ip6    = "auto"
  }

  mountpoint { # directory mount the storage data
    key     = "1"
    slot    = 1
    storage = "/storage/data"
    volume  = "/storage/data"
    mp      = "/storage/data"
    size    = "0G"
  }

  lifecycle {
    ignore_changes = [
      ssh_public_keys,
      mountpoint
    ]
  }
}


resource "proxmox_lxc" "aurora" {
  target_node  = "asimov"
  hostname     = "aurora"
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  unprivileged = true
  onboot       = true

  ssh_public_keys = data.http.githubsshKeys.body
  memory          = 4 * 1024

  features {
    nesting = true
    mount   = "nfs;cifs"
  }

  rootfs {
    storage = "local-lvm"
    size    = "30G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${cidrhost(var.localSubnet, 201)}/24"
    gw     = cidrhost(var.localSubnet, 1)
    ip6    = "auto"
  }

  lifecycle {
    ignore_changes = [
      ssh_public_keys,
    ]
  }
}
