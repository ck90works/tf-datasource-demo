provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "terraform" {
  metadata {
    name = "terraform-ns"
  }
}

resource "kubernetes_service" "beispiel" {
  metadata {
    name      = "beispiel-service"
    namespace = kubernetes_namespace.terraform.metadata[0].name
  }

  spec {
    selector = {
      app = "beispiel-app"
    }

    port {
      port        = 8080
      target_port = 80
    }
  }
}

data "kubernetes_service" "beispiel_service_data" {
  metadata {
    name      = kubernetes_service.beispiel.metadata[0].name
    namespace = kubernetes_namespace.terraform.metadata[0].name
  }
}

output "beispiel_service_cluster_ip" {
  value = data.kubernetes_service.beispiel_service_data.spec[0].cluster_ip
}