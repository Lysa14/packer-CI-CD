packer {
  required_plugins {
    outscale = {
      version = ">= 1.2.0"
      source = "github.com/outscale/outscale"
    }
  }
}

source "outscale-bsu" "github-actions" {
  access_key = "${{ secrets.OUTSCALE_ACCESS_KEY }}"
  secret_key = "${{ secrets.OUTSCALE_SECRET_KEY }}"
  region = "${{ secrets.OUTSCALE_REGION }}"
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
  user_data_file = "user-data.sh"
}

build {
  sources = ["source.outscale-bsu.github-actions"]
}

         
