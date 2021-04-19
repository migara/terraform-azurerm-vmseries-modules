variable "location" {
  description = "The Azure region to use."
  default     = "East US 2"
  type        = string
}

variable "create_resource_group_name" {
  description = "Name for a created resource group. The input is ignored if `existing_resource_group_name` is set. If null, uses an auto-generated name."
  default     = null
  type        = string
}

variable "existing_resource_group_name" {
  description = "Name for an existing resource group to use. If null, use instead `create_resource_group_name`."
  default     = null
  type        = string
}

variable "name_prefix" {
  description = "A prefix for all the names of the created Azure objects. It can end with a dash `-` character, if your naming convention prefers such separator."
  default     = "pantf-"
  type        = string
}

variable "username" {
  description = "Initial administrative username to use for all systems."
  default     = "panadmin"
  type        = string
}

variable "password" {
  description = "Initial administrative password to use for all systems. Set to null for an auto-generated password."
  default     = null
  type        = string
}

variable "vmseries" {
  description = <<-EOF
  Map of virtual machines to create to run VM-Series. Keys are the individual names, values
  are the objects containing the attributes unique to that individual virtual machine:

  - `avzone`: the Azure Availability Zone identifier ("1", "2", "3"). If unspecified, the Availability Set is created instead.
  - `trust_private_ip`: the static private IP to assign to the trust-side data interface (nic2). If unspecified, uses a dynamic IP.

  The hostname of each of the VM-Series will consist of a `name_prefix` concatenated with its map key.

  Basic:
  ```
  {
    "fw00" = { avzone = 1 }
    "fw01" = { avzone = 2 }
  }
  ```

  Full example:
  ```
  {
    "fw00" = {
      trust_private_ip = "192.168.0.10"
      avzone           = "1"
    }
    "fw01" = { 
      trust_private_ip = "192.168.0.11"
      avzone           = "2"
    }
  }
  ```
  EOF
}

variable "storage_account_name" {
  description = <<-EOF
  Default name of the storage account to create.
  The name you choose must be unique across Azure. The name also must be between 3 and 24 characters in length, and may include only numbers and lowercase letters.
  EOF
  default     = "pantfstorage"
  type        = string
}

variable "files" {
  description = "Map of all files to copy to bucket. The keys are local paths, the values are remote paths. Always use slash `/` as directory separator (unix-like), not the backslash `\\`. For example `{\"dir/my.txt\" = \"config/init-cfg.txt\"}`"
  default     = {}
  type        = map(string)
}

variable "storage_share_name" {
  description = "Name of storage share to be created that holds `files` for bootstrapping."
  type        = string
}

variable "management_ips" {
  description = "A map where the keys are the IP addresses or ranges that are permitted to access the out-of-band management interfaces belonging to firewalls and Panorama devices. The map's values are priorities, integers in the range 102-60000 inclusive. All priorities should be unique."
  type        = map(number)
}

# Subnet definitions
#  All subnet defs are joined with their vnet prefix to form a full CIDR prefix
#  ex. for management, ${management_vnet_prefix}${management_subnet}
#  Thus to change the VNET addressing you only need to update the relevent _vnet_prefix variable.
variable "virtual_network_name" {
  description = "The name of the VNet to create."
  type        = string
}

variable "address_space" {
  description = "The address space used by the virtual network. You can supply more than one address space."
  type        = list(string)
}

variable "network_security_groups" {
  description = "Definition of Network Security Groups to create. Refer to the `VNet` module documentation for more information."
}

variable "route_tables" {
  description = "Definition of Route Tables to create. Refer to the `VNet` module documentation for more information."
}

variable "subnets" {
  description = "Definition of Subnets to create. Refer to the `VNet` module documentation for more information."
}

variable "tags" {
  description = "A mapping of tags to assign to all of the created resources."
  type        = map(any)
  default     = {}
}

variable "olb_private_ip" {
  description = "The private IP address to assign to the Outbound Load Balancer. This IP **must** fall in the `private_subnet` network."
  default     = "10.110.0.21"
}

variable "frontend_ips" {
  description = "A map of objects describing LB Frontend IP configurations and rules. See the module's documentation for details."
}

variable "common_vmseries_sku" {
  description = "VM-series SKU - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "bundle2"
  type        = string
}

variable "common_vmseries_version" {
  description = "VM-series PAN-OS version - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "9.1.3"
  type        = string
}

variable "common_vmseries_vm_size" {
  description = "Azure VM size (type) to be created. Consult the *VM-Series Deployment Guide* as only a few selected sizes are supported."
  default     = "Standard_D3_v2"
  type        = string
}

variable "common_vmseries_tags" {
  description = "A map of tags to be associated with the virtual machines, their interfaces and public IP addresses."
  default     = {}
  type        = map
}
