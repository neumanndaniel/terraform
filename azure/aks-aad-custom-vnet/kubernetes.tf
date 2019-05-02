resource "kubernetes_cluster_role_binding" "k8s" {
  metadata {
    name = "${var.cluster_role_binding_name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "${var.aad_group_guid}"
  }
}
