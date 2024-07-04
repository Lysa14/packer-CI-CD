packer {
  required_plugins {
    outscale = {
      version = ">= 1.2.0"
      source = "github.com/outscale/outscale"
    }
  }
}


source "outscale-bsu" "github-actions" {
  access_key = {{ OUTSCALE_ACCESS_KEY }}
  secret_key = {{ OUTSCALE_SECRET_KEY }}
  region = {{ OUTSCALE_REGION }}
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

  
