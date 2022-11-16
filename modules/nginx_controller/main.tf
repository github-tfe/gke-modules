resource "kubernetes_namespace" "example" {
  metadata {
    labels = {
      mylabel = "nginix-ingress"
    }
    name = "nginix-ingress"
  }
}

resource "helm_release" "nginix-ingress" {
  name      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart     = "ingress-nginx"
  namespace = kubernetes_namespace.example.id
}