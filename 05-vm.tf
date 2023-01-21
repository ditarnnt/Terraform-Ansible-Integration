resource "google_compute_instance" "nginx" {
  name         = "nginx"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = local.network

    access_config {}
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.nginx.email
    scopes = ["cloud-platform"]
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait Until SSH is ready'"]
    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} nginx.yaml"
  }
}

output "nginx_ip" {
  value = google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip
}
