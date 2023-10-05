terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "airflow_scheduler_crash_on_linux_server" {
  source    = "./modules/airflow_scheduler_crash_on_linux_server"

  providers = {
    shoreline = shoreline
  }
}