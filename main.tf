terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}

provider "snowflake" {
  account  = "bk68410"
  region = "ca-central-1.aws"
  username = "elina-tf-snow"
  private_key_path = "/home/ubuntu/.ssh/snowflake_tf_snow_key.p8"
  role   = "SYSADMIN"
}

resource "snowflake_database" "db" {
  name     = "ELINA_TF_DB"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "ELINA_TF_WH"
  warehouse_size = "small"
  auto_suspend = 60
}

provider "snowflake" {
    alias  = "security_admin"
    role   = "SECURITYADMIN"
    region = "ca-central-1.aws"
}

resource "snowflake_role" "role" {
    provider = snowflake.security_admin
    name     = "ELINA_TF_SVC_ROLE"
}

resource "snowflake_database_grant" "grant" {
    provider          = snowflake.security_admin
    database_name     = snowflake_database.db.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}

resource "snowflake_schema" "schema" {
    database   = snowflake_database.db.name
    name       = "ELINA_TF_SC"
    is_managed = false
}

resource "snowflake_schema_grant" "grant" {
    provider          = snowflake.security_admin
    database_name     = snowflake_database.db.name
    schema_name       = snowflake_schema.schema.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}

resource "snowflake_table_grant" "grant1" {
  database_name     = snowflake_database.db.name
  schema_name       = snowflake_schema.schema.name
  table_name = snowflake_table.table.name
  privilege = "INSERT"
  roles     = [snowflake_role.role.name]
}

resource "snowflake_table_grant" "grant2" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.db.name
  schema_name       = snowflake_schema.schema.name
  privilege = "INSERT"
  roles     = [snowflake_role.role.name]

  on_future         = true
}

resource "snowflake_warehouse_grant" "grant" {
    provider          = snowflake.security_admin
    warehouse_name    = snowflake_warehouse.warehouse.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}

resource "tls_private_key" "svc_key" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

resource "snowflake_user" "user" {
    provider          = snowflake.security_admin
    name              = "elina_tf_test_user"
    default_warehouse = snowflake_warehouse.warehouse.name
    default_role      = snowflake_role.role.name
    default_namespace = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
    rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "snowflake_role_grants" "grants" {
    provider  = snowflake.security_admin
    role_name = snowflake_role.role.name
    users     = [snowflake_user.user.name]
}

resource "snowflake_table" "table" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "ELINA_TF_TABLE"

  column {
    name     = "id"
    type     = "int"
  }

  column {
    name     = "data"
    type     = "text"
    nullable = false
  }

  column {
    name = "DATE"
    type = "TIMESTAMP_NTZ(9)"
  }
}
