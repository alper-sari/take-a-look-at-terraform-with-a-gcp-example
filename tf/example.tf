provider "google" {
   project     = "<your-project-id>"
   region      = "us-central1"
}

resource "google_compute_network" "MyResource" {
   name = "vpc-a"
   auto_create_subnetworks = false
   mtu = 1460
}

resource "google_compute_subnetwork" "MyResource" {
   name          = "vpc-a-central1"
   ip_cidr_range = "10.0.0.0/24"
   network       = "vpc-a"
   region        = "us-central1"
}

resource "google_compute_instance" "MyResource" {
   name = "nginx"
   machine_type = "n1-standard-1"
   zone = "us-central1-c"
   #
   boot_disk {
     initialize_params {
       image = "ubuntu-2004-focal-v20240110"
       size  = 30
       type  = "pd-balanced"
     }
   }
   network_interface {
     network = "vpc-a"
     subnetwork = "vpc-a-central1"
     access_config {
      network_tier = "PREMIUM"
    }
   }
   metadata_startup_script = "sudo apt update -y && sudo apt install nginx -y"
   
}

resource "google_compute_firewall" "MyResource" {
   name = "allow-http-https-icmp"
   network = "vpc-a"
   allow {
       protocol = "icmp"
   }
   allow {
       protocol = "tcp"
       ports = ["80","443","22"]
   }
   source_ranges = [ "0.0.0.0/0" ]
}