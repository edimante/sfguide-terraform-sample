terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}

provider "snowflake" {
  role  = "SYSADMIN"
}

resource "snowflake_database" "db" {
  name     = "ELINA_TF_DB"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "ELINA_TF_WH"
  warehouse_size = "large"

  auto_suspend = 60
}
