variable "iso_url" {
  default = "http://mirror.centos.org/centos/7/os/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
}

variable "iso_checksum" {
  default = "sha256:0d9dc37b5dd4befa1c440d2172e38fb5"
}

source "virtualbox-iso" "centos" {
  iso_url            = var.iso_url
  iso_checksum       = var.iso_checksum
  iso_checksum_type  = "sha256"

  guest_os_type      = "RedHat_64"
  ssh_username       = "packer"
  ssh_password       = "packer"
  ssh_wait_timeout   = "20m"

  vm_name            = "centos-7"
  disk_size          = 20000
  http_directory     = "http"

  boot_command       = [
    "<esc><wait>",
    "linux ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]
}

build {
  sources = ["source.virtualbox-iso.centos"]

  provisioner "file" {
    source      = "scripts/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "file" {
    source      = "patches/my-patch.patch"
    destination = "/tmp/my-patch.patch"
  }

  provisioner "file" {
    source      = "packages/package-list.txt"
    destination = "/tmp/package-list.txt"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/provision.sh",
      "sudo /tmp/provision.sh"
    ]
  }

  post-processor "vagrant" {
    output = "output/centos-7.box"
  }
}
