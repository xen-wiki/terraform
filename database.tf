resource "linode_database_mysql_v2" "database_1125" {
  label        = var.database_label
  region       = var.region
  engine_id    = var.database_engine
  type         = var.database_type
  cluster_size = var.database_cluster_size

  # Extension:Cargo creates tables without primary keys (both its core tables
  # and per-template data tables at runtime), which the managed MySQL default
  # sql_require_primary_key=ON rejects with Error 3750.
  engine_config_mysql_sql_require_primary_key = false

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
