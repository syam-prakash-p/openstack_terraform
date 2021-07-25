################# provider configuration ################# 


terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}


provider "openstack" {
  user_name   = var.provider_data.user_name
  tenant_name = var.provider_data.tenant_name
  password    = var.provider_data.password
  auth_url    = var.provider_data.auth_url
  region      = var.provider_data.region
}

##################### internet #################
resource "openstack_networking_network_v2" "provider_network" {
  name           = var.network.name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "provider_network_sub" {
  name       =  var.network.subnet
  network_id = "${openstack_networking_network_v2.provider_network.id}"
  cidr       = var.network.provider_cidr
  ip_version = 4
}

