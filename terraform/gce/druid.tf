// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("${var.gce_key_path}")}"
  project     = "redguide-169212"
  region      = "us-east1-c"
}

resource "google_compute_instance" "default" {
  name         = "druid-${count.index}"
  machine_type = "n1-standard-2"
  zone         = "us-east1-c"

  tags = ["druid-historical"]

  disk {
    image = "centos-7-v20170124"
  }

  metadata {
    roles = "druid-historical"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "null_resource" "provision" {
  provisioner "local-exec" {
    command = "sleep 30 && echo \"[webserver]\n${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip} ansible_connection=ssh ansible_ssh_user=aleksey_hariton ansible_become=yes\" > inventory &&  ansible-playbook -i inventory default-terraform.yml"
  }
}