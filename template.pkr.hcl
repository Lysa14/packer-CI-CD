variable "iso_url" {
  default = "http://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso"
}

variable "iso_checksum" {
  default = "sha256:93bdab204067321ff131f560879db46bee3b994bf24836bb78538640f689e58f"
}

source "virtualbox-iso" "ubuntu" {
  iso_url            = var.iso_url
  iso_checksum       = var.iso_checksum
  iso_checksum_type  = "sha256"

  guest_os_type      = "Ubuntu_64"
  ssh_username       = "packer"
  ssh_password       = "packer"
  ssh_wait_timeout   = "20m"

  vm_name            = "ubuntu-20.04"
  disk_size          = 20000
  http_directory     = "http"

  boot_command       = [
    "<esc><wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ <enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "file" {
    source      = "scripts/apply_patch.sh",
    destination = "/tmp/apply_patch.sh"
  }

  provisioner "file" {
    source      = "patches/my-patch.patch",
    destination = "/tmp/my-patch.patch"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/apply_patch.sh",
      "sudo /tmp/apply_patch.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "echo '<h1>Hello, World!</h1>' | sudo tee /var/www/html/index.html"
    ]
  }

  post-processor "vagrant" {
    output = "output/ubuntu-20.04.box"
  }
}
