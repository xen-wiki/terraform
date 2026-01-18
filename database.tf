resource "linode_database_mysql_v2" "database_1125" {
  label        = var.database_label
  region       = var.region
  engine_id    = var.database_engine
  type         = var.database_type
  cluster_size = var.database_cluster_size

  allow_list = [
    data.linode_instance_networking.application_1125.ipv4[0].public[0].address
  ]

  lifecycle {
    ignore_changes = [allow_list]
    prevent_destroy = true
  }

  depends_on = [
    linode_instance.application_1125
  ]
}
