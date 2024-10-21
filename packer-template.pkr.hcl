packer {
  required_plugins {
    outscale = {
      version = ">= 1.8.3"
      source = "github.com/outscale/outscale"
    }
  }
}


source "outscale-bsu" "github-actions" {
  access_key = var.OUTSCALE_ACCESS_KEY
  secret_key = var.OUTSCALE_SECRET_KEY
  region = var.OUTSCALE_REGION
  source_omi = var.image-id
  vm_type = "t2.micro"
  ssh_username = "outscale"
  omi_name = "packer-quick-start {{timestamp}}"
  tags = {
    OS_Version = var.os_version
    Release = var.release
    Base_OMI_Name = "{{ .SourceOMIName }}"
    Extra = "{{ .SourceOMITags.TagName }}"
  }
  
}

build {
  sources = ["source.outscale-bsu.github-actions"] 

provisioner "file" {
  source      = "packer-scripts/script.sh"
  destination = "/tmp/script.sh"
}
provisioner "file" {
  source      = "packer-scripts/setup_boot.service"
  destination = "/tmp/setup_boot.service"
}

provisioner "shell" {
inline = [
"sudo mv /tmp/script.sh /opt/bootscript.sh",
"sudo mv /tmp/setup_boot.service /usr/lib/systemd/system/setup_boot.service",
"sudo systemctl enable setup_boot.service"
]
}










}

  
