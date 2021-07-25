################# provider configuration ################# 

variable "provider_data" {
	type = map(string)
	default = {
  user_name = "tladmin"
  tenant_name = "development"
  password = "tladmin@2021"
  auth_url = "http://192.168.10.220:5000"
  region = "RegionOne"
	}
}

################# network configuration ################# 

variable "network" {
	type = map(string)
	default = {
	name = "public1"
	subnet = "public1-subnet"
	provider_cidr = "192.168.10.0/24"
	
	}
}