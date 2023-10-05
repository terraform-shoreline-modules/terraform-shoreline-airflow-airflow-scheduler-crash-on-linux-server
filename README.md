
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Airflow Scheduler Crash on Linux Server
---

This incident type involves the crash of the Apache Airflow scheduler on a Linux server. Apache Airflow is an open-source platform to programmatically author, schedule, and monitor workflows. The scheduler manages the execution of workflows and their tasks. When the scheduler crashes, it can cause workflow failures and disruptions in the overall system. This type of incident requires investigation and troubleshooting to identify the root cause of the crash and implement a solution to prevent it from recurring.

### Parameters
```shell
export AIRFLOW_SCHEDULER="PLACEHOLDER"

export AIRFLOW_SCHEDULER_LOG="PLACEHOLDER"

export SYSLOG="PLACEHOLDER"
```

## Debug

### Check if Apache Airflow scheduler is currently running
```shell
ps aux | grep airflow
```

### Check the status of the Apache Airflow scheduler service
```shell
systemctl status ${AIRFLOW_SCHEDULER}
```

### Check if the Airflow configuration file is valid
```shell
airflow check
```

### Check the scheduler logs for any errors
```shell
tail -n 100 ${AIRFLOW_SCHEDULER_LOG}
```

### Check the system logs for any relevant errors
```shell
tail -n 100 ${SYSLOG}
```

### Check the disk space usage on the server
```shell
df -h
```

### Check the memory usage on the server
```shell
free -m
```

### Check the CPU usage on the server
```shell
top
```

### Check if there are any other processes consuming too much resources
```shell
ps aux | sort -nrk 3,3 | head -n 5
```

### Insufficient server resources (memory, disk space, CPU) causing the scheduler to crash.
```shell
bash

#!/bin/bash



# Check memory usage

free_output=$(free -m)

total_mem=$(echo "$free_output" | awk '/Mem:/ {print $2}')

used_mem=$(echo "$free_output" | awk '/Mem:/ {print $3}')

free_mem=$(echo "$free_output" | awk '/Mem:/ {print $4}')

mem_usage=$(echo "scale=2; $used_mem/$total_mem*100" | bc)

if (( $(echo "$mem_usage > 90" | bc -l) )); then

  echo "Memory usage is high ($mem_usage%)."

fi



# Check disk usage

df_output=$(df -h)

disk_usage=$(echo "$df_output" | awk '/\/$/ {print $5}' | sed 's/%//')

if (( disk_usage > 90 )); then

  echo "Disk usage is high ($disk_usage%)."

fi



# Check CPU usage

top_output=$(top -bn1)

cpu_usage=$(echo "$top_output" | awk '/^%Cpu/ {print $2}')

if (( $(echo "$cpu_usage > 90" | bc -l) )); then

  echo "CPU usage is high ($cpu_usage%)."

fi


```

## Repair

### Restart the Apache airflow scheduler service to see if it resolves the issue.
```shell


#!/bin/bash

sudo systemctl restart ${AIRFLOW_SCHEDULER}


```