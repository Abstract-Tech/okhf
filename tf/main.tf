# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_network" "openedx_net" {
  name     = "openedx-internal"
  ip_range = "10.42.1.0/8"
}

resource "hcloud_network_subnet" "openedx_subnet" {
  network_id   = hcloud_network.openedx_net.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.42.1.0/24"
}

resource "hcloud_server" "mysql" {
  name        = "mysql"
  image       = "debian-12"
  server_type = "cpx21"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.2"
  }
}

resource "hcloud_server" "mongodb" {
  name        = "mongodb"
  image       = "debian-12"
  server_type = "cpx21"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.3"
  }
}

resource "hcloud_server" "redis" {
  name        = "redis"
  image       = "debian-12"
  server_type = "cpx11"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.4"
  }
}

resource "hcloud_server" "opensearch" {
  name        = "opensearch"
  image       = "debian-12"
  server_type = "cpx31"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.5"
  }
}

resource "hcloud_server" "mailserver" {
  name        = "mailserver"
  image       = "debian-12"
  server_type = "cpx11"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.6"
  }
}

resource "hcloud_server" "k3s_server" {
  name        = "k3s-server"
  image       = "debian-12"
  server_type = "cpx21"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.7"
  }
}

resource "hcloud_server" "k3s_agent_1" {
  name        = "k3s-agent-1"
  image       = "debian-12"
  server_type = "cpx31"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.openedx_net.id
    ip         = "10.42.1.8"
  }
}
