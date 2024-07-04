packer {
  required_plugins {
    outscale = {
      version = ">= 1.2.0"
      source = "github.com/outscale/outscale"
    }
  }
}

variable "OUTSCALE_ACCESS_KEY" {
  type = string
  default = ""
}

variable "OUTSCALE_SECRET_KEY" {
  type = string
  default = ""
}

variable "OUTSCALE_REGION" {
  type = string
  default = ""
}
source "outscale-bsu" "github-actions" {
  access_key = var.OUTSCALE_ACCESS_KEY
  secret_key = var.OUTSCALE_SECRET_KEY
  region = var.OUTSCALE_REGION
  source_omi = "ami-321efe20"
  vm_type = "t2.micro"
  ssh_username = "outscale"
  omi_name = "packer-quick-start {{timestamp}}"
  tags = {
    OS_Version = "Debian"
    Release = "Latest"
    Base_OMI_Name = "{{ .SourceOMIName }}"
    Extra = "{{ .SourceOMITags.TagName }}"
  }
  
}

build {
  sources = ["source.outscale-bsu.github-actions"]

provisioner "shell" {
  script       = "user_data.sh"
  pause_before = "10s"
  timeout      = "10s"
}    

}

  
