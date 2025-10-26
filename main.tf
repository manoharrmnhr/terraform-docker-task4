terraform {
  required_version = ">= 1.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.19"   # adjust if you want a different minor
    }
  }
}

# Provider configuration
provider "docker" {
  # On Linux:
  host = "unix:///var/run/docker.sock"

  # On Windows (named pipe) use:
  # host = "npipe:////./pipe/docker_engine"

  # On macOS + Docker Desktop usually unix socket works.
}

# Pull an nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create a container from the image
resource "docker_container" "web" {
  name  = "terraform-nginx-example"
  image = docker_image.nginx.latest

  # Map host 8080 -> container 80
  ports {
    internal = 80
    external = 8088
  }

  # Optional: restart policy
  restart = "unless-stopped"
}

# Useful outputs
output "container_id" {
  value = docker_container.web.id
}

output "container_name" {
  value = docker_container.web.name
}
