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

##################### internal network creation ###############
resource "openstack_networking_network_v2" "internal_network_1" {
  name           = var.network.internal_network_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_2" {
  name = var.network.int_subnet
  network_id = "${openstack_networking_network_v2.internal_network_1.id}"
  cidr       = var.network.internal_network_cidr
  ip_version = 4
}

################### create router ######################
resource "openstack_networking_router_v2" "router_1" {
  name                = "router_001"
  admin_state_up      = true
  external_network_id = "${openstack_networking_network_v2.provider_network.id}"
}

resource "openstack_networking_router_interface_v2" "interface_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.provider_network_sub.id}"
}

resource "openstack_networking_router_route_v2" "router_route_1" {
  router_id        = "${openstack_networking_router_v2.router_1.id}"
  destination_cidr = var.network.internal_network_cidr
  next_hop         = var.network.next_hop
}
