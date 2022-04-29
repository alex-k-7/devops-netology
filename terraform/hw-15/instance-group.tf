// Create SA
resource "yandex_iam_service_account" "sa-ig" {
    name      = "sa-for-ig"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
    folder_id = var.FOLDER_ID
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

// Create instance group
resource "yandex_compute_instance_group" "ig-1" {
    name               = "fixed-ig-with-balancer"
    folder_id          = var.FOLDER_ID
    service_account_id = "${yandex_iam_service_account.sa-ig.id}"
    instance_template {
        resources {
            cores  = 2
            memory = 1
            core_fraction = 20
        }
        boot_disk {
            initialize_params {
                image_id = "fd827b91d99psvq5fjit"
            }
        }
        network_interface {
            network_id = "${yandex_vpc_network.netology.id}"
            subnet_ids  = ["${yandex_vpc_subnet.netology-subnet-a.id}"]
        }
        metadata = {
            serial-port-enable = 1
            user-data = "${file(".terraform/user-data-www.txt")}"
        }
    }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }    

    allocation_policy {
        zones = [var.ZONE]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

    health_check {
        interval = 30
        timeout  = 5
        tcp_options {
            port = 22
        }
    }

    load_balancer {
        target_group_name = "first-target-group"
    }    
}

//Create balancer
resource "yandex_lb_network_load_balancer" "balancer-1" {
  name = "my-network-balancer"
  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.ig-1.load_balancer[0].target_group_id}"
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}