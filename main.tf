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
  warehouse_size = "large"

  auto_suspend = 60
}
