resource "shoreline_notebook" "airflow_scheduler_crash_on_linux_server" {
  name       = "airflow_scheduler_crash_on_linux_server"
  data       = file("${path.module}/data/airflow_scheduler_crash_on_linux_server.json")
  depends_on = [shoreline_action.invoke_mem_disk_cpu_usage,shoreline_action.invoke_restart_airflow_scheduler]
}

resource "shoreline_file" "mem_disk_cpu_usage" {
  name             = "mem_disk_cpu_usage"
  input_file       = "${path.module}/data/mem_disk_cpu_usage.sh"
  md5              = filemd5("${path.module}/data/mem_disk_cpu_usage.sh")
  description      = "Insufficient server resources (memory, disk space, CPU) causing the scheduler to crash."
  destination_path = "/agent/scripts/mem_disk_cpu_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_airflow_scheduler" {
  name             = "restart_airflow_scheduler"
  input_file       = "${path.module}/data/restart_airflow_scheduler.sh"
  md5              = filemd5("${path.module}/data/restart_airflow_scheduler.sh")
  description      = "Restart the Apache airflow scheduler service to see if it resolves the issue."
  destination_path = "/agent/scripts/restart_airflow_scheduler.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mem_disk_cpu_usage" {
  name        = "invoke_mem_disk_cpu_usage"
  description = "Insufficient server resources (memory, disk space, CPU) causing the scheduler to crash."
  command     = "`chmod +x /agent/scripts/mem_disk_cpu_usage.sh && /agent/scripts/mem_disk_cpu_usage.sh`"
  params      = []
  file_deps   = ["mem_disk_cpu_usage"]
  enabled     = true
  depends_on  = [shoreline_file.mem_disk_cpu_usage]
}

resource "shoreline_action" "invoke_restart_airflow_scheduler" {
  name        = "invoke_restart_airflow_scheduler"
  description = "Restart the Apache airflow scheduler service to see if it resolves the issue."
  command     = "`chmod +x /agent/scripts/restart_airflow_scheduler.sh && /agent/scripts/restart_airflow_scheduler.sh`"
  params      = ["AIRFLOW_SCHEDULER"]
  file_deps   = ["restart_airflow_scheduler"]
  enabled     = true
  depends_on  = [shoreline_file.restart_airflow_scheduler]
}

